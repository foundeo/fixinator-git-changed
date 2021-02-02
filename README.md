# fixinator-git-changed

CommandBox task to run the [fixinator](https://fixinator.app/) command on git changed files only. 

    box task run taskFile=fixinator-git-changed.cfc :severity=high :resultFile=./test-reports/fixinator-results.xml :resultFormat=junit

You can specify all of the `fixinator` command arguments using `:argname=value`, for example to set the confidence use `:confidence=low`

You can also specify `lastCommit=true` or `lastCommit=false` to compare against the last commit. 

This task is experimental and once it is tested the functionality will make it into the fixinator command.

## Running from CI

You can clone this repo in your CI script, and then point the `:path` argument to the root of your repository. Something like this should work:

    git clone https://github.com/foundeo/fixinator-git-changed.git /tmp/fixinator-git-changed/
    box task run taskFile=/tmp/fixinator-git-changed/fixinator-git-changed.cfc :path=$GITHUB_WORKSPACE
