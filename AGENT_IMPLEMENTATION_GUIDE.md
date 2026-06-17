# ChatLog v1.2.0 Implementation Guide for Agent

## Quick Start

A ChatLog skill újabb verziójának implementációjához kövesse az alábbi lépéseket:

### 1. Session Start Flow

```python
# Pseudo-code: Session start
def start_session():
    # 1. Show splash art (from assets/ChatLog-Splash.txt)
    show_splash_art()
    
    # 2. ASK: Apply convention?
    if not ask_convention():
        return  # Skip logging
    
    # 3. ASK: Select project
    project_dir = ask_project_selection()
    
    # 4. ASK: Save path (default: {project}/docs/conversations/)
    save_path = ask_save_path(default=f"{project_dir}/docs/conversations/")
    
    # 5. ASK: Load previous session?
    load_mode = ask_session_load()  # (1) summary (2) last 20 (3) full (4) none
    
    # Store session metadata
    session_state = {
        "project": project_dir,
        "save_path": save_path,
        "start_time": get_local_time(),  # YYYY-MM-DD-HHhMMm
        "current_file": None,
        "current_file_size_kb": 0,
        "logging": True
    }
    return session_state
```

### 2. Message Append Handler

```python
# Pseudo-code: Append message to log
def append_message(user_msg, agent_msg, session_state):
    if not session_state["logging"]:
        return
    
    # Get or create current log file
    current_file = session_state.get("current_file")
    if not current_file:
        # First message: create new file
        start_time = session_state["start_time"]
        end_time = get_local_time()  # YYYY-MM-DD-HHhMMm
        current_file = f"{session_state['save_path']}/from-{start_time}-to-{end_time}.md"
        session_state["current_file"] = current_file
        create_log_file_header(current_file)
    
    # Append both messages to temp file
    temp_file = current_file + ".tmp"
    with open(current_file, "r", encoding="utf-8") as f:
        content = f.read()
    
    timestamp = get_local_time()
    new_content = content + f"\n### User | {timestamp}\n{user_msg}"
    new_content += f"\n### Agent | {timestamp}\n{agent_msg}"
    
    with open(temp_file, "w", encoding="utf-8") as f:
        f.write(new_content)
    
    # Check file size (BEFORE rename)
    file_size_kb = os.path.getsize(temp_file) / 1024
    session_state["current_file_size_kb"] = file_size_kb
    
    # Update END timestamp in filename
    start_time = extract_start_time(current_file)  # from-{START}-to-
    end_time = get_local_time()
    new_filename = f"from-{start_time}-to-{end_time}.md"
    new_path = f"{session_state['save_path']}/{new_filename}"
    
    # Atomic rename: temp -> new
    try:
        os.replace(temp_file, new_path)
        session_state["current_file"] = new_path
    except Exception as e:
        log_error(f"Atomic rename failed: {e}")
        os.remove(temp_file)  # Cleanup temp
        return False
    
    # CHECK: 50 KB reached?
    if file_size_kb > 50:
        handle_50kb_split(new_path, start_time, end_time, session_state)
    
    return True
```

### 3. 50 KB Split Handler

```python
# Pseudo-code: Handle 50 KB split
def handle_50kb_split(current_file, start_time, end_time, session_state):
    """
    When file > 50 KB:
    1. Add slug to current file
    2. Start new segment
    """
    
    # Step 1: Determine slug from conversation history
    # (For now: ask user or auto-extract from first 2-4 words)
    # Constraint: max 4 words, max 20 characters total
    slug = ask_topic_slug()  # Or: auto_extract_slug()
    # Validate: len(slug) <= 20 and slug.count('-') <= 3
    
    # Step 2: Rename current file with slug
    old_path = current_file
    new_path = old_path.replace(".md", f"-{slug}.md")
    os.rename(old_path, new_path)
    
    # Step 3: Start new segment
    # New segment START = previous END
    new_start_time = end_time
    new_end_time = get_local_time()
    new_segment_path = f"{session_state['save_path']}/from-{new_start_time}-to-{new_end_time}.md"
    
    create_log_file_header(new_segment_path)
    session_state["current_file"] = new_segment_path
    session_state["current_file_size_kb"] = 0.2  # Header size
```

