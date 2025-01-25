# rafaelhdr

This is my personal website. It is an open-source portfolio example.

I published a [post](http://rafaelhdr.com.br/rafaelhdr-new-website-with-jekyll) explaining more about it.

## Running local

```sh
docker build -t rafaelhdr-site .
docker run -it --rm -v $(pwd):/app -p 4000:4000 rafaelhdr-site
```

## Deploying

There is a pipeline that update the server automatically after pushing new commits at `.gitlab-ci.yml`.
