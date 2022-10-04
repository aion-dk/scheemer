FROM ruby:2.7-alpine

RUN apk add --no-cache --update git build-base

WORKDIR /usr/src/app

RUN gem install bundler

COPY . .

RUN bundle install
