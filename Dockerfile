FROM node:16.17-alpine as builder

RUN npm install -g --production --omit=dev eslint@7.20.0;
RUN npm install -g --production --omit=dev eslint-config-openlayers@7.0.0;

# Remove unecessary files
RUN set -eux \
	&& find /usr/local/lib/node_modules -type d -iname 'test' -prune -exec rm -rf '{}' \; \
	&& find /usr/local/lib/node_modules -type d -iname 'tests' -prune -exec rm -rf '{}' \; \
	&& find /usr/local/lib/node_modules -type d -iname 'testing' -prune -exec rm -rf '{}' \; \
	&& find /usr/local/lib/node_modules -type d -iname '.bin' -prune -exec rm -rf '{}' \; \
	\
	&& find /usr/local/lib/node_modules -type f -iname '.*' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname 'LICENSE*' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname 'Makefile*' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.bnf' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.css' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.def' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.flow' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.html' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.info' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.jst' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.lock' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.map' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.markdown' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.md' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.mjs' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.mli' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.png' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.ts' -exec rm {} \; \
	&& find /usr/local/lib/node_modules -type f -iname '*.yml' -exec rm {} \;

FROM node:16.17-alpine
LABEL \
	maintainer="cytopia <cytopia@everythingcli.org>" \
	repo="https://github.com/cytopia/docker-eslint"
COPY --from=builder /usr/local/lib/node_modules/ /node_modules/
RUN ln -sf /node_modules/eslint/bin/eslint.js /usr/bin/eslint

WORKDIR /data
ENTRYPOINT ["eslint"]
CMD ["--help"]
