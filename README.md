# HistoryForge

This is HistoryForge. It is a basic Rails application.

## Installation

1. Log into your Digitalocean account. (Or other hosting provider assuming you know what you are doing...)
2. Create -> Droplets with the following settings:
    - Distribution: Ubuntu 20.04 (LTS)
    - Plan: Basic $10/mo to start, upgrade leter as needed
    - Choose a data center near you, preferably New York 1
    - Select additional options: Monitoring
    - Authentication - by SSH Key NOT password - follow the instructions if you don't have an SSH key and/or don't know what that means!
    - Finalize and create 1 droplet - give it a meaningful name such as "historyforge"
    - Enable Backups
    - Copy the IP address of the droplet created

3. While droplet is building, download the code from GitHub to your computer: 
```
git clone git@github.com:historyforge/historyforge.git`
```

4. Connect it to the droplet you just created:  (hf is short for historyforge, to save typing)
```
git remote add dokku dokku@DROPLET.IP.NUMBER.HERE:hf
```

5. Log into your new droplet using SSH (these instructions work for Mac and Linux, ought to work for Windows Powershell):
```
ssh root@YOUR.SERVER.IP.ADDRESS
```

Logged in? First update the system. It will ask you a few questions - say yes - and churn for awhile.
```
apt update && apt upgrade && apt autoremove
```
While the updates install, it is a good time to go to your DNS provider and set up the domain you will use for your historyforge installation. You need to create an "A" record pointing at the IP address. So I might create an A record for `historyforge.thehistorycenter.net` to point to `157.230.234.235`.

Now install dokku:
```
wget https://raw.githubusercontent.com/dokku/dokku/v0.21.4/bootstrap.sh;
sudo DOKKU_TAG=v0.21.4 bash bootstrap.sh
```
It will churn and gurgle for a few minutes as it installs Docker, herokuish, nginx, dokku, and other packages. While it churns open a web browser and enter the IP address of your droplet in the address bar. When the install is complete, keep refreshing until you see a page that says "Dokku Setup". It should have a big text box with your SSH key in it. Click "complete setup". Failure to do this will leave your system vulnerable to hacking.

After you have done that final confirmation step, reboot your droplet:
```
reboot
```

7. Setup dokku:
```
ssh root@YOUR.SERVER.IP.ADDRESS

dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

dokku apps:create hf
cd /var/lib/dokku/data/storage
mkdir storage
mkdir packs
mkdir assets
chown -R 32767:32767 storage
chown -R 32767:32767 packs
chown -R 32767:32767 assets
cd
dokku storage:mount hf /var/lib/dokku/data/storage/storage:/app/storage
dokku storage:mount hf /var/lib/dokku/data/storage/packs:/app/packs
dokku storage:mount hf /var/lib/dokku/data/storage/assets:/app/assets
dokku postgres:create hf
dokku postgres:link hf hf
dokku domains:add yourdomain.com www.yourdomain.com
```

8. Open up the file ".exampleconfig" in the project folder. Here is the most tedious part of the whole enterprise.
- for SECRET_KEY_BASE and DEVISE_SECRET_KEY, go to passwordsgenerator.net and create strong passwords with no symbols with length of 23.
- for sending "forgot password" emails, go to sendgrid.com and set up a free account, create an API key, and paste it in the SMTP_PASSWORD spot.
- set up Google API Console with billing, and add the Maps Javascript API. Paste the key into the relevant spot. There is room for two so that you can limit the public maps key to your domain and limit the geocoding key to server access only. If you have troubles Google searches will have to suffice.
- the recaptcha key (search Google) will cut down on spam contact mail
- replace all the email address and the base URL with values that make sense for you

Once you've filled in all the blanks, copy the whole file and paste it into your SSH terminal where earlier you pasted those `dokku` commands. It should churn a bit and tell you that the `App hf has not been deployed.`

9. Time to push the code from your local machine to the droplet. In a different terminal window, from the project folder, type:
```
git push dokku master
```
It should churn and gurgle for a long time with messages about fetching buildpacks, installing, detecting, writing, etc.