# https://blog.devgenius.io/go-docker-hello-world-f092ecf7cead
FROM golang:latest

RUN mkdir /app

ADD main.go /app

WORKDIR /app

RUN go version && go mod init web-go

RUN go build -o web-go .

ENV PORT 8000

EXPOSE $PORT

ENTRYPOINT ["/app/web-go"]