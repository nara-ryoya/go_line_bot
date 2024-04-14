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

lambda_deploy:
	GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o bootstrap main.go && \
		zip myFunction.zip bootstrap && \
		aws lambda update-function-code --region ap-northeast-1 --function-name line-bot-api --profile nara-line --zip-file fileb://myFunction.zip
.PHONY: lambda_build