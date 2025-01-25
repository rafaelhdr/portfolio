FROM ruby:3.4.1-slim-bookworm

WORKDIR /app
RUN apt-get update && apt-get install -y build-essential && \
    gem update bundler
COPY Gemfile Gemfile.lock ./
RUN bundler install
ENTRYPOINT ["jekyll", "serve", "--host", "0.0.0.0"]
