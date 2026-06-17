---
name: "chatlog"
description: "ChatLog — every conversation, forever logged. Splash art MINDIG megjelenik session-elején (új + folytatás). 6-trigger handler, from-to-topic format. Skill location: %USERPROFILE%\.agents\skills\chatlog\"
version: "1.0.0"
author: "Sandor Haden"
license: "MIT (free) / Commercial (paid)"
required_files:
  - "docs/ChatLog-Convention.md"
  - "assets/ChatLog-Splash.txt"
  - "assets/VERSION.txt"
optional_files:
  - "docs/SECURITY-MODEL.md"
installation_notes: "This skill requires additional files. Use INSTALL.bat for automatic setup or manually copy all files from the distribution package to %USERPROFILE%\\.agents\\skills\\chatlog\\"
compatibility: "Qwen Code v1.0+"
update_check: "powershell -ExecutionPolicy Bypass -File %SKILL_DIR%\\check_version.ps1"
---

# ChatLog — Every Conversation, Forever Logged

> **v1.1.0 frissítés (2026-06-12 17h48):** A splash art MINDEN alkalommal megjelenik session-elején, amikor a ChatLog bejelentkezik (új munkamenet + előző munkamenet folytatása + projekt-váltás). Sanyi kérésére.

```yaml
 ╔════════════════════════════════════════════════════════════════════════════════╗
 ║                                                                                ║
 ║   █████████  █████                 █████    █████                              ║
 ║  ███░░░░░███░░███                 ░░███    ░░███                               ║
 ║ ███     ░░░  ░███████    ██████   ███████   ░███         ██████   ███████      ║
 ║░███          ░███░░███  ░░░░░███ ░░░███░    ░███        ███░░███ ███░░███      ║
 ║░███          ░███ ░███   ███████   ░███     ░███       ░███ ░███░███ ░███      ║
 ║░░███     ███ ░███ ░███  ███░░███   ░███ ███ ░███      █░███ ░███░███ ░███      ║
 ║ ░░█████████  ████ █████░░████████  ░░█████  ███████████░░██████ ░░███████      ║
 ║  ░░░░░░░░░  ░░░░ ░░░░░  ░░░░░░░░    ░░░░░  ░░░░░░░░░░░  ░░░░░░   ░░░░░███      ║
 ║                                                                  ███ ░███      ║
 ║                                                                 ░░██████       ║
 ║                                                                  ░░░░░░        ║
 ║                                                                                ║
 ║   Made with care by Sandor Haden                      ://github.com            ║
 ║                                                         v1.0.0 | 2026          ║
 ║================================================================================║
 ║   The Chat-Saving Skill                                                        ║
 ║   Every conversation, forever logged.                                          ║
 ║================================================================================║
 ║                                                                                ║
 ║   >  Session-end handler:   ACTIVE (6 triggers)                                ║
 ║   >  Storage:               {project}/docs/conversations/                      ║
 ║   >  Format:                from-...-to-...-{topic}.md                         ║
 ║   >  License:               MIT (free) / Commercial (paid)                     ║
 ║   >  Author:                Sandor Haden                                       ║
 ║   >  Version:               v1.0.0 - 2026-06-11                                ║
 ║                                                                                ║
 ╚════════════════════════════════════════════════════════════════════════════════╝
```

## Purpose

A project-level memory layer for AI-assisted coding sessions. Every conversation is logged to `{project}/docs/conversations/` in a deterministic, human-readable, searchable format. Survives session restarts, model switches, and crashes.

## When to use

- Beginning a new project session ("Folytassuk az X projektet")
- Ending a session (6 triggers - see below)
- Resuming a previous session
- Searching past decisions, prompts, or code snippets

## Session-start mandatory flow (FRISSÍTVE: 2026-06-12)

**1. lépés: SPLASH ART megjelenítése (MINDIG)**
- Új munkamenet indításakor
- Előző munkamenet folytatásakor
- Projekt-váltáskor

**2. lépés: Kötelező kérdés-sor:**

1. "Alkalmazzuk-e a beszélgetés-konvenciót erre a munkamenetre?"
   - Yes → work according to convention
   - No → free, no file logging

2. If yes: "Folytassuk az aktív projektet: `{Active Project}`?"
   - Yes → load the most recent session as reference
   - No → list known projects, or create new project

3. If yes to 2: "Szeretnéd-e, hogy betöltsem az előző munkamenet:
   - (1) rövid összefoglalóját a MEMORY.md-ből
   - (2) az utolsó 20 üzenetét
   - (3) a teljes munkamenet-fájlt
   - (4) egyáltalán nem"

Only after this come topic-specific questions.

## The 6 session-end triggers

1. **Explicit "VÉGE"** — Sanyi says: "Munkamenet vége", "Bezárom", "jó éjszakát", etc.
2. **Computer shutdown / sleep** — Control UI disconnect
3. **OpenClaw closes** — Control UI closes
4. **New session starts** — old session goes "archív"
5. **Unusual silence** — 30+ minutes without message → ask
6. **Crash / freeze** — session interrupted, JSONL preserved

On trigger: 5-10 line summary → `MEMORY.md` "Aktuális gondolatmenet" + session file "## Összefoglaló" + `index.md` refresh.

## File format

**Filename:** `from-{start-LOCAL-YYYY-MM-DD-HHhMMm}-to-{end-LOCAL-YYYY-MM-DD-HHhMMm}-{topic-slug}.md`

