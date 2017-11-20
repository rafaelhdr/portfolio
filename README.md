# rafaelhdr

This is my personal website. It is an open-source portfolio example.

I published a [post](http://rafaelhdr.com.br/rafaelhdr-new-website-with-jekyll) explaining more about it.

## Running local

```sh
docker run --rm --volume=$PWD:/srv/jekyll -p 35729:35729 -p 4000:4000 -it jekyll/builder:3.6.2 jekyll serve
```

## Deploying

There is a pipeline that update the server automatically after pushing new commits at `.gitlab-ci.yml`.

```sh
# export AWS_ACCESS_KEY_ID=MY_ACCESS_KEY
# export AWS_SECRET_ACCESS_KEY=MY_ACCESS_SECRET_KEY
# export AWS_S3_BUCKET=MY_BUCKET_NAME
gem install s3_website
rake deploy
```
