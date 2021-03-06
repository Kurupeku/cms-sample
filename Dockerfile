FROM ruby:2.7.2

RUN apt update -qq && apt install -y --no-install-recommends build-essential libpq-dev \
  postgresql-client

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - \
  && apt install -y nodejs chromium-driver

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt update && apt install yarn

RUN mkdir /app
WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
