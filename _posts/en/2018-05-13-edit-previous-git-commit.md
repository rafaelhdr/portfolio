---
layout: post
title:  "Edit git previous commit"
date:   2018-05-13 18:00:00 -0300
categories: git rebase
permalink: blog/edit-git-previous-commit
lang: en
excerpt: "Teaches how to edit a previous git commit using interactive rebase, with a full example of fixing a mistaken password in history."
---
# Edit git previous commit

If you made a mistake in a previous commit and want to edit it. You can use git rebase to fix it.

*Not recommended if you already pushed*

**tl;dr** `git rebase -i COMMITHASH`

I will explain this command with a full example:

## Creating the scenario

With the commands below, you will have three commits.

```shell
git init
echo "first commit" > file0.txt
git add .
git commit -m "first commit"
echo "some code
password forgotten
more code" > file1.txt
git add .
git commit -m "commit 1"
echo "more code" > file2.txt
git add .
git commit -m "commit 2"
```

We have three files (file0.txt, file1.txt and file2.txt), but one of them has a password and it was added in the "commit 1".

## git rebase

We can use rebase using the commit hash or using the previous two commits.

```shell
git rebase -i HEAD^2
# OR
git rebase -i COMMIT_1_HASH
```

You will see something like this (with different hash):

```shell
pick 3aa4948 commit 1
pick 9e5aadf commit 2

# More code, even explaining the options
```

We want to edit the commit 1, so let's change **pick** to **edit** in commit 1 to:

```shell
edit 3aa4948 commit 1
pick 9e5aadf commit 2
```

> We could have used just `e` instead of `edit`.

And now we are in commit 1. Let's just remove the line `password forgotten` and commit again.

```shell
echo "some code
more code" > file1.txt
git add .
git commit --amend # We are editing an existent commit
```

And we are done. We just need to let git continue the rebase with the command `git rebase --continue`.

You will see this message: `Successfully rebased and updated refs/heads/master.`

And now you are ready to push.

## Be careful

If you already pushed, you probably will have problems. It is better to edit it (and change your password).

## Note about first commit

First commit ("first commit") is not important. Why did I add it? Because git rebase would be a little different.

If you try `git rebase -i HEAD~3` you raise the following error:

```shell
fatal: Needed a single revision
invalid upstream 'HEAD~3'
```

You should use `git rebase -i --root`.

## Full reference

[Git Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)

