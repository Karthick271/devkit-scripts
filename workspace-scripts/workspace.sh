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

# Function to open an application in a new workspace (desktop)
open_in_new_workspace() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 <application_name> <window_name>"
        exit 1
    fi

    # Get the currently active workspace
    active_workspace=$(wmctrl -d | grep '*' | awk '{print $1}')
    
    # Get the number of workspaces
    num_workspaces=$(wmctrl -d | wc -l)
    
    # Calculate the new workspace index (next available workspace)
    new_workspace=$((num_workspaces))

    # Create a new workspace (move to the right side)
    wmctrl -n $((num_workspaces + 1))

    # Switch to the new workspace
    wmctrl -s $new_workspace

    # Check if the application is already open
    if is_app_open "$2"; then
        echo "$2 is already running, skipping opening."
        return 0  # Skip opening the app if it's already running
    fi

    # Open the application in the new workspace
    $1 &
    sleep 2

    # Check if the application is running
    if ! pgrep -f "$2" > /dev/null
    then
        echo "Failed to open $2 in the workspace."
        return 1
    fi

    # Get the window ID of the application
    app_win_id=$(wmctrl -l | grep "$2" | awk '{print $1}')

    # Move the window to the correct workspace
    wmctrl -ir $app_win_id -t $new_workspace
}

# Function to reorganize workspace by repositioning windows of running applications
reorganize_workspace() {
    # Assign specific workspaces to applications
    # Workspace 0: Visual Studio Code
    # Workspace 1: Terminal 1
    # Workspace 2: Terminal 2
    # Workspace 3: Terminal 3
    # Workspace 4: Google Chrome Profile 1
    # Workspace 5: Google Chrome Profile 2
    # Workspace 6: Eclipse
    # Workspace 7: File Explorer
    # Workspace 8: Bitwarden (Last)

    apps=(
        "Visual Studio Code"
        "Terminal 1"
        "Terminal 2"
        "Terminal 3"
        "Google Chrome Profile 1"
        "Google Chrome Profile 2"
        "Eclipse"
        "File Explorer"
        "Bitwarden"
    )

    # Iterate over the apps and arrange them in specified workspaces
    for i in ${!apps[@]}; do
        app="${apps[$i]}"
        workspace_num=$i

        # Check if the application is running
        if is_app_open "$app"; then
            # Get the window ID
            app_win_id=$(wmctrl -l | grep -i "$app" | awk '{print $1}')
            
            # Move the window to the correct workspace
            wmctrl -ir $app_win_id -t $workspace_num

            # Optionally position the window (you can adjust x, y, width, and height as needed)
            if [[ $app == *"Terminal"* ]]; then
                wmctrl -ir $app_win_id -e 0,$((100 + workspace_num * 100)),100,800,600
            elif [[ $app == *"Google Chrome"* ]]; then
                wmctrl -ir $app_win_id -e 0,$((100 + workspace_num * 100)),100,1200,800
            elif [[ $app == "Bitwarden" ]]; then
                wmctrl -ir $app_win_id -e 0,2000,100,800,600  # Last position for Bitwarden
            else
                wmctrl -ir $app_win_id -e 0,100,100,800,600
            fi
            echo "$app is already running, repositioning window."
        else
            echo "$app is not running, skipping repositioning."
        fi
    done
}

# Example usage (opening each application in a new workspace)
open_in_new_workspace "code" "Visual Studio Code"
open_in_new_workspace "gnome-terminal" "Terminal 1"
open_in_new_workspace "gnome-terminal" "Terminal 2"
open_in_new_workspace "gnome-terminal" "Terminal 3"
open_in_new_workspace "google-chrome-stable --profile-directory=Profile1" "Google Chrome Profile 1"
open_in_new_workspace "google-chrome-stable --profile-directory=Profile2" "Google Chrome Profile 2"
open_in_new_workspace "/opt/eclipse/eclipse" "Eclipse IDE"
open_in_new_workspace "nautilus" "File Explorer"
open_in_new_workspace "bitwarden" "Bitwarden"

# Organize the workspace if the applications are already open
reorganize_workspace
