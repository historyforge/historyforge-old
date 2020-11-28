FROM gorges/railsready

RUN mkdir /app
WORKDIR /app

ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock

RUN bundle config set without 'development:test' \
    && bundle install --jobs 20 --retry 5

COPY . .

RUN addgroup --quiet --gid "32767" "herokuishuser" && \
    adduser \
        --shell /bin/bash \
        --disabled-password \
        --force-badname \
        --no-create-home \
        --uid "32767" \
        --gid "32767" \
        --gecos '' \
        --quiet \
        --home "/app" \
        "herokuishuser" && \
    chown -R herokuishuser /app

USER herokuishuser
