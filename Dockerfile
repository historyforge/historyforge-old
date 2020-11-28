FROM gorges/historyforge

COPY ./lib/docker/database.yml ./config/database.yml
COPY ./lib/docker/secrets.yml ./config/secrets.yml

CMD ["/bin/bash"]
