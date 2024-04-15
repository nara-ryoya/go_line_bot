package api

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"go_linebot/api/secrets"
	"log"
	"net/http"

	"github.com/line/line-bot-sdk-go/linebot"
)

func NewServer() (*gin.Engine, error) {
	// if err := godotenv.Load(); err != nil {
	// 	log.Fatal(err)
	// }
	allSecrets := secrets.GetAllSecrets()
	bot, err := linebot.New(
		allSecrets.ChannelSecret,
		allSecrets.ChannelToken,
	)

	if err != nil {
		log.Fatal(err)
		return nil, err
	}
	router := gin.Default()
	router.GET("/hello", func(ctx *gin.Context) {
		ctx.String(http.StatusOK, "Hello, world!")
	})
	router.POST("/", func(ctx *gin.Context) {
		events, err := bot.ParseRequest(ctx.Request)
		if err != nil {
			if err == linebot.ErrInvalidSignature {
				ctx.Writer.WriteHeader(400)
			} else {
				ctx.Writer.WriteHeader(500)
			}
		}
		for _, event := range events {
			if event.Type == linebot.EventTypeMessage {
				switch message := event.Message.(type) {
				case *linebot.TextMessage:
					if _, err := bot.ReplyMessage(event.ReplyToken, linebot.NewTextMessage(message.Text)).Do(); err != nil {
						log.Print(err)
					}
				case *linebot.StickerMessage:
					replyMessage := fmt.Sprintf("sticker id is %s, stickerResourceType is %s", message.StickerID, message.StickerResourceType)
					if _, err := bot.ReplyMessage(event.ReplyToken, linebot.NewTextMessage(replyMessage)).Do(); err != nil {
						log.Print(err)
					}
				}
			}
		}
	})
	return router, nil
}
