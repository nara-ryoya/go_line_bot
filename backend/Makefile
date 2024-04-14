fmt:
	go fmt
.PHONY: fmt

lint: fmt
		staticcheck
.PHONY: liint
vet: fmt
		go vet
.PHONY: vet

build: vet
		go mod tidy
		go build
.PHONY: build

lambda_build:
	GOOS=linux GOARCH=arm64 go build -tags lambda.norpc -o bootstrap main.go && \
		zip myFunction.zip bootstrap
.PHONY: lambda_build