FROM gorges/railsready

#FROM ubuntu:20.04
#
#ENV DEBIAN_FRONTEND noninteractive
#ENV RAILS_ENV production
#
#RUN apt-get update -qq && apt-get install -y curl
#
#RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
#    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#
#RUN apt-get update -qq && \
#  DEBIAN_FRONTEND=noninteractive apt-get install -y \
#  automake build-essential patch zlib1g-dev liblzma-dev git \
#  ffmpeg libssl-dev libreadline-dev \
#  libyaml-dev libcurl4-openssl-dev libffi-dev \
#  libpq-dev ruby-dev nodejs yarn libvips
#
#RUN \
#  # Clean up
#  apt-get autoremove -y && \
#  apt-get autoclean && \
#  apt-get clean && \
#  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
## Now start installing the app itself
#
#ENV BUNDLE_PATH /bundle
#ENV RUBYOPT '-W:no-deprecated'
#
#RUN gem install bundler

RUN mkdir /app
WORKDIR /app

ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock

RUN bundle config set without 'development:test' \
    && bundle install --jobs 20 --retry 5

# Install yarn packages
COPY package.json yarn.lock .yarnclean /app/
RUN yarn install

# Copy the main application.
COPY . .

COPY lib/docker/default_user.bash ./default_user.bash
RUN bash default_user.bash && rm -f default_user.bash
RUN chown -R herokuishuser /app
USER herokuishuser

#EXPOSE 5000
