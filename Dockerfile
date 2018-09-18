FROM alpine
MAINTAINER svm@familyc.ru

ENV TZ=Asia/Yekaterinburg \
	TG_BOT_ON=True \
	TG_BOT_TOKEN="123456789" \
	TG_BOT_PROXY=False \
	TG_BOT_PROXY=8.8.8.8 \
	TG_BOT_PROXY_AUTH=False\
	TG_BOT_PROXY_LOGIN=test \
	TG_BOT_PROXY_PASS=test \
    SOPDS_ROOT_LIB="/library" \
    SOPDS_INPX_ENABLE=True \
    SOPDS_LANGUAGE=ru-RU \
    MIGRATE=False \
    VERSION=0.46

RUN apk add --update tzdata bash nano build-base python3-dev libxml2-dev libxslt-dev unzip postgresql postgresql-dev libc-dev jpeg-dev zlib-dev mc htop
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone
RUN apk del tzdata
ADD http://www.sopds.ru/images/archives/sopds-v0.46.zip /sopds.zip
RUN unzip sopds.zip && rm sopds.zip && mv sopds-* sopds
ADD ./configs/requirements.txt /sopds/requirements.txt
ADD ./configs/settings.py /sopds/sopds/settings.py
WORKDIR /sopds
RUN pip3 install --upgrade pip setuptools psycopg2-binary && pip3 install --upgrade -r requirements.txt
RUN pip3 install python-telegram-bot[socks]
ADD ./scripts/start.sh /start.sh
RUN chmod +x /start.sh

VOLUME /var/lib/pgsql
EXPOSE 8001

ENTRYPOINT ["/start.sh"]
