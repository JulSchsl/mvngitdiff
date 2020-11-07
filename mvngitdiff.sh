#!/bin/bash

mvngitdiff(){

    branch_or_commit="$1"
    [ -z "$branch_or_commit" ] && echo "Usage: mvngitdiff <branch or commit> <one or more goals like install/build/clean>" && return 125
    shift

    goals="$*"
    [ -z "$goals" ] && echo "Usage: mvngitdiff [one or more goals like install/build/clean]" && return 126
    
    changed_modules=($(git diff --name-only $branch_or_commit | grep --color=never -oP "\K\S*(?=(\/pom\.xml|\/src\/))" | uniq))
    unset branch_or_commit
    
    existing_changed_modules=()
    for module in "${changed_modules[@]}"
    do
        # use only modules for which a directory of the same name exists and which are listed as modules in the pom.xml
        if [[ -d "$module" ]] && grep -q "<module>$module</module>" pom.xml; then
            existing_changed_modules+=("$module")
        fi
    done
    unset changed_modules

    ret_val=0
    if [ ${#existing_changed_modules[@]} -eq 0 ]; then
        echo "No changed (modified/deleted/added) files found in maven modules."
    else
        echo "Found changed files in the following modules: `printf "%s " "${existing_changed_modules[@]}"`"
        echo "Executing command: mvn $goals -amd -pl `printf "%s," "${existing_changed_modules[@]}"`"
        mvn $goals -amd -pl $(printf "%s," "${existing_changed_modules[@]}")
        ret_val=$?
    fi
    unset existing_changed_modules
    unset goals

    return $ret_val
}