- `from` precedes the start timestamp
- `to` precedes the end timestamp
- Time is always local (Europe/Budapest, CET/CEST)
- Topic slug: max 5 words, hyphen-separated, ASCII-only (no accents)
- File splitting: `_r1`, `_r2` suffix if file > 50 KB

## Storage structure

```
{project}/
└── docs/
    └── conversations/
        ├── meta/
        │   ├── ChatLog-Convention.md  (canonical rules, lives in skill)
        │   ├── chatlog-splash-art/
        │   │   └── SPLASH.md
        │   ├── ChatLog-Splash.txt  (canonical splash art source, lives in skill)
        │   └── SECURITY-MODEL.md
        ├── index.md
        ├── from-2026-06-11-...md
        └── from-2026-06-12-...md
```

**Note:** The canonical `ChatLog-Convention.md` and `ChatLog-Splash.txt` files are stored in the skill's own folder (`%USERPROFILE%\.agents\skills\chatlog\`), not in each project's `docs/conversations/meta/` folder. Projects only need to store their conversation files and a project-specific `index.md`.

## Installation and usage

### 1. Default setup

The skill requires a `MEMORY.md` file in the project containing:

```markdown
## Beszélgetés-konvenció

- Aktív projekt: {project name}
- Munkamenetek tárolása: {project folder}/docs/conversations/
- Dokumentum konvenciója: from-to-topic.md, 6 triggers, 4 loading modes
- Splash art: MINDIG megjelenik session-elején (új + folytatás)
```

### 2. First time

Before the first session:
1. Create `docs/conversations/` folder in project root
2. **Reference** the canonical `ChatLog-Convention.md` from the skill (no need to copy)
3. **Reference** the canonical `ChatLog-Splash.txt` from the skill (no need to copy)
4. Create `docs/conversations/index.md` (empty outline, ready to populate)
5. Add "Beszélgetés-konvenció" section to `MEMORY.md`

### 3. Every session

- The splash art is ALWAYS displayed at session start
- The session-start question flow is automatically posed by the model
- If "Yes" to convention, the model writes to `docs/conversations/`
- Session-end saving is activated by any of the 6 triggers

## Example: real project

The `c:\Users\Háden Sándor\source\repos\Air Stripper Modeller - VS Studio Code\docs\conversations\` folder in the Air Stripper Modeller project:
- 9 session files (8 segments for the 2026-06-10 session, 1 for 2026-06-11, 1 for 2026-06-12)
- ~375 KB text content
- Versioned across GitHub releases (v0.10.1-conv-rules, v0.10.2-conv-loaded, v0.10.3-conv-resume)

## Limitations and notes

- **Encoding:** Files contain UTF-8 Hungarian accented text. Windows console (Write-Host) shows `?` due to console encoding, but files are CORRECT. Solution: `chcp 65001` before PowerShell start.
- **Token limit:** Model context window limited (~128K tokens). Full 375 KB conversation does NOT fit at once, so "Gondolatmenet folytatása" offers 4 loading modes (summary / last 20 / full / none).
- **Splitting:** Files > 50 KB get `_r1`, `_r2`, ... suffix. Segments follow chronological order.
- **Not fully automatic:** Session-end handler is "manual" in the sense that the model calls it, not an external cron. Any of the 6 triggers can activate it.

## Version

- **v1.1.0** (2026-06-12 17h48) — Splash art MINDIG megjelenik session-elején (új + folytatás) — Sanyi kérésére
- **v1.0.0** (2026-06-12) — renamed from `conversation-convention` to `ChatLog`
- Source: Based on the original conversation-convention skill created with Sanyi on 2026-06-11
- GitHub: https://github.com/SandorHaden/ChatLog

## Automatic Update Feature

ChatLog now includes automatic version checking and update capabilities:

- **Version Checking**: Automatically checks GitHub for new versions on startup
- **Update Notifications**: Prompts user when newer versions are available
- **One-Click Updates**: Offers to download and install updates automatically
- **Background Checking**: Non-intrusive version checks that don't interrupt workflow
- **Automatic Backup**: Creates backup of current installation before updates
- **Rollback Capability**: Restore to previous versions if needed
- **External Recovery**: Standalone rollback utility for broken installations

To manually check for updates, run `UPDATE_CHECK.bat` from the ChatLog installation directory.

## Backup and Rollback System

ChatLog includes a comprehensive backup and rollback system to ensure safety during updates:

### Backup Features
- **Automatic Backups**: Created before every update
- **Timestamped Backups**: Each backup includes date and time
- **Complete Installation**: All files and configurations are backed up
- **Dedicated Storage**: Backups stored in `%USERPROFILE%\.agents\skills\chatlog_backup\`

### Rollback Features
- **Internal Rollback**: Accessible from within ChatLog via `rollback_chatlog.bat`
- **External Rollback**: Standalone `external_rollback.bat` can recover even if ChatLog is broken
- **Multiple Backup Versions**: Choose which backup to restore
- **Backup Information**: Each backup includes version and timestamp information

### Usage
1. **Automatic Backup**: Happens automatically before updates
2. **Manual Backup**: Run `backup_chatlog.bat` anytime to create a backup
3. **Rollback**: Run `rollback_chatlog.bat` to restore from a previous backup
4. **External Recovery**: Run `external_rollback.bat` if ChatLog is broken

### Safety Notes
- Backups are stored separately from the main installation
- Multiple backup versions are retained
- Rollback preserves all conversation logs and project data
- External rollback can be run even if ChatLog skill is corrupted

## Author & License

- **Author:** Sandor Haden
- **License:** MIT (free) / Commercial (paid)
- **Version:** v1.1.0