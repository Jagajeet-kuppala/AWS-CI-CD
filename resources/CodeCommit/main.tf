provider "aws" {
  region = "ap-south-1"
}

resource "aws_codecommit_repository" "code_commit_repo" {
  repository_name = var.repo_name
}
