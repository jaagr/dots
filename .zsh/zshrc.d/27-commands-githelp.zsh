#
# Commands to show prezto git aliases with comments.
# Need them until I've learned the pattern.
#

function git-help {
cat << EOF
- $(echo -e "\033[1;34mBranch\033[0m")
- $(echo -e "\033[1;34mCommit\033[0m")
- $(echo -e "\033[1;34mConflict\033[0m")
- $(echo -e "\033[1;34mData\033[0m")
- $(echo -e "\033[1;34mFetch\033[0m")
- $(echo -e "\033[1;34mGrep\033[0m")
- $(echo -e "\033[1;34mIndex\033[0m")
- $(echo -e "\033[1;34mLog\033[0m")
- $(echo -e "\033[1;34mMerge\033[0m")
- $(echo -e "\033[1;34mPush\033[0m")
- $(echo -e "\033[1;34mRebase\033[0m")
- $(echo -e "\033[1;34mRemote\033[0m")
- $(echo -e "\033[1;34mStash\033[0m")
- $(echo -e "\033[1;34mSubmodule\033[0m")
- $(echo -e "\033[1;34mWorking directory\033[0m")
- $(echo -e "\033[1;34mShadows\033[0m")
- $(echo -e "\033[1;34mFunctions\033[0m")
EOF
}

function git-help-branch {
cat << EOF
### Branch

  - $(echo -e "\033[1;34mgb\033[0m")  lists, creates, renames, and deletes branches.
  - $(echo -e "\033[1;34mgbc\033[0m") creates a new branch.
  - $(echo -e "\033[1;34mgbl\033[0m") lists branches and their commits.
  - $(echo -e "\033[1;34mgbL\033[0m") lists local and remote branches and their commits.
  - $(echo -e "\033[1;34mgbs\033[0m") lists branches and their commits with ancestry graphs.
  - $(echo -e "\033[1;34mgbS\033[0m") lists local and remote branches and their commits with ancestry graphs.
  - $(echo -e "\033[1;34mgbx\033[0m") deletes a branch.
  - $(echo -e "\033[1;34mgbX\033[0m") deletes a branch irrespective of its merged status.
  - $(echo -e "\033[1;34mgbm\033[0m") renames a branch.
  - $(echo -e "\033[1;34mgbM\033[0m") renames a branch even if the new branch name already exists.
EOF
}

function git-help-commit {
cat << EOF
### Commit

  - $(echo -e "\033[1;34mgc\033[0m")  records changes to the repository.
  - $(echo -e "\033[1;34mgca\033[0m") stages all modified and deleted files.
  - $(echo -e "\033[1;34mgcm\033[0m") records changes to the repository with the given message.
  - $(echo -e "\033[1;34mgco\033[0m") checks out a branch or paths to work tree.
  - $(echo -e "\033[1;34mgcO\033[0m") checks out hunks from the index or the tree interactively.
  - $(echo -e "\033[1;34mgcf\033[0m") amends the tip of the current branch using the same log message as *HEAD*.
  - $(echo -e "\033[1;34mgcF\033[0m") amends the tip of the current branch.
  - $(echo -e "\033[1;34mgcp\033[0m") applies changes introduced by existing commits.
  - $(echo -e "\033[1;34mgcP\033[0m") applies changes introduced by existing commits without committing.
  - $(echo -e "\033[1;34mgcr\033[0m") reverts existing commits by reverting patches and recording new commits.
  - $(echo -e "\033[1;34mgcR\033[0m") removes the *HEAD* commit.
  - $(echo -e "\033[1;34mgcs\033[0m") displays various types of objects.
  - $(echo -e "\033[1;34mgcl\033[0m") lists lost commits.
EOF
}

