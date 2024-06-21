#!/bin/bash

# Base directory
BASE_DIR="/home/cpvbox/Sysad2"
CORE_HOME="$BASE_DIR/Core"
MENTEES_DIR="$CORE_HOME/mentees"
STATUS_FILE="$CORE_HOME/display_status.txt"

# Function to get the current timestamp
current_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Initialize the last run time
[ ! -f "$STATUS_FILE" ] && echo "1970-01-01 00:00:00" > "$STATUS_FILE"
last_run=$(cat "$STATUS_FILE")
echo "$(current_timestamp)" > "$STATUS_FILE"

# Command-line argument for domain filtering
filter_domain="$1"

# Count total mentees
total_mentees=$(find "$MENTEES_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
declare -A task_submission_count
declare -A new_submissions

# Loop through each mentee
for mentee_home in "$MENTEES_DIR"/*; do
    [ -d "$mentee_home" ] || continue
    mentee=$(basename "$mentee_home")

    # Check each domain directory
    for domain_dir in "$mentee_home"/*; do
        [ -d "$domain_dir" ] || continue
        domain=$(basename "$domain_dir")

        # Apply domain filter if specified
        if [ -n "$filter_domain" ] && [ "$domain" != "$filter_domain" ]; then
            continue
        fi

        # Check each task directory
        for task_dir in "$domain_dir"/*; do
            [ -d "$task_dir" ] || continue
            task=$(basename "$task_dir")
            submission_time=$(stat -c %Y "$task_dir" 2>/dev/null)

            # Increment the task submission count
            task_submission_count["$task"]=$((task_submission_count["$task"] + 1))

            # Check if the task was submitted since the last run
            if [ "$submission_time" -gt "$(date -d "$last_run" +%s 2>/dev/null)" ]; then
                new_submissions["$task"]+="$mentee\n"
            fi
        done
    done
done

# Display the task submission percentages and new submissions
echo "Task Submission Status (Filtered by domain: ${filter_domain:-All}):"
for task in "${!task_submission_count[@]}"; do
    submission_percentage=$((100 * task_submission_count["$task"] / total_mentees))
    echo "Task: $task, Submissions: ${task_submission_count[$task]}, Percentage: $submission_percentage%"

    if [ -n "${new_submissions[$task]}" ]; then
        echo -e "New submissions since previous check for task $task:\n${new_submissions[$task]}"
    else
        echo "No new submissions since previous check for task $task."
    fi
    echo ""
done

