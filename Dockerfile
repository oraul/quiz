FROM ruby:3.2.2-alpine3.18

ENV APP_PATH=/usr/src/app \
    PORT=3000

RUN apk update && \
    apk add -f bash \
               build-base \
               git \
               libc6-compat \
               tzdata \
               postgresql-dev \
               postgresql-client

WORKDIR ${APP_PATH}

COPY Gemfile Gemfile.lock ${APP_PATH}

RUN bundle install

COPY . ${APP_PATH}

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE ${PORT}

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
