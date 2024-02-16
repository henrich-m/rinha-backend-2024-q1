FROM ruby:3.3

USER root

WORKDIR /var/app

RUN gem update --system

COPY Gemfile .

COPY Gemfile.lock .

COPY vendor/cache .

RUN bundle install

RUN bundle package --all

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
