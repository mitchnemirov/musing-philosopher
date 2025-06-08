FROM ruby:3.3.6

RUN apt-get update -qq && apt-get install -yqq --no-install-recommends \
  build-essential cron curl git gnupg2 less postgresql-client libpq-dev

ENV RAILS_ENV development
WORKDIR /site

# In development, we run as the 'ruby' user to avoid permission issues with the bind-mounted source code.
# Pass your UID/GID to Docker so files created with rails generators within the container are owned by
# your host user.
ARG UID=1000
ARG GID=100

RUN useradd --create-home --no-log-init -u ${UID} -g ${GID} ruby \
  && chown ${UID}:${GID} -R /site

USER ruby

ENV GEM_HOME /home/ruby/bundle
ENV PATH /home/ruby/bundle/bin:$PATH

RUN gem update --system && gem install bundler

EXPOSE 4000

ENTRYPOINT ["./entrypoint.sh"]

CMD ["jekyll", "serve", "--livereload", "--host", "0.0.0.0"]
