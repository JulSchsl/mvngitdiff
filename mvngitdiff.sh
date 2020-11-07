#!/bin/bash

mvngitdiff(){

    branch="$1"
    [ -z "$branch" ] && echo "Usage: mvngitdiff <branch or commit> <one or more goals like install/build/clean>" && return
    shift

    goals="$*"
    [ -z "$goals" ] && echo "Usage: mvngitdiff [one or more goals like install/build/clean]" && return
    
    changed_modules=($(git diff --name-only $branch | grep --color=never -oP "\K\S*(?=(\/pom\.xml|\/src\/))" | uniq))
    existing_changed_modules=()
    for module in "${changed_modules[@]}"
    do
        if [[ -d "$module" ]]; then
            existing_changed_modules+=("$module")
        fi
    done
    unset changed_modules

    if [ ${#existing_changed_modules[@]} -eq 0 ]; then
        echo "No changed (modified/deleted/added) files found in maven modules."
    else
        echo "Found changed files in modules: `printf "%s " "${existing_changed_modules[@]}"`"
        echo "Executing command: mvn $goals -amd -pl `printf "%s," "${existing_changed_modules[@]}"`"
        mvn $goals -amd -pl $(printf "%s," "${existing_changed_modules[@]}")
    fi
    unset existing_changed_modules
    unset goals
}