function git-help-conflict {
cat << EOF
### Conflict

  - $(echo -e "\033[1;34mgCl\033[0m") lists unmerged files.
  - $(echo -e "\033[1;34mgCa\033[0m") adds unmerged file contents to the index.
  - $(echo -e "\033[1;34mgCe\033[0m") executes merge-tool on all unmerged file.
  - $(echo -e "\033[1;34mgCo\033[0m") checks out our changes for unmerged paths.
  - $(echo -e "\033[1;34mgCO\033[0m") checks out our changes for all unmerged paths.
  - $(echo -e "\033[1;34mgCt\033[0m") checks out their changes for unmerged paths.
  - $(echo -e "\033[1;34mgCT\033[0m") checks out their changes for all unmerged paths.
EOF
}

function git-help-data {
cat << EOF
### Data

  - $(echo -e "\033[1;34mgd\033[0m")  displays information about files in the index and the work tree.
  - $(echo -e "\033[1;34mgdc\033[0m") lists cached files.
  - $(echo -e "\033[1;34mgdx\033[0m") lists deleted files.
  - $(echo -e "\033[1;34mgdm\033[0m") lists modified files.
  - $(echo -e "\033[1;34mgdu\033[0m") lists untracked files.
  - $(echo -e "\033[1;34mgdk\033[0m") lists killed files.
  - $(echo -e "\033[1;34mgdi\033[0m") lists ignored files.
EOF
}

function git-help-fetch {
cat << EOF
### Fetch

  - $(echo -e "\033[1;34mgf\033[0m")  downloads objects and references from another repository.
  - $(echo -e "\033[1;34mgfc\033[0m") clones a repository into a new directory.
  - $(echo -e "\033[1;34mgfm\033[0m") fetches from and merges with another repository or local branch.
  - $(echo -e "\033[1;34mgfr\033[0m") fetches from and rebases on another repository or local branch.
EOF
}

function git-help-grep {
cat << EOF
### Grep

  - $(echo -e "\033[1;34mgg\033[0m")  displays lines matching a pattern.
  - $(echo -e "\033[1;34mggi\033[0m") displays lines matching a pattern ignoring case.
  - $(echo -e "\033[1;34mggl\033[0m") lists files matching a pattern.
  - $(echo -e "\033[1;34mggL\033[0m") lists files that are not matching a pattern.
  - $(echo -e "\033[1;34mggv\033[0m") displays lines not matching a pattern.
  - $(echo -e "\033[1;34mggw\033[0m") displays lines matching a pattern at word boundary.
EOF
}

function git-help-index {
cat << EOF
### Index

  - $(echo -e "\033[1;34mgia\033[0m") adds file contents to the index.
  - $(echo -e "\033[1;34mgiA\033[0m") adds file contents to the index interactively.
  - $(echo -e "\033[1;34mgiu\033[0m") adds file contents to the index (updates only known files).
  - $(echo -e "\033[1;34mgid\033[0m") displays changes between the index and a named commit (diff).
  - $(echo -e "\033[1;34mgiD\033[0m") displays changes between the index and a named commit (word diff).
  - $(echo -e "\033[1;34mgir\033[0m") resets the current HEAD to the specified state.
  - $(echo -e "\033[1;34mgiR\033[0m") resets the current index interactively.
  - $(echo -e "\033[1;34mgix\033[0m") removes files/directories from the index (recursively).
  - $(echo -e "\033[1;34mgiX\033[0m") removes files/directories from the index (recursively and forced).
EOF
}

function git-help-log {
cat << EOF
### Log

  - $(echo -e "\033[1;34mgl\033[0m")  displays the log.
  - $(echo -e "\033[1;34mgls\033[0m") displays the stats log.
  - $(echo -e "\033[1;34mgld\033[0m") displays the diff log.
  - $(echo -e "\033[1;34mglo\033[0m") displays the one line log.
  - $(echo -e "\033[1;34mglg\033[0m") displays the graph log.
  - $(echo -e "\033[1;34mglb\033[0m") displays the brief commit log.
  - $(echo -e "\033[1;34mglc\033[0m") displays the commit count for each contributor in descending order.
EOF
}

