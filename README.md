# fixinator-git-changed

CommandBox task to run the [fixinator](https://fixinator.app/) command on git changed files only. 

    task run fixinator-git-changed.cfc :severity=high :resultFile=./test-reports/fixinator-results.xml :resultFormat=junit

You can specify all of the `fixinator` command arguments using `:argname=value`, for example to set the confidence use `:confidence=low`

You can also specify `lastCommit=true` or `lastCommit=false` to compare against the last commit. 

This task is experimental and once it is tested the functionality will make it into the fixinator command.
