# mvngitchanges

A shell script for Maven multi-module projects tracked with Git, which runs Maven commands selectively on changed modules.

Note that it will only catch up changes in sub-folders of the project which are made either to a pom.xml or to files which are in a folder "src" or in a sub-folder therein.

It has to be run from the project's root directory.

## Example usage

```
mvn_git_changes clean install
```

## Installation

Either copy and paste the command to your `.bashrc` or save the file which contains it somewhere on your local machine and source it in your `.bashrc`.