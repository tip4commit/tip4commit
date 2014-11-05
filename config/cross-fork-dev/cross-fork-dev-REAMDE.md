### cross-fork development

the files in this directory exist to aid cross-fork development of the various tip4commit forks from within the same local clone - if you will be working on only one fork then use Gemfile, config/config.yml.sample, and config/database.yml.sample instead

the various forks have drifted apart significantly and require different configuratons - these files will allow these all to be functional within in the same clone without manual config swapping - the only routine maintenance required is in adding new feature branches to the appropriate *_BRANCHES list in config.yml.dev and re-bundling when Gemfiles change


#### config/cross-fork-dev/Gemfile.dev

Gemfile.dev is a concatenation of the Gemfiles from the tip4commit and peer4commit forks with some version conflicts resolved by favoring the more specific requirement

this o/c is brittle and must be maintained and is not guaranteed 100% bug-free but has so far worked out well for development


#### config/cross-fork-dev/config.yml.dev

  config.yml.dev includes a separate configuration for each known tip4commit variant - switched per the current git branch

  config.yml.dev also defines which feature branches should share configurations - you will need to manually add each new branch to the appropriate *_BRANCHES list


#### config/cross-fork-dev/database.yml.dev

  database.yml.dev also includes a separate configuration for each known tip4commit variant - switched per the current git branch (requires the *_BRANCHES list in config.yml.dev)


### setup

  * fork any of the tip4commit forks then clone your fork
  * backup Gemfile then copy Gemfile.dev to the rails root dir
```
      cd RAILS_ROOT
      mv Gemfile                           ./Gemfile.bak
      cp config/cross-fork-dev/Gemfile.dev ./Gemfile
```
  * bundle then restore Gemfile
```
      bundle install --without production mysql postgresql
      mv Gemfile.bak ./Gemfile
```
  * copy config.yml.dev and database.yml.dev to config
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
  * re-bundle as above when any of the forked Gemfiles change (updating and committing config/cross-fork-dev/Gemfile.dev if necessary)
```
      cd RAILS_ROOT
      mv Gemfile                           ./Gemfile.bak
      cp config/cross-fork-dev/Gemfile.dev ./Gemfile
      bundle install --without production mysql postgresql
      mv Gemfile.bak                       ./Gemfile
```
