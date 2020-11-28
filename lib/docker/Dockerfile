FROM gorges/railsready

RUN mkdir /app
WORKDIR /app

ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock

RUN bundle config set without 'development:test' \
    && bundle install --jobs 20 --retry 5

COPY . .

COPY lib/docker/default_user.bash ./default_user.bash
RUN bash default_user.bash && rm -f default_user.bash
RUN chown -R herokuishuser /app
USER herokuishuser
