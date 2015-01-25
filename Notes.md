
Git Notes
=========

Branches
--------

Create new:

		git checkout -b newbranch
		git push -u origin newbranch

Get & track branch:

		git fetch origin
		git checkout --track origin/newbranch

Delete remote branch:

		git push origin :oldbranch

Prune:

		git remote prune origin

Tag:

		git tag -a -m "Version 1.0063 Manatee" v1.0063


Subtrees
--------

Add Tree:

		git remote add ZLibrary ssh://git@violent.blue/~/ZLibrary.git
		git subtree add --prefix=.../External/ZLibrary ZLibrary master

Pull:

		git subtree pull --prefix=.../External/Library --squash ZLibrary master

Push:

		git subtree push --prefix=.../External/ZLibrary ZLibrary master

