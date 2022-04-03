FROM golang:1.17-alpine as builder
ARG Version
WORKDIR /app
COPY extern/collect-homework-go /app
RUN go mod download
ENV Module=github.com/ChenKS12138/collect-homework-go
RUN go build -ldflags "-X '${Module}/util.Version=${Version}' -X '${Module}/util.BuildTime=$(date "+%Y-%m-%d %H:%M:%S")'" -o ./build/main

FROM alpine:edge
ENV DB_ADDR=""
ENV JWT_SECRET="secret"
ENV PORT=80
ENV DB_NETWORK="TCP"
ENV DB_USER=""
ENV DB_PASSWORD=""
ENV DB_DATABASE=""
ENV DB_DEBUG="false"
ENV EMAIL_USER=""
ENV EMAIL_PASSWORD=""
ENV STORAGE_PATH_PREFIX="/storage"
ENV TEMP_PATH_PREFIX="/tmp/collect-homework"
ENV SUPER_USER_NAME="admin"
ENV SUPER_USER_EMAIL="admin@example.com"
ENV SUPER_USER_PASSWORD="pasword"

WORKDIR /app
COPY --from=builder /app/build/main /main

VOLUME [ "/var/run/docker.sock" ]

EXPOSE 80

CMD /main migrate --init && /main serve