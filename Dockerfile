FROM golang:1.22-alpine3.19 as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o main /app/main.go

FROM alpine:3.19

WORKDIR /app

COPY --from=builder /app/main /app/main

COPY .env ./

EXPOSE 8080

CMD ["/app/main"]