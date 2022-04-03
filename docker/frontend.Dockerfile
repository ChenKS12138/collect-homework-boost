FROM node:14-alpine as builder
ARG Version
ENV GIT_COMMIT_HASH=${Version}
COPY extern/collect-homework-frontend /app
WORKDIR /app
RUN yarn install --frozen-lockfile && yarn build

FROM alpine:edge
RUN apk update --no-cache && apk add lighttpd
COPY --from=builder /app/dist/ /var/www/localhost/htdocs/
EXPOSE 80
CMD /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf