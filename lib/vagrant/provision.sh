
# make sure we have up-to-date packages
apt-get update

# upgrade all packages
apt-get upgrade -y

apt install -y postgresql-10-postgis-2.4 postgresql-server-dev-all libxml2-dev ruby-dev imagemagick gdal-bin ruby-mapscript nodejs imagemagick

gem install bundler
gem update --system --no-user-install

sudo -u vagrant -H bundle install --path ~/.gem

## install the bundle necessary for mapwarper
pushd /app

# do bundle install as a convenience
sudo -u vagrant -H bundle install
# create user and database for openstreetmap-website
db_user_exists=`sudo -u postgres psql postgres -tAc "select 1 from pg_roles where rolname='vagrant'"`
if [ "$db_user_exists" != "1" ]; then
		sudo -u postgres createuser -s vagrant
		sudo -u vagrant -H createdb -E UTF-8 -O vagrant mapwarper_development
fi

# build and set up postgres extensions

sudo -u vagrant psql mapwarper_development -c "create extension postgis;"


# set up sample configs
if [ ! -f config/database.yml ]; then
		sudo -u vagrant cp config/database.example.yml config/database.yml
fi
if [ ! -f config/application.yml ]; then
		sudo -u vagrant cp config/application.example.yml config/application.yml
fi
if [ ! -f config/secrets.yml ]; then
		sudo -u vagrant cp config/secrets.yml.example config/secrets.yml
fi

echo "now migrating database. This may take a few minutes"
# migrate the database to the latest version
sudo -u vagrant -H bundle exec rake db:migrate
popd
