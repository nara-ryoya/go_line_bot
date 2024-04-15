fmt:
	go fmt ./...
.PHONY: fmt

lint: fmt
		staticcheck ./...
.PHONY: liint
vet: fmt
		go vet ./...
.PHONY: vet


lambda_deploy:
	GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o bootstrap cmd/lambda_handler/main.go && \
		zip myFunction.zip bootstrap && \
		aws lambda update-function-code --region ap-northeast-1 --function-name line-bot-api --profile nara-line --zip-file fileb://myFunction.zip && \
		rm bootstrap myFunction.zip
.PHONY: lambda_build