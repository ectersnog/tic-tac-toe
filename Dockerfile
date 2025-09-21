ARG BASE_RUBY_IMAGE_TAG="3.3.5-alpine"
FROM ruby:${BASE_RUBY_IMAGE_TAG} AS base
ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV}

# App specific ENV
ENV BASE_EMAIL=
ENV BASE_URL=
ENV REDIS_URL=
ENV SECRET_KEY_BASE=
ENV SENDGRID_API_KEY=

ARG TARGETARCH
RUN if [ "${TARGETARCH}" = "arm64" ]; then \
  apk add --no-cache \
  gcompat; \
  fi;
RUN apk add --no-cache \
    build-base \
    curl \
    git \
    postgresql-dev \
    postgresql-client \
    vips \
    tzdata
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.9
RUN if [ "$RAILS_ENV" == "production" ]; then bundle config set --local without 'development test'; fi
RUN MAKE="make --jobs 5" bundle install --jobs=5 --no-cache --retry=5 && \
    bundle config unset rubygems.pkg.github.com
COPY . ./
ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["rails", "server", "-b", "0.0.0.0"]