### 4. Session End Handler

```python
# Pseudo-code: Handle session end
def end_session(session_state):
    """
    On any of 6 triggers: add slug to final file
    """
    if not session_state["logging"]:
        return
    
    current_file = session_state["current_file"]
    if not current_file:
        return
    
    # Check if slug already in filename
    if "-" not in current_file.split("/")[-1].split("-to-")[1]:
        # No slug yet, add it
        slug = ask_topic_slug()
        new_path = current_file.replace(".md", f"-{slug}.md")
        os.rename(current_file, new_path)
        current_file = new_path
    
    # Update metadata
    session_state["logging"] = False
    
    # Update index.md and MEMORY.md
    update_index_md(session_state)
    update_memory_md(session_state)
    
    print(f"Session saved: {current_file}")
```

---

## File Naming Reference

### During Session (No Slug)
```
from-2026-06-17-14h00m-to-2026-06-17-14h15m.md
from-2026-06-17-14h00m-to-2026-06-17-14h30m.md  ← END updated
from-2026-06-17-14h00m-to-2026-06-17-14h45m.md  ← END updated again
```

### After 50 KB Split
```
from-2026-06-17-14h00m-to-2026-06-17-14h45m-chatlog-append.md  ← Slug added
from-2026-06-17-14h45m-to-2026-06-17-15h00m.md                 ← New segment, no slug
```

### After Session End
```
from-2026-06-17-14h45m-to-2026-06-17-22h30m-chatlog-append.md  ← Slug added
```

---

## Atomicity Pattern

### Atomic Write + Rename
```python
def atomic_write_with_rename(target_path, new_content, new_filename):
    """
    STEP 1: Write to temp file
    STEP 2: Atomic rename (platform-native)
    """
    import tempfile
    import os
    
    # Create temp in same directory (ensures same filesystem)
    dir_path = os.path.dirname(target_path)
    with tempfile.NamedTemporaryFile(
        mode="w", 
        dir=dir_path, 
        encoding="utf-8", 
        delete=False
    ) as tmp:
        tmp.write(new_content)
        tmp_path = tmp.name
    
    try:
        # Atomic rename (platform-native)
        os.replace(tmp_path, target_path)
        return True
    except Exception as e:
        # Cleanup on error
        try:
            os.unlink(tmp_path)
        except:
            pass
        raise e
```

---

## Error Recovery

### Crash Recovery
If temp files exist after crash:
```python
def recover_from_crash(save_path):
    """Clean up leftover temp files"""
    import glob
    for tmp_file in glob.glob(f"{save_path}/*.md.tmp"):
        try:
            os.unlink(tmp_file)
        except:
            pass
```

### Rename Failure
```python
def append_with_retry(user_msg, agent_msg, session_state, max_retries=3):
    for attempt in range(max_retries):
        try:
            return append_message(user_msg, agent_msg, session_state)
        except Exception as e:
            log_error(f"Append retry {attempt+1}/{max_retries}: {e}")
            time.sleep(0.5 * (attempt + 1))
    
    # Give up, log error
    log_error(f"Max retries exceeded for append")
    return False
```

---

## Testing Notes

- Automated PowerShell test scripts were removed per repository cleanup.
- Maintain the checklist externally or recreate automated tests as needed.

---

## References

- **SKILL.md**: Full feature documentation
- **ChatLog-Convention.md**: File naming & structure rules
- **IMPLEMENTATION_REPORT_v1.2.0.md**: Detailed report


---

## Contact

For questions or issues, refer to:
- GitHub: https://github.com/SandorHaden/ChatLog
- Author: Sandor Haden (Sanyi)

---

**Version:** v1.2.0  
**Date:** 2026-06-17  
**Status:** Ready for Agent Implementation
