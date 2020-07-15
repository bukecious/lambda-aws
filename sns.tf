# resource "aws_sns_topic" "topic" {
#   name = "mytopic"
# }

# resource "aws_sns_topic_subscription" "topic_lambda" {
#   topic_arn = "${aws_sns_topic.topic.arn}"
#   protocol  = "lambda"
#   endpoint  = "${aws_lambda_function.lambda.arn}"
# }

# # resource "aws_lambda_function" "lambda" {
# #   filename         = "lambda.zip"
# #   function_name    = "lambda-handler"
# #   role             = "${aws_iam_role.cloudwatch_alarms_lambda.arn}"
# #   handler          = "entrypoint.lambda_handler"
# #   runtime          = "python2.7"
# #   source_code_hash = "..."

# #   environment {
# #     variables {
# #       env = "${var.stack}"
# #     }
# #   }
# # }

# resource "aws_lambda_permission" "with_sns" {
#     statement_id = "AllowExecutionFromSNS"
#     action = "lambda:InvokeFunction"
#     function_name = "${aws_lambda_function.lambda.arn}"
#     principal = "sns.amazonaws.com"
#     source_arn = "${aws_sns_topic.topic.arn}"
# }
