### cross-fork development

the files in this directory exist to aid cross-fork development of the various tip4commit forks from within the same local clone - if you will be working on only one fork then use Gemfile, config/config.yml.sample, and config/database.yml.sample instead

the various forks have drifted apart significantly and require different configuratons - these files will allow these all to be functional within in the same clone without manual config swapping - the only routine maintenance required is in adding new feature branches to the appropriate *_BRANCHES list in config.yml.dev and re-bundling when switching between forks


#### config/cross-fork-dev/config.yml.dev

  config.yml.dev includes a separate configuration for each known tip4commit variant - switched per the current git branch

  config.yml.dev also defines which feature branches should share configurations - you will need to manually add each new branch to the appropriate *_BRANCHES list


#### config/cross-fork-dev/database.yml.dev
  database.yml.dev also includes a separate configuration for each known tip4commit variant - switched per the current git branch (requires the *_BRANCHES list in config.yml.dev)


### setup

  * fork any of the tip4commit forks then clone your fork
  * copy config/cross-fork-dev/config.yml.dev to config/config.yml and
    copy config/cross-fork-dev/database.yml.dev to config/database.yml
```
      cp config/cross-fork-dev/config.yml.dev   config/config.yml
      cp config/cross-fork-dev/database.yml.dev config/database.yml
```
  * customize config/config.yml and config/database.yml
  * repeat the following flow for each fork including the one you forked from
```
    git remote add tip4commit https://github.com/tip4commit/tip4commit.git
    git checkout -b tip4commit-master
    git fetch tip4commit
    git merge tip4commit/master
```
  * add each fork branch created above its corresponding *_BRANCHES list


### maintenance
  * add new local feature branches in their appropriate *_BRANCHES lists
      (e.g. to reduce ambiguity use your local master branch for experimentaion only)
  * re-bundle each time you switch to a new fork configuration
```
      # for tip4commit
      bundle install --without production

      # for peer4commit amd prime4commit
      bundle install --without mysql postgresql
```
