package secrets

import (
	"context"
	"log"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
)

type Secrets struct {
	ChannelSecret string
	ChannelToken  string
}

func getSecret(secretName string, region string) string {
	config, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(region))
	if err != nil {
		log.Fatal(err)
	}

	// Create Secrets Manager client
	svc := secretsmanager.NewFromConfig(config)

	input := &secretsmanager.GetSecretValueInput{
		SecretId:     aws.String(secretName),
		VersionStage: aws.String("AWSCURRENT"), // VersionStage defaults to AWSCURRENT if unspecified
	}

	result, err := svc.GetSecretValue(context.TODO(), input)
	if err != nil {
		// For a list of exceptions thrown, see
		// https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
		log.Fatal(err.Error())
	}

	// Decrypts secret using the associated KMS key.
	return *result.SecretString
}

func GetAllSecrets() Secrets {
	region := "ap-northeast-1"
	channelSecret := getSecret("channel_secret", region)
	channelToken := getSecret("channel_token", region)

	allSecrets := Secrets{
		ChannelSecret: channelSecret,
		ChannelToken:  channelToken,
	}
	return allSecrets

	// Your code goes here.
}
