FROM postgres:11-alpine
RUN set -ex && \
	apk add --no-cache --update-cache --virtual tar curl make g++ postgresql-dev && \
	mkdir -p /tmp/pgaudit && \
	cd /tmp/pgaudit && \
	curl -L https://github.com/pgaudit/pgaudit/archive/1.3.2.tar.gz | tar xz --strip 1 && \
	make -C /tmp/pgaudit/ install USE_PGXS=1 && \
	apk del curl make g++ postgresql-dev

COPY ./my-docker-entrypoint.sh /usr/local/bin/
COPY init.sql /docker-entrypoint-initdb.d/

ENTRYPOINT ["my-docker-entrypoint.sh"]
CMD ["postgres"]
