# -----------------------
# 変数定義
# -----------------------
variable "aws_region" {
  default = "ap-northeast-1"
}

variable "aws_account_id" {
  default = "264008915581"
}

variable "repo_name" {
  default = "laravel-sample"
}

variable "image_tag" {
  default = "latest"
}

# ダミードメイン
variable "domain_name" {
  default = "example.com"
}

variable "subdomain" {
  default = "app"
}
