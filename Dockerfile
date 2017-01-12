FROM jekyll/jekyll:3.2.1
MAINTAINER lennard@upday.com

WORKDIR /app

ADD Gemfile /app
ADD Gemfile.lock /app

RUN apk --update-cache --no-cache add --virtual build-dependencies \
      build-base \
      libffi-dev \
      ruby-dev && \
    bundle install && \
    sleep 5 && \
    apk del build-dependencies

VOLUME /app

EXPOSE 4000

ENTRYPOINT ["bundle", "exec"]
CMD ["jekyll", "serve", "--config", "_config_local.yml"]
