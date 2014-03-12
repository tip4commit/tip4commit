Tip4commit
==========

[![tip for next commit](http://tip4commit.com/projects/307.svg)](http://tip4commit.com/projects/307) [![Build Status](https://travis-ci.org/tip4commit/tip4commit.png?branch=master)](https://travis-ci.org/tip4commit/tip4commit)

Donate bitcoins to open source projects or make commits and get tips for it.

Official site: http://tip4commit.com/

Forum thread: https://bitcointalk.org/index.php?topic=315802

FAQ: https://github.com/tip4commit/tip4commit/wiki/FAQ

ToDo: https://github.com/tip4commit/tip4commit/issues

Tip modifiers
-------------

Project owners can change the amount given to a commit during the merge. To do that they must include one of these hashtags in the merge commit message:
* `#huge`: the author will get 5 times the normal tip amount
* `#big`: 2 times the normal amount
* `#small`: half the normal amount
* `#tiny`: 1/5th the normal amount
* `#free`: no tip at all

Note that each merged commit will receive its own modified tip.

Also note that the modifier only works when all these conditions are met:

1. The merge has exactly 2 parents and there are new commits in only one of the 2 branches. More complex merges are harder to interpret. This is what happens when you merge a pull request on GitHub.
2. The merge author is a collaborator of the project. This was implemented to prevent abusive hidden modifiers in commit messages.

We suggest project owners add a public statement on how they will modify tips.

License
=======

[MIT License](https://github.com/tip4commit/tip4commit/blob/master/LICENSE)
