FROM ubuntu:16.04

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

RUN chown -R nobody:nogroup /app

USER nobody

# Expose port 5000 to the Docker host, so we can access it
# from the outside.
EXPOSE 5000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["sh", "-c", "bundle exec rails server -b 0.0.0.0 -e $RAILS_ENV"]
