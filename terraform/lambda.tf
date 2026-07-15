resource "aws_lambda_function" "read_primary" {
  provider = aws.primary

  function_name = "ReadFunction"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler        = "read_function.lambda_handler"

  filename         = "../lambda/read_function.zip"
  source_code_hash = filebase64sha256("../lambda/read_function.zip")
}

resource "aws_lambda_function" "write_primary" {
  provider = aws.primary

  function_name = "WriteFunction"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler        = "write_function.lambda_handler"

  filename         = "../lambda/write_function.zip"
  source_code_hash = filebase64sha256("../lambda/write_function.zip")
}

resource "aws_lambda_function" "read_secondary" {
  provider = aws.secondary

  function_name = "ReadFunction"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler        = "read_function.lambda_handler"

  filename         = "../lambda/read_function.zip"
  source_code_hash = filebase64sha256("../lambda/read_function.zip")
}

resource "aws_lambda_function" "write_secondary" {
  provider = aws.secondary

  function_name = "WriteFunction"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler        = "write_function.lambda_handler"

  filename         = "../lambda/write_function.zip"
  source_code_hash = filebase64sha256("../lambda/write_function.zip")
}