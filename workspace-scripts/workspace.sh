#!/bin/bash

# Function to check if an application is already open
is_app_open() {
    app_name=$1
    if wmctrl -l | grep -i "$app_name" > /dev/null; then
        return 0  # Application is open
    else
        return 1  # Application is not open
    fi
}

# Function to open an application in a new workspace
open_in_new_workspace() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 <application_name> <window_name>"
        exit 1
    fi

    # Check if the application is already open
    if is_app_open "$2"; then
        echo "$2 is already running, skipping opening."
        return 0  # Skip opening the app if it's already running
    fi

    # Get the currently active workspace
    active_workspace=$(wmctrl -d | grep '*' | awk '{print $1}')
    num_workspaces=$(wmctrl -d | wc -l)
    new_workspace=$((active_workspace + 1))

    # Create a new workspace if needed
    wmctrl -n $((num_workspaces + 1))

    # Switch to the new workspace
    wmctrl -s $new_workspace

    # Open the application in the new workspace
    $1 &
    sleep 2

    # Check if the application is running
    if ! pgrep -f "$2" > /dev/null
    then
        echo "Failed to open $2 in the workspace."
        return 1
    fi

    # Get the window ID and move it to the correct workspace
    app_win_id=$(wmctrl -l | grep "$2" | awk '{print $1}')
    wmctrl -ir $app_win_id -t $new_workspace

    # Optionally switch back to the original workspace
    wmctrl -s $active_workspace
}

# Function to reorganize workspace by repositioning windows of running applications
reorganize_workspace() {
    # List of applications you want to manage with exact matching criteria
    apps=("Google Chrome" "Visual Studio Code" "Eclipse IDE")

    for app in "${apps[@]}"; do
        # Check if the application is running
        if is_app_open "$app"; then
            # Get the window ID and reposition the window
            app_win_id=$(wmctrl -l | grep -i "$app" | awk '{print $1}')
            wmctrl -ir $app_win_id -e 0,100,100,800,600  # Change the position and size as needed
            echo "$app is already running, repositioning window."
        else
            echo "$app is not running, skipping repositioning."
        fi
    done
}

# Example usage
open_in_new_workspace "google-chrome-stable" "Google Chrome"
open_in_new_workspace "code" "Visual Studio Code"
open_in_new_workspace "/opt/eclipse/eclipse" "Eclipse IDE"

# Organize the workspace if the applications are already open
reorganize_workspace
