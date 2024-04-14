resource "aws_lambda_function" "line_bot_lambda" {
    filename      = "dummy_function.zip"
    function_name = local.lambda_function_name
    role          = aws_iam_role.line_bot_lambda_role.arn
    handler       = "lambda"
    runtime       = "provided.al2023"

    memory_size = 128
    timeout     = 900
    environment {
        variables = {
            CHANNEL_SECRET = aws_secretsmanager_secret.channel_secret.
            CHANNEL_TOKEN  = aws_secretsmanager_secret.channel_token.name
        }
    }

    depends_on = [ aws_cloudwatch_log_group.line_bot_lambda_log_group ]
}

resource "aws_lambda_permission" "line_bot_api_gateway_lambda" {
    action = "lambda:InvokeFnction"
    function_name = aws_lambda_function.line_bot_lambda.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw" {
    statement_id  = "AllowAPIGatewayInvoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.line_bot_lambda.function_name
    principal     = "apigateway.amazonaws.com"

    # The /*/* portion grants access from any method on any resource
    # within the API Gateway "REST API".
    source_arn = "${aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.execution_arn}/*"
}