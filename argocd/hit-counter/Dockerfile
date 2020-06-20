FROM ubuntu:18.04 

COPY . /srv 

RUN apt-get update && apt-get install curl -y && apt-get install python3-pip -y && pip3 install -r /srv/requirements.txt

EXPOSE 80/tcp 

CMD python3 /srv/server.py
