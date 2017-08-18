# Jekyll

## Installation

The quickest way to get started is to spin up this blog in a Docker container running Jekyll. You only need the Docker Engine installed for your operating system. It's available [for Mac](https://www.docker.com/products/docker#/mac), [for Windows](https://www.docker.com/products/docker#windows), and [for Linux](https://www.docker.com/products/docker#linux). For detailed installation instructions, see the Docker site.

See [`INSTALLATION.md`](INSTALLATION.md) for manual installation instructions without Docker.

## Running Jekyll locally

Before you start writing your post, open a terminal, `cd` into the blog directory and execute

`bin/start`

This command pulls the latest Docker container with Jekyll and starts a local server that's available at `[http://localhost:4000](http://localhost:4000)`.

To stop the local server, execute

`bin/stop`

## Branching

### `master`

All changes on the master branch will be deployed automatically to upday.github.io - so please be careful
To make this possible the repo needs to be **public so please be careful what you post here**

### `develop`
Let's use this branch for drafts and pull requests

### `sample`

I've used the [_So Simple_ theme](http://mmistakes.github.io/so-simple-theme/) inside this branch are a lot of samples with different articles and formatting

See a [live version of So Simple](http://mmistakes.github.io/so-simple-theme/) hosted on GitHub.

---

## Adding a blog post

* if this is your first post, add your data to `authors.yml` and add your picture to `images` folder
* Add your post in Markdown format to the `_posts/blog` directory, following this naming scheme: `YEAR-MONTH-DAY-title-of-your-post.md`
* Check out the sample posts in `samples branch` for some tipps on formatting

### Pull Request flow
* check you post with a spell checker [like](https://www.grammarly.com/)
* get a positive review from **one** updude
* push it!
