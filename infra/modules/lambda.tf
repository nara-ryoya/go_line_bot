resource "aws_lambda_function" "line_bot_lambda" {
    filename      = "dummy_function.zip"
    function_name = "line-bot-api"
    role          = aws_iam_role.line_bot_lambda_role.arn
    handler       = "lambda"
    runtime       = "provided.al2023"

    memory_size = 128
    timeout     = 900
}

resource "aws_lambda_permission" "line_bot_api_gateway_lambda" {
    action = "lambda:InvokeFnction"
    function_name = aws_lambda_function.line_bot_lambda.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.execution_arn}/*/*/*"
}