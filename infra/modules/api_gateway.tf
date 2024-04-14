resource "aws_api_gateway_rest_api" "line_bot_api_gateway_rest_api" {
    name = "line-bot-api-gateway-rest-api"
    description = "api for line bot"
    policy = data.aws_iam_policy_document.line_bot_api_gateway_policy_document.json
}

resource "aws_api_gateway_resource" "line_bot_api_gateway_resource" {
    rest_api_id = aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.id
    parent_id = aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.root_resource_id
    path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "line_bot_api_gateway_method" {
    authorization = "NONE"
    http_method = "ANY"
    resource_id = aws_api_gateway_resource.line_bot_api_gateway_resource.id
    rest_api_id = aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.id
}

resource "aws_api_gateway_integration" "line_bot_api_gateway_integration" {
    rest_api_id             = aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.id
    resource_id             = aws_api_gateway_method.line_bot_api_gateway_method.resource_id
    http_method             = aws_api_gateway_method.line_bot_api_gateway_method.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.line_bot_lambda.invoke_arn
}

resource "aws_api_gateway_method" "line_bot_api_gateway_proxy_root" {
    rest_api_id             = aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.id
    resource_id             =  aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.root_resource_id
    http_method   = "ANY"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "line_bot_api_gateway_integration_root" {
    rest_api_id             = aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.id
    resource_id             = aws_api_gateway_method.line_bot_api_gateway_proxy_root.resource_id
    http_method             = aws_api_gateway_method.line_bot_api_gateway_proxy_root.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.line_bot_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "line_bot_api_gateway_deployment" {
    depends_on = [
        aws_api_gateway_integration.line_bot_api_gateway_integration,
        aws_api_gateway_integration.line_bot_api_gateway_integration_root
    ]
    rest_api_id       = aws_api_gateway_rest_api.line_bot_api_gateway_rest_api.id
    stage_name        = "test"
    stage_description = "test stage"
}

output "base_url" {
    value = aws_api_gateway_deployment.line_bot_api_gateway_deployment.invoke_url
}