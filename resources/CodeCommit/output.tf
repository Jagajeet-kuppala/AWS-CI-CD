output "repo_arn" {
  value = aws_codecommit_repository.code_commit_repo.arn
}

output "repo_id" {
  value = aws_codecommit_repository.code_commit_repo.repository_id
}

output "http_clone_url" {
  value = aws_codecommit_repository.code_commit_repo.clone_url_http
}
