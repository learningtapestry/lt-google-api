FROM ruby:2.7.7

ENV APP_PATH /app/
ENV LANG C.UTF-8
ENV GIT_AUTHOR_NAME "Joe Doe"
ENV GIT_AUTHOR_EMAIL joe@doe.com

WORKDIR $APP_PATH

COPY . $APP_PATH

ENV BUNDLER_VERSION 2.4.22
RUN gem install bundler:"$BUNDLER_VERSION" \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete
