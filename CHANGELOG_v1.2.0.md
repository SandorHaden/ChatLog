# ChatLog v1.2.0 — Per-Message Append & Project Selection

## What's New?

ChatLog has been significantly enhanced with **real-time per-message logging**, **project selection**, and **intelligent 50 KB segmentation**. This release ensures that conversations are never lost, even if the session crashes, freezes, or exceeds context limits.

### Key Features

#### 🎯 Project Selection at Startup
- You're now asked **which project** you're working on at session start
- Suggested save path: `{project}/docs/conversations/` (ChatLog Convention)
- Can override with custom save directory

#### 📝 Per-Message Append (Real-Time Logging)
- **Every message is logged immediately**, not just at session end
- Append happens after each user + agent message pair
- **No data loss** on crashes, freezes, or context overflow

#### ⏰ Dynamic END Timestamp Updates
- File names reflect the actual session timeline
- Updated with each message: `from-START-to-{NOW}.md`
- Atomic rename ensures consistency

#### 📊 50 KB Intelligent Segmentation
- When file reaches 50 KB, it automatically:
  1. **Receives a slug** (topic identifier): `from-START-to-END-{slug}.md`
  2. **New segment starts** with continuous time link: `from-{prev_END}-to-{new_END}.md`
- No more `_r1`, `_r2` suffixes — **time-based continuous chain instead**

#### 🔐 Crash-Safe Atomicity
- Temp file + atomic rename ensures no partial writes
- Lock file support for concurrent access
- Automatic recovery if process crashes

---

## File Structure

```
{project}/docs/conversations/
├── index.md                                              # Catalog
├── from-2026-06-17-10h00m-to-2026-06-17-14h30m.md      # Session 1
├── from-2026-06-17-14h30m-to-2026-06-17-18h45m.md      # Session 2 (continuous)
├── from-2026-06-17-18h45m-to-2026-06-17-22h30m-chatlog-v1.2.md  # With slug at end
└── meta/
    └── ChatLog-Convention.md
```

### Filename Breakdown
- `from-` + `{START-TIME}` — When conversation began
- `-to-` + `{END-TIME}` — Latest update (refreshes per message)
- `-{slug}` — Topic identifier (added at 50 KB split or session end)

**Time Format:** `YYYY-MM-DD-HHhMMm` (e.g., `2026-06-17-21h44m`)

---

## How It Works

### Example Flow

```
1. User starts session
   → Asked: "Which project?" → Selects ChatLog
   → Asked: "Save to ./docs/conversations/?" → Yes
   → Splash art shown
   → Conversation begins

2. User sends first message
   → File created: from-2026-06-17-21h00m-to-2026-06-17-21h00m.md
   → Message appended + header written
   → File saved (atomic)

3. Multiple messages exchanged
   → Each message:
     a) Appended to log
     b) END timestamp updated in filename
     c) File renamed atomically: from-...-to-2026-06-17-21h15m.md

4. 50 KB reached
   → Current file: from-2026-06-17-21h00m-to-2026-06-17-21h45m.md
   → Renamed with slug: from-2026-06-17-21h00m-to-2026-06-17-21h45m-chatlog-v1.md
   → New segment starts: from-2026-06-17-21h45m-to-2026-06-17-21h45m.md

5. Session ends (user says "Bezárom" / program crashes / etc.)
   → Final file tagged with slug: from-2026-06-17-21h45m-to-2026-06-17-22h30m-chatlog-v1.md
   → index.md updated
   → MEMORY.md updated
```

---

## Getting Started

### Prerequisites
- ChatLog Skill v1.2.0+ installed
- Project workspace with `{project}/docs/conversations/` folder
- Agent supporting new session-start flow

### First Session
1. Start a new conversation
2. **Answer "Yes"** when asked about conversation convention
3. **Select your project** (e.g., "ChatLog")
4. **Confirm save path** (default: `./docs/conversations/`)
5. **Choose load mode** if resuming (or skip for new session)
6. Start working — logging is automatic!

### Resuming a Session
1. Start a new conversation
2. **Answer "Yes"** to convention
3. **Select same project**
4. **Choose load mode** for previous session:
   - (1) Summary from MEMORY.md
   - (2) Last 20 messages
   - (3) Full conversation file
   - (4) Start fresh
5. Continue working

---

## File Content Example

```markdown
# Munkamenet: chatlog-v1.2

## Metaadat
- **Kezdés:** 2026-06-17 21:00 (CET)
- **Befejezés:** 2026-06-17 21:45
- **Projekt:** ChatLog
- **Státusz:** folyamatban

## Tartalom

### User | 2026-06-17-21h00m
Mi a ChatLog v1.2 új funkciója?

### Agent | 2026-06-17-21h01m
A ChatLog v1.2 valós idejű üzenetenkénti naplózást vezet be...

### User | 2026-06-17-21h05m
Jó! Hogy működik a 50 KB szegmentálás?

### Agent | 2026-06-17-21h06m
Amikor a fájl eléri az 50 KB-ot:
1. Az aktuális fájl slug-ot kap
2. Új szegmens indul az előző END időpontjából...

## Összefoglaló
- ChatLog v1.2 per-message append logika elfogadva
- 50 KB szegmentálás jól működik
- Atomi írások garantáltak
```

---

## Troubleshooting

### "File not found" when appending
→ Check that `{project}/docs/conversations/` exists and is writable

### Filename too long error
→ Topic slug limited to max. 5 words, ASCII-only
→ Use shorter project path if needed

### Temp files left after crash
→ Agent auto-cleans on recovery
→ Manual cleanup: Delete `*.md.tmp` files in conversations folder

### Messages appear out of order
→ Messages are ordered by timestamp in metadata
→ Check for timezone mismatches (should use CET/CEST)

---

## Advanced Topics

### Custom Save Path
Instead of default `{project}/docs/conversations/`, you can:
1. Choose a custom folder at session start
2. Use relative paths (e.g., `./my-logs/`)
3. Use network paths (e.g., `\\server\shared\logs\`)

### Multi-Project Sessions
Each project maintains separate conversation files in its own `docs/conversations/` folder. Switching projects automatically switches save paths.

### Automated Backups
Backup structure files from `{project}/docs/conversations/` regularly:
```bash
tar -czf ~/backups/conversations-$(date +%Y%m%d).tar.gz {project}/docs/conversations/
```

### Searching Previous Conversations
Use `index.md` table to find relevant conversations by date/topic/size:
```bash
grep "chatlog" {project}/docs/conversations/index.md
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| **1.2.0** | 2026-06-17 | Per-message append, project selection, 50 KB segmentation |
| 1.1.0 | 2026-06-12 | Splash art on every session start |
| 1.0.0 | 2026-06-11 | Initial ChatLog skill release |

---

## Documentation

- **[SKILL.md](SKILL.md)** — Technical reference
- **[ChatLog-Convention.md](docs/ChatLog-Convention.md)** — File naming & structure
- **[AGENT_IMPLEMENTATION_GUIDE.md](AGENT_IMPLEMENTATION_GUIDE.md)** — For developers
- **[IMPLEMENTATION_REPORT_v1.2.0.md](IMPLEMENTATION_REPORT_v1.2.0.md)** — Detailed changelog

---

## Support

**Questions?** Check the docs or contact the ChatLog team.

**Found a bug?** Open an issue: https://github.com/SandorHaden/ChatLog/issues

**Want to contribute?** See DEVELOPMENT.md

---

**Made with ❤️ by Sandor Haden**  
**ChatLog v1.2.0 — Every Conversation, Forever Logged**
