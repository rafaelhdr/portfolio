---
layout: post
title:  "vim for cleaning html tags"
date:   2018-05-21 18:00:00 -0300
categories: vim regex html tag
permalink: blog/vim-regex-for-cleaning-html-tags
lang: en
---
# VIM for cleaning HTML tags

You have a big file, but want to extract some specific value. You can use vim substitute with regex.

> Ok. Not only vim. It should work with grep also. But I am using vim, just for this post.

> Yes, you could use a crawler for that. In my case, I just wanted something fast for a single file.

**TL;DR**

```text
:%g!/useful-class/d
:%s/<a.*href="\([^"]*\).*\n/\1\r/g
```

## Testing file

For testing, you can open the file below in vim:

```html
SOME BIG HTML
<a class="useful-class" href="http://example/1">Example 1</a>
NOT USEFUL LINE
<a class="useful-class" href="http://example/2">Example 2</a>
END OF BIG HTML
```

In our example, we want to remove not useful lines, and just keep the URL.

## Running commands

Clean not useful lines:

`:%g!/useful-class/d`

* **%g!** Make some action in all lines that does not contains a pattern
* **useful-class** The pattern. You just want to keep the lines with that class
* **d** We define that the action is delete

Remove unused content:

`:%s/<a.*href="\([^"]*\).*\n/\1\r/g`

* **%s** Substitute all lines containing a specific pattern
* Pattern (this is long):
  * **<a** Starting with `<a`
  * **.\*** With any character until...
  * **href="** ...until it finds `href="`
  * **\\([^"]\*\\)** and the first part ("atom") is anything that is not quotes (`[^"]*` not quotes). The "atom" is the content inside the parentheses (`(...)`)
  * **.\*** and any character until...
  * **\n** ...until it finds the new line `\n`
* **\1\r** substitute by the first "atom" and a new line
* **g** run the command

## Done

The result is this:

```text
http://example/1
http://example/2
```

Not simple, but the second time is easier to remember.

I used today for a single page long file (I copied the DOM `<ul><li><a>...</a></li></ul>`) and ran the commands (and also learned) the regex commands.

## References

* [Delete all lines containing a pattern](http://vim.wikia.com/wiki/Delete_all_lines_containing_a_pattern)
* [Replace while keeping certain “words” in vi/vim](https://stackoverflow.com/questions/11624166/replace-while-keeping-certain-words-in-vi-vim)
* [How to replace a character by a newline in Vim?](https://stackoverflow.com/questions/71323/how-to-replace-a-character-by-a-newline-in-vim)
