blog
====

Personal blog

https://josdejong.com

Powered by static site generator: https://gohugo.io/

Theme based on https://github.com/mismith0227/hugo_theme_pickles


## Start server locally

```
hugo server -D
```

Here `-D` is to also render drafts.

Create a new article like:

```
hugo new posts/2020-06-20-my-new-post.md
```

When the article is finished and ready to publish, remove the line `draft = true`.


## How to publish

- Run `hugo`
- Commit all files in `/docs` to git
- Push git
