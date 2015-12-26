#!/usr/bin/env bash

pushd /srv/mapwarper

echo "gem: --no-document" > ~/.gemrc
gem install bundler && bundle

popd
