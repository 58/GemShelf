FROM ruby:3.4

WORKDIR /rails

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  git \
  libsqlite3-dev \
  sqlite3 \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
