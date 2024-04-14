data "aws_iam_policy_document" "line_bot_api_gateway_policy_document" {
    statement {
        effect = "Allow"
        principals {
            type = "*"
            identifiers = ["*"]
        }
        actions = [
            "execute-api:Invoke"
        ]
        resources = [
            "arn:aws:execute-api:${var.region}:*:*/*/*"
        ]
    }
}

data "aws_iam_policy_document" "line_bot_lambda_policy_document" {
    statement {
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [
            "arn:aws:logs:*:*:*"
        ]
    }
}

resource "aws_iam_policy" "line_bot_lambda_policy" {
    name = "line-bot-lambda-policy"
    policy = data.aws_iam_policy_document.line_bot_lambda_policy_document.json
}

resource "aws_iam_role" "line_bot_lambda_role" {
    name = "line-bot-lambda-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                "Action" = "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role = aws_iam_role.line_bot_lambda_role.name
    policy_arn = aws_iam_policy.line_bot_lambda_policy.arn
}