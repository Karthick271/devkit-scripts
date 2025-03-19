# Developer Cheat Sheets & Scripts

This repository contains a collection of frequently used commands, scripts, and shortcuts for developers. It includes scripts for automating tasks, helpful commands for Git, Python, Linux, and MySQL, and other useful tools. The goal of this repository is to provide a personal cheat sheet for development purposes.

## Folder Structure

- **workspace-scripts/**: Scripts for managing Linux workspaces and launching applications in new workspaces.
- **python-scripts/**: Common Python scripts and useful code snippets.
- **linux-shortcuts/**: A collection of Linux terminal shortcuts and commands.
- **git-commands/**: Frequently used Git commands for version control.
- **mysql-commands/**: Useful MySQL commands for database management.

## Scripts in `workspace-scripts/workspace.sh`

This file contains a script that opens applications in a new workspace on a Linux system. It is helpful for managing multiple applications and workspaces for efficient development. The script uses `wmctrl` to manage workspaces and application windows.

### Functions in `workspace.sh`:
1. **open_in_new_workspace**: Opens an application in a new workspace.
2. The script demonstrates opening:
   - Google Chrome
   - Visual Studio Code
   - Eclipse

### How to Use:

1. Make sure you have `wmctrl` installed on your Linux system.
2. Save the `workspace.sh` script in your preferred directory.
3. Run the script using the following command:

```bash
bash workspace.sh
