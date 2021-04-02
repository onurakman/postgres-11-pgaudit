FROM postgres:11-alpine
COPY my-docker-entrypoint.sh /usr/local/bin/
COPY init.sql /docker-entrypoint-initdb.d/
RUN set -ex && \
	apk add --no-cache --update-cache --virtual tar curl make g++ postgresql-dev && \
	mkdir -p /tmp/pgaudit && \
	cd /tmp/pgaudit && \
	curl -L https://github.com/pgaudit/pgaudit/archive/1.3.2.tar.gz | tar xz --strip 1 && \
	make -C /tmp/pgaudit/ install USE_PGXS=1 && \
	apk del curl make g++ postgresql-dev && \
	cd / && \
	rm -rf /tmp/pgaudit && \
	ln -s usr/local/bin/my-docker-entrypoint.sh /

ENTRYPOINT ["my-docker-entrypoint.sh"]
CMD ["postgres"]
