component {
	
	function run(path=".", lastCommit=true) {
		var path = fileSystemUtil.resolvePath( arguments.path );;
		
		var changes = getChanges(path, lastCommit);
		var change = "";
		var pathArray = [];
		for (change in changes) {
			if (change.type == "DELETE") {
				print.redLine("D: #change.previousPath#");
			} else if (change.type == "MODIFY") {
				print.greenLine("M: #change.path#");
				arrayAppend(pathArray, change.path);
			} else {
				print.yellowLine("#change.type#: #change.path# #change.previousPath#");
				arrayAppend(pathArray, change.path);
			}
			
		}
		if (arrayLen(pathArray)) {
			arguments.path = arrayToList(pathArray);
		} else {
			print.line("No Changed Files Detected");
			return;
		}

		try {
			command( "fixinator" )
    		.params( argumentCollection=arguments )
    		.run();	
		} catch (any err) {
			if (err.message contains "exit code (1)") {
				setExitCode( 1 );
			} else {
				rethrow;
			}
			
		}
	}

	function getChanges(path, lastCommit=true) {
		var gitDir = path & ".git/";
		var gitDirFileObject = createObject("java", "java.io.File").init(gitDir);
		var gitRepo = "";
		var reader = "";
		var results = [];
		var result = "";
		var disIO = createObject("java", "org.eclipse.jgit.util.io.DisabledOutputStream").INSTANCE;
		if (!gitDirFileObject.exists()) {
			throw(message="The path: #path# is not a git repository root path");
		}
		gitRepo = createObject("java", "org.eclipse.jgit.storage.file.FileRepositoryBuilder").create(gitDirFileObject);

		reader = gitRepo.newObjectReader();

		if (lastCommit) {
			oldTreeIter = createObject("java", "org.eclipse.jgit.treewalk.CanonicalTreeParser");
			oldTree = gitRepo.resolve( "HEAD~1^{tree}" );
			oldTreeIter.reset( reader, oldTree );
			newTreeIter = createObject("java", "org.eclipse.jgit.treewalk.CanonicalTreeParser");
			
			newTree = gitRepo.resolve( "HEAD^{tree}" );
			newTreeIter.reset( reader, newTree );
		} else {
			oldTreeIter = createObject("java", "org.eclipse.jgit.treewalk.CanonicalTreeParser");
			oldTree = gitRepo.resolve( "HEAD^{tree}" );
			oldTreeIter.reset( reader, oldTree );
			
			newTreeIter = createObject("java", "org.eclipse.jgit.treewalk.FileTreeIterator").init(gitRepo);
		}
		

		diffFormatter = createObject("java", "org.eclipse.jgit.diff.DiffFormatter").init( disIO );
		diffFormatter.setRepository( gitRepo );
		entries = diffFormatter.scan( oldTreeIter, newTreeIter );

		for( entry in entries.toArray() ) {
			result = {"type": entry.getChangeType().toString(), "path": "", "previousPath":""}
			if (!isNull(entry.getNewPath())) {
				result.path = entry.getNewPath().toString();
			}
			if (!isNull(entry.getOldPath())) {
				result.previousPath = entry.getOldPath().toString();
			}
			arrayAppend(results, result);
		}
		return results;
	}
}
