FROM ruby:3.1

ENV APP_DIR=/opt/app/

WORKDIR $APP_DIR

RUN apt-get update -y && \
apt-get install -y \
libpq-dev libgsl0-dev \
postgresql-client

COPY Gemfile* $APP_DIR

RUN bundle install --without development test

COPY . $APP_DIR

EXPOSE 3000

CMD ["sleep", "7d"]