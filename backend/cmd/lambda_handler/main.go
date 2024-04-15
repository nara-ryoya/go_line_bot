package main

import (
	"context"
	"go_linebot/api"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/awslabs/aws-lambda-go-api-proxy/gin"
)

var ginLambda *ginadapter.GinLambda

func init() {
	// if err := godotenv.Load(); err != nil {
	// 	log.Fatal(err)
	// }
	router, err := api.NewServer()
	if err != nil {
		log.Fatal(err)
	}
	ginLambda = ginadapter.New(router)
}

func Handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return ginLambda.ProxyWithContext(ctx, req)
}

func main() {
	lambda.Start(Handler)
}
