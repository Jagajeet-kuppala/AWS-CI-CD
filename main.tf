provider "aws" {
  region = "ap-south-1"
}

module "frontend-app-codeCommit" {
  source = "./resources/CodeCommit/"
  repo_name = "frontend-app"
}
