# ChatLog - Conversation Management System for Qwen Code

## Project Overview

ChatLog is a conversation management system for Qwen Code that automatically saves and organizes your AI-assisted coding sessions. Every conversation is logged to `{project}/docs/conversations/` in a deterministic, human-readable, searchable format.

This repository contains the complete development project for ChatLog, including all necessary files, documentation, and automation scripts.

## Project Structure

```
ChatLog/
├── assets/
│   └── ChatLog-Splash.txt          # Splash art displayed at session start
├── docs/
│   └── ChatLog-Convention.md       # Conversation rules and documentation
├── INSTALL.bat                     # Automated installation script
├── VERIFY.bat                      # Installation verification script
├── UNINSTALL.bat                   # Clean removal script
├── DEVELOPMENT.bat                 # Post-development workflow script
├── README.md                       # Quick start guide
├── DOCUMENTATION.md                # Comprehensive documentation
├── SKILL.md                        # Main skill definition file
└── ... (additional documentation files)
```

**Important:** This is a multi-file skill. All files must be installed together for proper functionality. The `SKILL.md` file alone is not sufficient.

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

## Installation

### Automated Installation (Recommended)
1. Run `INSTALL.bat` as administrator
2. Follow the prompts to complete installation

### Manual Installation
1. Copy the `chatlog` folder to your Qwen Code skills directory:
   `%USERPROFILE%\.agents\skills\chatlog\`
2. For each project where you want to use ChatLog:
   - Create a `docs/conversations/` directory in your project root
   - Add the ChatLog configuration to your project's `MEMORY.md` file

## Usage

Once installed, ChatLog will automatically prompt you at the beginning of each session to:
1. Apply the conversation convention
2. Continue with the active project
3. Load previous session context if desired

Conversations are saved automatically when any of the 6 triggers occur:
1. Explicit "VÉGE" command
2. Computer shutdown/sleep
3. OpenClaw closes
4. New session starts
5. Unusual silence (30+ minutes)
6. Crash/freeze

## Development Workflow

After making changes to ChatLog, run `DEVELOPMENT.bat` to:
1. Create Git commits
2. Push changes to GitHub
3. Update the ChatLog installation on your system

## Version History

### Current Version: v1.0.0
- Initial release as a standalone development project
- Complete system with all necessary files
- Automated installation, verification, and uninstallation scripts
- Comprehensive documentation
- Git repository ready for GitHub publishing

## License

MIT (free) / Commercial (paid)

## Author

Sandor Haden

## GitHub

This project is ready for GitHub publishing. Follow the instructions in `CREATE_GITHUB_REPO.md` to set up the repository.