### cross-fork development primer

the files in this directory exist to aid cross-fork development of the various tip4commit forks from within the same local clone - if you will be working on only one fork then use Gemfile, config/config.yml.sample, and config/database.yml.sample instead

the various forks have drifted apart significantly and require different configuratons - these files will allow these all to be functional within in the same clone without manual config swapping - the only routine maintainence required is in the *_BRANCHES lists in config.yml.dev


#### config/cross-fork-dev/Gemfile.dev

  Gemfile.dev is a concatenation of the Gemfiles from the tip4commit and peer4commit forks
      with some version conflicts resolved by favoring the more specific requirement

  this o/c is brittle and must be maintained and is not guaranteed 100% bug-free
      but has so far worked out well for development


#### config/cross-fork-dev/config.yml.dev

  config.yml.dev includes a separate configuration for each known tip4commit variant
    switched per the current git branch

  config.yml.dev also defines which feature branches should share configurations
  you will need to manually add each new branch to the appropriate *_BRANCHES list


#### config/cross-fork-dev/database.yml.dev
  database.yml.dev also includes a separate configuration for each known tip4commit variant
    switched per the current git branch (requires the *_BRANCHES list in config.yml.dev)


### setup

  * fork any of the tip4commit forks then clone your fork
  * copy config/cross-fork-dev/Gemfile.dev to the rails root dir
```
      cd RAILS_ROOT
      cp config/cross-fork-dev/Gemfile.dev ./Gemfile
```
  * set the assume-unchanged flag so that this dev Gemfile is not committed
```
      git update-index --assume-unchanged    Gemfile
      git update-index --assume-unchanged    Gemfile.lock
```
  * on the occasion that Gemfile must change (merges , etc) you will need to toggle temporarily
```
      git update-index --no-assume-unchanged Gemfile
      git update-index --no-assume-unchanged Gemfile.lock
```
  * bundle
```
      bundle install --without production mysql postgresql
```
  * copy config/cross-fork-dev/config.yml.dev to config/config.yml and
    copy config/cross-fork-dev/database.yml.dev to config/database.yml
```
      cp config/cross-fork-dev/config.yml.dev   config/config.yml
      cp config/cross-fork-dev/database.yml.dev config/database.yml
```
  * customize config/config.yml and config/database.yml
  * list local feature branches in their appropriate *_BRANCHES lists in config/config.yml
      (your local master branch would most likely be never used in this scenario)

  * repeat the following flow for each fork including the one you forked from
```
    git remote add tip4commit https://github.com/tip4commit/tip4commit.git
    git checkout -b tip4commit-master
    git fetch tip4commit
    git merge tip4commit/master
```
