# ChatLog - Conversation Management System
## Comprehensive Documentation

### Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Version History](#version-history)
4. [Installation Guide](#installation-guide)
5. [Usage Guide](#usage-guide)
6. [Technical Documentation](#technical-documentation)
7. [File Structure](#file-structure)
8. [Development Process](#development-process)
9. [Distribution Package](#distribution-package)
10. [License](#license)

---

## Overview

ChatLog is a conversation management system for Qwen Code that automatically saves and organizes your AI-assisted coding sessions. Every conversation is logged to `{project}/docs/conversations/` in a deterministic, human-readable, searchable format.

The system ensures that all conversations are preserved across session restarts, model switches, and crashes, providing a comprehensive history of your AI-assisted development work.

## Features

### Automatic Conversation Logging
- Splash art display at session start (ALWAYS)
- Project-level isolation of conversation histories
- 6 trigger points for automatic session saving
- Standardized file naming convention with timestamps
- Easy retrieval and search of past conversations

### Session Management
- Session-start mandatory flow with user confirmation
- Session-end handler with 6 trigger points
- Automatic summary generation for MEMORY.md
- Index generation for easy navigation
- File segmentation for large conversations

### Integration
- Works with both OpenClaw and VS Code/Qwen Code interfaces
- User-level skill storage independent of client applications
- Git-compatible file structure for version control
- UTF-8 encoding support for Hungarian text

## Version History

### v1.1.0 (2026-06-12 17:48)
- Splash art MINDIG megjelenik session-elején (új + folytatás) - Sanyi kérésére
- Enhanced session-start flow

### v1.0.0 (2026-06-12)
- Initial release as ChatLog (renamed from conversation-convention)
- Based on the original conversation-convention skill created with Sanyi on 2026-06-11
- GitHub: https://github.com/SandorHaden/Air-Stripper-Modeller---VS-Studio-Code/releases/tag/v0.10.3-conv-resume

## Installation Guide

### Prerequisites
- Qwen Code installed and configured
- User skills directory at `C:\Users\Háden Sándor\.agents\skills\`

### Installation Steps

1. **Download the Distribution Package**
   - Clone this repository or download the latest release
   - Extract to a temporary location

2. **Install the Skill**
   - Copy the `chatlog` folder to your Qwen Code skills directory:
     `C:\Users\Háden Sándor\.agents\skills\chatlog\`
   - Ensure the following files are present:
     - `SKILL.md` - Main skill definition
     - `docs\ChatLog-Convention.md` - Conversation rules
     - `assets\ChatLog-Splash.txt` - Splash art

3. **Project Setup**
   For each project where you want to use ChatLog:
   a. Create a `docs/conversations/` directory in your project root
   b. Create `docs/conversations/index.md` (empty file is fine)
   c. Add the ChatLog configuration to your project's `MEMORY.md` file:
   
   ```markdown
   ## Beszélgetés-konvenció
   
   - Aktív projekt: {project name}
   - Munkamenetek tárolása: {project folder}/docs/conversations/
   - Dokumentum konvenciója: from-to-topic.md, 6 triggers, 4 loading modes
   - Splash art: MINDIG megjelenik session-elején (új + folytatás)
   ```

### Verification
- Start a new Qwen Code session
- You should see the ChatLog splash art at session start
- You should be prompted with the conversation convention questions

## Usage Guide

### Session Start Flow

When starting a new session, ChatLog will automatically prompt you with the following questions:

1. **"Alkalmazzuk-e a beszélgetés-konvenciót erre a munkamenetre?"**
   - Answer "Igen" to apply the conversation convention
   - Answer "Nem" for a free-form session without logging

2. **"Folytassuk az aktív projektet: `{Aktív projekt neve}`?"**
   - Answer "Igen" to continue with the active project
   - Answer "Nem" to select a different project or create a new one

3. **"Szeretnéd-e, hogy betöltsem az előző munkamenet:"**
   - (1) rövid összefoglalóját a MEMORY.md-ből
   - (2) az utolsó 20 üzenetét a munkamenet-fájlból
   - (3) a teljes munkamenet-fájlt (minden üzenetet)
   - (4) egyáltalán nem

### Session End Triggers

Conversations are saved automatically when any of the following 6 triggers occur:

1. **Explicit "VÉGE"** - When you explicitly end the session
2. **Computer shutdown/sleep** - When the computer goes to sleep or shuts down
3. **OpenClaw closes** - When the OpenClaw interface is closed
4. **New session starts** - When a new session begins
5. **Unusual silence** - After 30+ minutes without a message
6. **Crash/freeze** - When the session is interrupted

## Technical Documentation

### File Naming Convention

Conversation files follow this format:
`from-{start-LOCAL-YYYY-MM-DD-HHhMMm}-to-{end-LOCAL-YYYY-MM-DD-HHhMMm}-{topic-slug}.md`

Example:
`from-2026-06-10-04h23m-to-2026-06-10-18h24m-air-stripper-9-fazis.md`

### File Structure

```
{project}/
└── docs/
    └── conversations/
        ├── index.md                       # Session index
        ├── meta/
        │   └── ChatLog-Convention.md      # Conversation rules (reference)
        └── from-{start}-to-{end}-{topic}.md # Conversation files
```

### File Segmentation

- Ideal size: 20-30 KB
- Maximum size: 50 KB
- Files larger than 50 KB are segmented with `_r1`, `_r2`, etc. suffixes

### Internal File Structure

```markdown
# Munkamenet: {brief topic}

## Metaadat
- **Kezdés:** {YYYY-MM-DD HH:MM} ({CET|CEST})
- **Befejezés:** {YYYY-MM-DD HH:MM}
- **Időtartam:** {Xh Ym}
- **Futtatott modellek:** {list}
- **Projekt:** {project name}
- **Érintett fájlok:** {list}
- **Státusz:** {folyamatban | kész | megszakítva}

## Tartalom
[Literally copied message exchanges, Qwen prompts, code snippets,
 decisions, tool results, in chronological order]

## Összefoglaló
[Most important decisions, lessons learned, TODOs]

## Kapcsolódó munkamenetek
- {previous session filename}
- {next session filename}
```

## Development Process

### Post-Development Workflow

After each approved development step, the system will prompt you with the following questions:

1. **Create Git commit?**
   - Answer "Igen" to create a Git commit with the changes
   - Answer "Nem" to skip Git commit

2. **Push to GitHub?**
   - Answer "Igen" to push changes to GitHub
   - Answer "Nem" to skip GitHub push

3. **Update ChatLog on system?**
   - Answer "Igen" to update the ChatLog installation on your system
   - Answer "Nem" to skip system update

### Version Control

The project uses Git for version control with the following conventions:
- Feature branches for new development
- Semantic versioning (vX.Y.Z)
- GitHub releases for distribution
- Tag-based version tracking

## Distribution Package

### Package Contents

The ChatLog distribution package contains:
- `SKILL.md` - Main skill definition file
- `docs/ChatLog-Convention.md` - Conversation rules and documentation
- `assets/ChatLog-Splash.txt` - Splash art file
- `README.md` - Quick start guide
- `DOCUMENTATION.md` - Comprehensive documentation
- `INSTALL.bat` - Automated installation script (to be created)

### Installation Automation

For ease of installation, the distribution package includes:
- Automated installation script that copies files to the correct locations
- Verification script to confirm proper installation
- Uninstallation script to remove ChatLog if needed

### Target User Experience

The installation process should require minimal user intervention:
1. Download and extract the package
2. Run `INSTALL.bat`
3. Confirm installation location
4. Verify installation with Qwen Code

## License

### Licensing Terms

ChatLog is available under a dual licensing model:
- **MIT License (free)** - For personal and open-source use
- **Commercial License (paid)** - For commercial use and distribution

### Attribution

- **Author:** Sandor Haden
- **Copyright:** 2026 Sandor Haden
- **GitHub:** https://github.com/SandorHaden/ChatLog

For commercial licensing inquiries, please contact the author.