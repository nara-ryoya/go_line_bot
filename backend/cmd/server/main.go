package main

import (
	"go_linebot/api"
	"log"
)

func main() {
	// if err := godotenv.Load(); err != nil {
	// 	log.Fatal(err)
	// }
	router, err := api.NewServer()
	if err != nil {
		log.Fatal(err)
	}
	router.Run(":8080")
}