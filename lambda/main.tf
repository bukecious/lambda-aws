resource "aws_lambda_function" "lambda" {
  filename      = "${var.name}.zip"
  function_name = "${var.name}_${var.handler}"
  role          = "${var.role}"
  handler       = "${var.name}.${var.handler}"
  runtime       = "${var.runtime}"
  publish       = true
}

# SNS bit 

resource "aws_sns_topic" "topic" {
  name = "mytopic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
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

# testing SMS notification - just added 

resource "aws_sns_topic_subscription" "SMS" {
  topic_arn = "${aws_sns_topic.topic.arn}"
  protocol  = "SMS"
  endpoint  = "+2348033678361"
}

# preferences testing - just added 
resource "aws_sns_sms_preferences" "update_sms_prefs" {
  default_sender_id = "buklambda"

}


# invoke Config just added 
resource "aws_lambda_function_event_invoke_config" "SNSinvoke" {
  function_name = aws_lambda_function.lambda.function_name
  # role          = "${aws_iam_role.iam_role_for_SNSpublish.arn}"

  destination_config {
    on_success {
      destination = aws_sns_topic.topic.arn
    }
  }
}


# # sending notification to the topic

# module "notify" {
#   source        = "git::https://github.com/bitflight-public/terraform-aws-sns-topic-notify.git?ref=master"
#   namespace     = "cp"
#   stage         = "test"
#   name          = "lambda"
#   sns_topic_arn = "${aws_sns_topic.topic.arn}"
#   trigger_hash  = "${aws_lambda_function.lambda.source_code_hash}"
# }