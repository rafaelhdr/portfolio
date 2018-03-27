
development:
	docker run --rm --volume=${PWD}:/srv/jekyll -p 35729:35729 -p 4000:4000 -it jekyll/builder:3.6.2 jekyll serve

deploy: requirements
	(bundle install && \
	rake deploy)

requirements:
	gem install jekyll bundler s3_website
