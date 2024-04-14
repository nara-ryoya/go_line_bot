package main

import (
	"context"
	// "fmt"
	"log"
	"net/http"
	// "os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/awslabs/aws-lambda-go-api-proxy/gin"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	// "github.com/line/line-bot-sdk-go/linebot"
)

var ginLambda *ginadapter.GinLambda

func init() {
	if err := godotenv.Load(); err != nil {
		log.Fatal(err)
	}
	// bot, err := linebot.New(
	// 	os.Getenv("CHANNEL_SECRET"),
	// 	os.Getenv("CHANNEL_TOKEN"),
	// )

	// if err != nil {
	// 	log.Fatal(err)
	// }

	// port := os.Getenv("PORT")
	router := gin.Default()
	router.GET("/hello", func(ctx *gin.Context) {
		ctx.String(http.StatusOK, "Hello, world!")
	})
	// router.POST("/callback", func(ctx *gin.Context) {
	// 	events, err := bot.ParseRequest(ctx.Request)
	// 	if err != nil {
	// 		if err == linebot.ErrInvalidSignature {
	// 			ctx.Writer.WriteHeader(400)
	// 		} else {
	// 			ctx.Writer.WriteHeader(500)
	// 		}
	// 	}
	// 	for _, event := range events {
	// 		if event.Type == linebot.EventTypeMessage {
	// 			switch message := event.Message.(type) {
	// 			case *linebot.TextMessage:
	// 				if _, err := bot.ReplyMessage(event.ReplyToken, linebot.NewTextMessage(message.Text)).Do(); err != nil {
	// 					log.Print(err)
	// 				}
	// 			case *linebot.StickerMessage:
	// 				replyMessage := fmt.Sprintf("sticker id is %s, stickerResourceType is %s", message.StickerID, message.StickerResourceType)
	// 				if _, err := bot.ReplyMessage(event.ReplyToken, linebot.NewTextMessage(replyMessage)).Do(); err != nil {
	// 					log.Print(err)
	// 				}
	// 			}
	// 		}
	// 	}
	// })
	// router.Run(fmt.Sprintf(":%s", port))
	ginLambda = ginadapter.New(router)
}

func Handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return ginLambda.ProxyWithContext(ctx, req)
}

func main() {
	lambda.Start(Handler)
}
