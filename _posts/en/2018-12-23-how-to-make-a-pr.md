---
layout: post
title:  "How to make a PR"
date:   2018-12-23 08:00:00 -0300
categories: git
permalink: blog/how-to-make-a-pr
lang: en
excerpt: "Shows how to create a pull request on GitLab, covering branch creation, committing changes, and submitting the merge request."
---
# How to make a PR

This tutorial shows how to make a simple PR (Pull Request).

## Get the code

I will use my [pr tutorial repository](https://gitlab.com/rafaelhdr/pr-example) as an example. You can clone it, but I'd recommend you to use your own.

`git clone git@gitlab.com:rafaelhdr/pr-example.git`

### Use recent code

*(you can skip this step if cloned the repository)*

Most of the time you won't be cloning a repository, but using an existent one. In this case, go to the master branch and get the most recent code

`git checkout master` go to master

`git pull origin master` to update it with the most recent code

## Branch

Let's create a new branch to make the changes. We will create a new branch, and then make a Pull Request to merge the changes to the master branch (normally the master, but it can be others).

`git branch make-chapter-2` to create a new branch called make-chapter-2

`git checkout make-chapter-2` to go to the new create branch

> Tip: The 2 commands above could be changed to `git branch -b make-chapter-2`

Change something in the code (e.g. add a lorem ipsum paragraph at content.txt).

`git add content.txt` to add the changed code to the commit

`git commit -m "make chapter 2"` to create the commit with the changes

Now, your local code is updated. We just need to push it to the server (in my case, GitLab).

`git push origin make-chapter-2`

## Ready

And the code is ready. You can check in the GitLab (and merge from there).
