#!/bin/bash

mvn_git_changes(){
    goals="$*"
    [ -z "$goals" ] && echo "Usage: mvn_git_changes [one or more goals like install/build/clean]" && return
    
    changed_modules=($(git status | grep --color=never -E "modified:|deleted:|added:" | grep --color=never -oP " \K\S*(?=(\/pom\.xml|\/src\/))" | uniq))
    existing_changed_modules=()
    for module in "${changed_modules[@]}"
    do
        if [[ -d "$module" ]]; then
            existing_changed_modules+=("$module")
        fi
    done
    unset changed_modules

    if [ ${#existing_changed_modules[@]} -eq 0 ]; then
        echo "No changed (modified/deleted/added) modules found."
    else
        echo "Found changed modules: `printf "%s " "${existing_changed_modules[@]}"`"
        echo "Executing command: mvn $goals -amd -pl `printf "%s," "${existing_changed_modules[@]}"`"
        mvn $goals -amd -pl $(printf "%s," "${existing_changed_modules[@]}")
    fi
    unset existing_changed_modules
    unset goals
}