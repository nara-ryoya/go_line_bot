resource "aws_cloudwatch_log_group" "line_bot_lambda_log_group" {
    name = "/aws/lambda/${local.lambda_function_name}"
}