function git-help-merge {
cat << EOF
### Merge

  - $(echo -e "\033[1;34mgm\033[0m")  joins two or more development histories together.
  - $(echo -e "\033[1;34mgmC\033[0m") joins two or more development histories together but does not commit.
  - $(echo -e "\033[1;34mgmF\033[0m") joins two or more development histories together but does not commit
     generating a merge commit even if the merge resolved as a fast-forward.
  - $(echo -e "\033[1;34mgma\033[0m") aborts the conflict resolution, and reconstructs the pre-merge state.
  - $(echo -e "\033[1;34mgmt\033[0m") runs the merge conflict resolution tools to resolve conflicts.
EOF
}

function git-help-push {
cat << EOF
### Push

  - $(echo -e "\033[1;34mgp \033[0m") updates remote refs along with associated objects.
  - $(echo -e "\033[1;34mgpf\033[0m") forcefully updates remote refs along with associated objects.
  - $(echo -e "\033[1;34mgpa\033[0m") updates remote branches along with associated objects.
  - $(echo -e "\033[1;34mgpA\033[0m") updates remote branches and tags along with associated objects.
  - $(echo -e "\033[1;34mgpt\033[0m") updates remote tags along with associated objects.
  - $(echo -e "\033[1;34mgpc\033[0m") updates remote refs along with associated objects and adds *origin*
     as an upstream reference for the current branch.
  - $(echo -e "\033[1;34mgpp\033[0m") pulls and pushes from origin to origin.
EOF
}

function git-help-rebase {
cat << EOF
### Rebase

  - $(echo -e "\033[1;34mgr\033[0m")  forward-ports local commits to the updated upstream head.
  - $(echo -e "\033[1;34mgra\033[0m") aborts the rebase.
  - $(echo -e "\033[1;34mgrc\033[0m") continues the rebase after merge conflicts are resolved.
  - $(echo -e "\033[1;34mgri\033[0m") makes a list of commits to be rebased and opens the editor.
  - $(echo -e "\033[1;34mgrs\033[0m") skips the current patch.
EOF
}

function git-help-remote {
cat << EOF
### Remote

  - $(echo -e "\033[1;34mgR\033[0m")  manages tracked repositories.
  - $(echo -e "\033[1;34mgRl\033[0m") lists remote names and their URLs.
  - $(echo -e "\033[1;34mgRa\033[0m") adds a new remote.
  - $(echo -e "\033[1;34mgRx\033[0m") removes a remote.
  - $(echo -e "\033[1;34mgRm\033[0m") renames a remote.
  - $(echo -e "\033[1;34mgRu\033[0m") fetches remotes updates.
  - $(echo -e "\033[1;34mgRp\033[0m") prunes all stale remote tracking branches.
  - $(echo -e "\033[1;34mgRs\033[0m") displays information about a given remote.
  - $(echo -e "\033[1;34mgRb\033[0m") opens a remote on [GitHub][3] in the default browser.
EOF
}

function git-help-stash {
cat << EOF
### Stash

  - $(echo -e "\033[1;34mgs\033[0m")  stashes the changes of the dirty working directory.
  - $(echo -e "\033[1;34mgsa\033[0m") applies the changes recorded in a stash to the working directory.
  - $(echo -e "\033[1;34mgsx\033[0m") drops a stashed state.
  - $(echo -e "\033[1;34mgsX\033[0m") drops all the stashed states.
  - $(echo -e "\033[1;34mgsl\033[0m") lists stashed states.
  - $(echo -e "\033[1;34mgsL\033[0m") lists dropped stashed states.
  - $(echo -e "\033[1;34mgsd\033[0m") displays changes between the stash and its original parent.
  - $(echo -e "\033[1;34mgsp\033[0m") removes and applies a single stashed state from the stash list.
  - $(echo -e "\033[1;34mgsr\033[0m") recovers a given stashed state.
  - $(echo -e "\033[1;34mgss\033[0m") stashes the changes of the dirty working directory, including untracked.
  - $(echo -e "\033[1;34mgsS\033[0m") stashes the changes of the dirty working directory interactively.
  - $(echo -e "\033[1;34mgsw\033[0m") stashes the changes of the dirty working directory retaining the index.
EOF
}

