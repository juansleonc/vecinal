SHELL := /bin/bash

.PHONY: dev-legacy dev-api check-ruby

check-ruby:
	@echo "Ruby local:" && ruby -v || true
	@echo "Bundler local:" && bundle -v || true

# Rails legacy
LEGACY_DIR=apps/legacy-rails

dev-legacy:
	cd $(LEGACY_DIR) && bundle install && bin/rails s

# Rails API-next (Ruby)
API_DIR=apps/api-next-ruby

dev-api:
	cd $(API_DIR) && bundle _2.5.6_ install && bundle exec rails s -p 4000
