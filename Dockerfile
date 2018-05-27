FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && apt-get install -y ruby libruby ruby-dev \
    build-essential git-core libxml2-dev libxslt-dev imagemagick \
    libmapserver2 gdal-bin libgdal-dev ruby-mapscript nodejs \
    tzdata \
     && rm -rf /var/lib/apt/lists/*

ENV BUNDLE_PATH /bundle

RUN mkdir /app
WORKDIR /app
ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock
RUN gem install bundler
RUN bundle config build.nokogiri --use-system-libraries \
    && bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . .

ADD lib/docker/database.yml ./config/database.yml

ADD lib/docker/secrets.yml ./config/secrets.yml

COPY lib/docker/default_user.bash ./default_user.bash

RUN bash default_user.bash && rm -f default_user.bash

# Provide dummy data to Rails so it can pre-compile assets.
# RUN bundle exec rails RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_KEY_BASE=funkytown assets:precompile

RUN chown -R herokuishuser /app

USER herokuishuser

# Expose port 5000 to the Docker host, so we can access it
# from the outside.
# EXPOSE 5000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
#CMD ["sh", "-c", "bundle exec rails server -b 0.0.0.0 -e $RAILS_ENV"]
