# Jekyll

## Installation
check [here] (https://jekyllrb.com/docs/installation/)

the requirements are:
* Ruby (including development headers, v1.9.3 or above for Jekyll 2 and v2 or above for Jekyll 3) 
* RubyGems
* Linux, Unix, or Mac OS X
* NodeJS, or another JavaScript runtime (Jekyll 2 and earlier, for CoffeeScript support).
* Python 2.7 (for Jekyll 2 and earlier)

## branching

### master
All changes on the master branch will be deployed automatically to upday.github.io - so please be carefull
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

