FROM ruby:2.4

RUN apt-get update \
  && apt-get install -y --no-install-recommends postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install --jobs 20 --retry 5 --without development test

ENV RAILS_ENV production
ENV RACK_ENV production

COPY . ./

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
