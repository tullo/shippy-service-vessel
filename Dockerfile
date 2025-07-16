FROM golang:1.24.5-alpine as builder

RUN apk update && apk upgrade && \
    apk add --no-cache git

RUN mkdir /app
WORKDIR /app

ENV GO111MODULE=on

COPY go.* .
RUN go mod download

COPY *.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-service-vessel

# Run container
FROM alpine:3.22.1

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app

COPY --from=builder /app/shippy-service-vessel .

CMD ["./shippy-service-vessel"]
