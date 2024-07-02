#!/bin/bash

# Base directories
CORE_HOME="/home/cpvbox/Sysad2/Core"
MENTORS_DIR="$CORE_HOME/mentors"
MENTEES_DIR="$CORE_HOME/mentees"

# Declare associative arrays for mentors and mentees
declare -A mentor_capacity
declare -A mentor_domain
declare -A mentee_domains

# Function to read mentor details
read_mentors() {
    local mentors_file="$CORE_HOME/mentorDetails.txt"
    if [ ! -f "$mentors_file" ]; then
        echo "Error: Mentors file not found at $mentors_file"
        exit 1
    fi

    while read -r name domain capacity; do
        echo "Reading mentor: $name, Domain: $domain, Capacity: $capacity"
        mentor_capacity["$name"]="$capacity"
        mentor_domain["$name"]="$domain"
    done < "$mentors_file"
}

# Function to read mentee details
read_mentees() {
    local mentees_file="$CORE_HOME/mentees_domain.txt"
    if [ ! -f "$mentees_file" ]; then
        echo "Error: Mentees file not found at $mentees_file"
        exit 1
    fi

    while read -r roll_number domains; do
        echo "Reading mentee: $roll_number, Domains: $domains"
        mentee_domains["$roll_number"]="$domains"
    done < "$mentees_file"
}

# Function to allocate a mentee to a mentor
allocate_mentee_to_mentor() {
    local mentee_roll_number=$1
    local preferred_domain=$2
    local mentor=$3

    local MENTOR_HOME="$MENTORS_DIR/$preferred_domain/$mentor"
    mkdir -p "$MENTOR_HOME"

    echo "Allocating $mentee_roll_number to $mentor (before: ${mentor_capacity[$mentor]})"
    echo "$mentee_roll_number" >> "$MENTOR_HOME/allocatedMentees.txt"
    mentor_capacity["$mentor"]=$((${mentor_capacity["$mentor"]} - 1))
    echo "Capacity of $mentor (after: ${mentor_capacity[$mentor]})"
}

# Function to allocate mentees to mentors (FCFS)
allocate_mentees() {
    read_mentors
    read_mentees

    for mentee_roll_number in "${!mentee_domains[@]}"; do
        local mentee_preferred_domains=(${mentee_domains[$mentee_roll_number]})
        for preferred_domain in "${mentee_preferred_domains[@]}"; do
            for mentor in "${!mentor_capacity[@]}"; do
                if [ "${mentor_capacity[$mentor]}" -le 0 ]; then
                    continue
                fi

                if [[ "$preferred_domain" == "${mentor_domain[$mentor]}" ]]; then
                    allocate_mentee_to_mentor "$mentee_roll_number" "$preferred_domain" "$mentor"
                    break 2  # Break out of both loops once a match is found
                fi
            done
        done
    done
}

# Main execution
allocate_mentees

