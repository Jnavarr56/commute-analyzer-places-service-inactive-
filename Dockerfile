# Ruby on Rails Environment
FROM ruby:2.7.1

# Set up Linux
RUN apt-get update -qq && apt-get install -y

# RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./


# Dependency stuff
RUN gem install bundler --no-document
RUN bundle install --no-binstubs --jobs $(nproc) --retry 3

COPY . .

CMD ["bundle", "exec", "rails", "server", "-p", "80", "-b", "0.0.0.0"]

