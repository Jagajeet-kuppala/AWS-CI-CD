provider "aws" {
  region = var.region
}

resource "aws_codecommit_repository" "code_commit_repo" {
  repository_name = var.repo_name
}
