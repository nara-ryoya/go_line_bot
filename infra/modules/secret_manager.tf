resource "aws_secretsmanager_secret" "channel_token" {
    name = "channel_token"
}

resource "aws_secretsmanager_secret" "channel_secret" {
    name = "channel_secret"
}