function git-help-submodule {
cat << EOF
### Submodule

  - $(echo -e "\033[1;34mgS\033[0m")  initializes, updates, or inspects submodules.
  - $(echo -e "\033[1;34mgSa\033[0m") adds given a repository as a submodule.
  - $(echo -e "\033[1;34mgSf\033[0m") evaluates a shell command in each of checked out submodules.
  - $(echo -e "\033[1;34mgSi\033[0m") initializes submodules.
  - $(echo -e "\033[1;34mgSI\033[0m") initializes and clones submodules recursively.
  - $(echo -e "\033[1;34mgSl\033[0m") lists the commits of all submodules.
  - $(echo -e "\033[1;34mgSm\033[0m") moves a submodule.
  - $(echo -e "\033[1;34mgSs\033[0m") synchronizes submodules' remote URL to the value specified in .gitmodules.
  - $(echo -e "\033[1;34mgSu\033[0m") fetches and merges the latest changes for all submodule.
  - $(echo -e "\033[1;34mgSx\033[0m") removes a submodule.
EOF
}

function git-help-workingdirectory {
cat << EOF
### Working directory

  - $(echo -e "\033[1;34mgws\033[0m") displays working-tree status in the short format.
  - $(echo -e "\033[1;34mgwS\033[0m") displays working-tree status.
  - $(echo -e "\033[1;34mgwd\033[0m") displays changes between the working tree and the index (diff).
  - $(echo -e "\033[1;34mgwD\033[0m") displays changes between the working tree and the index (word diff).
  - $(echo -e "\033[1;34mgwr\033[0m") resets the current HEAD to the specified state, does not touch the index nor the working tree.
  - $(echo -e "\033[1;34mgwR\033[0m") resets the current HEAD, index and working tree to the specified state.
  - $(echo -e "\033[1;34mgwc\033[0m") removes untracked files from the working tree (dry-run).
  - $(echo -e "\033[1;34mgwC\033[0m") removes untracked files from the working tree.
  - $(echo -e "\033[1;34mgwx\033[0m") removes files from the working tree and from the index recursively.
  - $(echo -e "\033[1;34mgwX\033[0m") removes files from the working tree and from the index recursively and forcefully.
EOF
}

function git-help-functions {
cat << EOF
### Functions

  - $(echo -e "\033[1;34mgit-branch-current\033[0m") displays the current branch.
  - $(echo -e "\033[1;34mgit-commit-lost\033[0m") lists lost commits.
  - $(echo -e "\033[1;34mgit-dir\033[0m") displays the path to the Git directory.
  - $(echo -e "\033[1;34mgit-hub-browse\033[0m") opens the [GitHub][3] repository in the default browser.
  - $(echo -e "\033[1;34mgit-hub-shorten-url\033[0m") shortens GitHub URLs.
  - $(echo -e "\033[1;34mgit-info\033[0m") exposes repository information via the `$git_info` associative array.
  - $(echo -e "\033[1;34mgit-root\033[0m") displays the path to the working tree root.
  - $(echo -e "\033[1;34mgit-stash-clear-interactive\033[0m") asks for confirmation before clearing the stash.
  - $(echo -e "\033[1;34mgit-stash-dropped\033[0m") lists dropped stashed states.
  - $(echo -e "\033[1;34mgit-stash-recover\033[0m") recovers given dropped stashed states.
  - $(echo -e "\033[1;34mgit-submodule-move\033[0m") moves a submodule.
  - $(echo -e "\033[1;34mgit-submodule-remove\033[0m") removes a submodule.
EOF
}
