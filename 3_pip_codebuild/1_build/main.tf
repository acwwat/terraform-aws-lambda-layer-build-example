terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.5"
}

provider "aws" {}

data "aws_caller_identity" "this" {}

data "aws_partition" "this" {}

data "aws_region" "this" {}


locals {
  account_id = data.aws_caller_identity.this.account_id
  partition  = data.aws_partition.this.partition
  region     = data.aws_region.this.name
}

resource "aws_iam_role" "example_lambda_layer" {
  name = "ExampleLambdaLayerCodeBuildRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "example_lambda_layer" {
  name = "ExampleLambdaLayerCodeBuildPolicy"
  role = aws_iam_role.example_lambda_layer.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/*"
      },
      {
        Action = [
          "lambda:PublishLayerVersion"
        ],
        Effect   = "Allow"
        Resource = "arn:${local.partition}:lambda:${local.region}:${local.account_id}:layer:*"
      }
    ]
  })
}

resource "aws_codebuild_project" "example_lambda_layer" {
  name         = "example-lambda-layer-build"
  description  = "Build project for example-lambda-layer"
  service_role = aws_iam_role.example_lambda_layer.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "LAYER_NAME"
      value = "example-lambda-layer"
    }
  }
  source {
    buildspec = file("${path.module}/codebuild/buildspec.yml")
    type      = "NO_SOURCE"
  }
}
