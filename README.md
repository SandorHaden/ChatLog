# ChatLog - Conversation Management System

ChatLog is a multi-file conversation management system for Qwen Code that automatically saves and organizes your AI-assisted coding sessions. Every conversation is logged to `{project}/docs/conversations/` in a deterministic, human-readable, searchable format.

**Note:** This skill consists of multiple files that must all be installed together for proper functionality.

## Features

- Automatic conversation logging with splash art display
- Project-level isolation of conversation histories
- 6 trigger points for session saving
- Standardized file naming convention
- Easy retrieval and search of past conversations
- **Automatic version checking and updates** - Checks GitHub for new versions on startup and offers to install updates automatically

## Installation

### Automated Installation (Recommended)

1. Clone this repository or download the latest release
2. Run `INSTALL.bat` as administrator
3. Follow the prompts to complete installation

This script will install all required files:
- `SKILL.md` - Main skill definition
- `docs/ChatLog-Convention.md` - Conversation rules and documentation
- `assets/ChatLog-Splash.txt` - Splash art displayed at session start

### Manual Installation

1. Clone this repository or download the latest release
2. Copy the entire `chatlog` folder to your Qwen Code skills directory:
   `%USERPROFILE%\.agents\skills\chatlog\`
3. Ensure all files are present in their correct subdirectories
4. For each project where you want to use ChatLog:
   - Create a `docs/conversations/` directory in your project root
   - Add the ChatLog configuration to your project's `MEMORY.md` file

**Important:** This skill requires multiple files to function properly. Installing only the `SKILL.md` file will result in incomplete functionality.

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

## Scripts

- `INSTALL.bat` - Automated installation script
- `VERIFY.bat` - Verification script to check installation
- `UNINSTALL.bat` - Uninstallation script
- `DEVELOPMENT.bat` - Development workflow script
- `UPDATE_CHECK.bat` - Manual update checking script
- `check_version.ps1` - PowerShell script for version checking (used by the skill)

## File Structure

```
{project}/
└── docs/
    └── conversations/
        ├── index.md
        ├── meta/
        │   └── ChatLog-Convention.md
        └── from-{start}-to-{end}-{topic}.md
```

## Git Repository

This project is maintained in a Git repository. To contribute or track changes:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `DEVELOPMENT.bat` to commit and push your changes
5. Create a pull request

## Version

v1.0.0 - Initial release

## License

MIT (free) / Commercial (paid)