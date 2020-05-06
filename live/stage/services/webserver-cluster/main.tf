###
provider "aws" {
  version                 = "~> 2.0"
  region                  = "eu-west-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "ora2postgres"
}

terraform {
  required_version = "~> v0.12"

  backend "s3" {
    bucket = "tf-state-eu-west-2-rnbv"
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-west-2"

    dynamodb_table = "tf-locks-eu-west-2-rnbv"
    encrypt        = true
  }
}

module "webserver_cluster" {
  source = "github.com/baranovRP/tf-aws-rnbv-modules//modules/services/webserver-cluster?ref=v0.0.4"

  cluster_name           = "tf-webservers-stage"
  db_remote_state_bucket = "tf-state-eu-west-2-rnbv"
  db_remote_state_key    = "stage/services/webserver-cluster/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 4
}
