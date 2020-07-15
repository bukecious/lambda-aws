resource "aws_lambda_function" "lambda" {
  filename      = "${var.name}.zip"
  function_name = "${var.name}_${var.handler}"
  role          = "${var.role}"
  handler       = "${var.name}.${var.handler}"
  runtime       = "${var.runtime}"
}

# SNS bit 

resource "aws_sns_topic" "topic" {
  name = "mytopic"
}

resource "aws_sns_topic_subscription" "topic_lambda" {
  topic_arn = "${aws_sns_topic.topic.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.lambda.arn}"
}


resource "aws_lambda_permission" "with_sns" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda.arn}"
    principal = "sns.amazonaws.com"
    source_arn = "${aws_sns_topic.topic.arn}"
}

# sending notification to the topic

module "notify" {
  source        = "git::https://github.com/bitflight-public/terraform-aws-sns-topic-notify.git?ref=master"
}
