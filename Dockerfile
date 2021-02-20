FROM ruby:2.6.6

RUN apt-get update && apt-get install -y default-libmysqlclient-dev libsodium-dev

WORKDIR /tip4commit
ENTRYPOINT ["/tip4commit/script/dev_docker/entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]

RUN gem update --system && gem install bundler --version 2.1.4

ADD Gemfile Gemfile.lock ./
RUN bundle install --jobs 5

COPY . ./
