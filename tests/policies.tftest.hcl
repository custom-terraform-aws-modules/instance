provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Environment = "Test"
    }
  }
}

run "valid_policies" {
  command = plan

  variables {
    identifier = "abc"
    vpc        = "vpc-23548235"
    subnet     = "subnet-235402395"
    policies = [
      "arn:aws:iam::aws:policy/aws-service-role/AccessAnalyzerServiceRolePolicy",
      "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
    ]
    public_key = "test-public-key-123"
  }

  assert {
    condition     = length(var.policies) == length(aws_iam_role_policy_attachment.import)
    error_message = "IAM policy attachment was not created for every policy"
  }
}
