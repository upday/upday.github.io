# Jekyll

## Installation
check [here] (https://jekyllrb.com/docs/installation/)

## Mac

### Ruby
to install *Ruby* you should install RVM, this will install rvm with the latest stable version of Ruby
```bash
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

If you have problems maybe you need to install the xcode command Line tools

```bash
xcode-select --install
 ```

### Python
 just use the installer from here https://www.python.org/downloads/mac-osx/
use version 2.7.x

### NodeJS
If you don't have it already install Brew
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
afterwards use brew to install NodeJS
```bash
brew install node
```

### Jekyll
jekyll is just a gem, a package in Ruby, to resolve all necessary dependencies you should use bundler
```bash
gem install bundler
```
afterwards install jekyll via bundler, open the blog root directory and
```
bundle install
```

*You should be good to go!!!*

## Ubuntu

### Ruby
```bash
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

### Python
Well - should be there...

### NodeJS
```bash
sudo apt-get update
sudo apt-get install nodejs
sudo apt-get install npm
```

### Jekyll
jekyll is just a gem, a package in Ruby, to resolve all necessary dependencies you should use bundler
```bash
gem install bundler
```
afterwards install jekyll via bundler, open the blog root directory and
```
bundle install
```

*You should be good to go!!!*

## Windows
Well, there are some tutorials but it isn't officially supported and according to the last test it is a massive pain - so easiest way is virtualbox in the moment...

## branching

### master
All changes on the master branch will be deployed automatically to upday.github.io - so please be careful
To make this possible the repo needs to be **public so please be careful what you post here**  
### develop
Let's use this branch for drafts and pull requests
### sample
I've used the [so simple theme] (http://mmistakes.github.io/so-simple-theme/) inside this branch are a lot of samples with different articles and formatting
See a [live version of So Simple](http://mmistakes.github.io/so-simple-theme/) hosted on GitHub.

---

## Run locally
```bash
bundle exec jekyll serve
```

## Add a blog post
* if this is your first post add your data to `authors.yml` and add your picture to `images` folder
* add your post in the format
```
YEAR-MONTH-DAY-title.MARKUP
```
* check out the sample posts in `samples branch` to get necessary formatting
