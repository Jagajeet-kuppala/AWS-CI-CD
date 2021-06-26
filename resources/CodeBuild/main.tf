provider "aws" {
  region = var.region
}
# Uncomment for logs storage and s3 caching
# resource "aws_s3_bucket" "code_build_bucket" {
#   bucket = var.bucket_name
#   acl    = "private"
# }

resource "aws_iam_role" "assume_role_policy" {
  name = "assume_role_policy"

  assume_role_policy = file("${path.module}/cb_assume_rolepolicy.json")
}

resource "aws_iam_role_policy" "role_policy" {
  role = aws_iam_role.assume_role_policy.name

  policy = file("${path.module}/role_policy.json")
}

resource "aws_codebuild_project" "codebuild" {
  name          = "${var.env}-${var.project_name}"
  description   = var.description
  build_timeout = "5"
  service_role  = aws_iam_role.assume_role_policy.arn

  artifacts {
    type = var.artifacts_type
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.build_image
    type                        = var.build_type
    image_pull_credentials_type = var.image_pull_credentials_type

    # UNCOMMENT TO ADD ENV VARIABLES
    # environment_variable {
    #   name  = "SOME_KEY"
    #   value = "SOME_VALUE"
    #   type  = "PARAMETER_STORE"
    # }
  }
  # UNCOMMENT TO ADD LOGS CONFIGURATION
  #   logs_config {
  #     cloudwatch_logs {
  #       group_name  = "log-group"
  #       stream_name = "log-stream"
  #     }

  #     s3_logs {
  #       status   = "ENABLED"
  #       location = "${aws_s3_bucket.example.id}/build-log"
  #     }
  #   }

  source {
    type            = var.source_type
    buildspec       = var.buildspec_name
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = var.fetch_submodules
    }
  }

  source_version = var.source_branch_name

  vpc_config {
    vpc_id = var.vpc_id

    subnets = var.subnet_ids

    security_group_ids = var.security_group_ids
  }

  tags = {
    env = var.env
  }
}