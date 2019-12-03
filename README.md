# Git Synchronization Utility

Super simple git synchronization utility. Made to transfer repos between private enviroments. It is similar to git archive but works with a set of repositories to transfer (archive).

## Usage

### Export

To export a set of repositories, use export command and provide a profile.

    ./git-sync.sh export git-test

This will clone or fetch latest version for each repository in profile as a bare repository. Then, all repositories will be archived into a single gzipped tar-file. (i.E. git-test.201912031935.tgz)

After executing, there is a gzipped tar-file and a directory *«profile».export*

### Import

To import repositories from a gzipped tar-file use import command.

    ./git-sync.sh import git-test

This will extract all repositores into a directory *«profile».import*. To work with these repositores, you must clone them locally into another place. This ensures the future updateability after receiving transfers.
