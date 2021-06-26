resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = var.alias_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = var.source_owner
      provider         = var.source_provider
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
          RepositoryName       = var.repo_name
          BranchName           = var.repo_default_branch
          PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "DevBuild"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["dev_build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.dev_build_project_name
      }
    }
  }
  stage {
    name = "Approval"

    action {
        name     = "Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"
    }
  }

  stage {
    name = "ProdBuild"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["dev_build_output"]
      output_artifacts = ["prod_build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.prod_build_project_name
      }
    }
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.artifact_bucket_name
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"
  assume_role_policy = file("${path.module}/cp_assume_role_policy.json")
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id
  policy = file("${path.module}/role_policy.json")
}
