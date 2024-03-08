provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Environment = "Test"
    }
  }
}

run "invalid_identifier" {
  command = plan

  variables {
    identifier = "ab"
    vpc        = "vpc-23548235"
    subnet     = "subnet-235402395"
    public_key = "test-public-key-123"
  }

  expect_failures = [var.identifier]
}

run "invalid_subnet" {
  command = plan

  variables {
    identifier = "abc"
    vpc        = "vpc-32549234"
    subnet     = "sub-234sfwlfw"
    public_key = "test-public-key-123"
  }

  expect_failures = [var.subnet]
}

run "invalid_vpc" {
  command = plan

  variables {
    identifier = "abc"
    vpc        = "vc-32549234"
    subnet     = "subnet-234sfwlfw"
    public_key = "test-public-key-123"
  }

  expect_failures = [var.vpc]
}

run "invalid_security_groups" {
  command = plan

  variables {
    identifier      = "abc"
    vpc             = "vpc-23548235"
    subnet          = "subnet-235402395"
    security_groups = ["sg-wetgo2igweg", "s-ewtowetwet", "sg-wetrwetwe"]
    public_key      = "test-public-key-123"
  }

  expect_failures = [var.security_groups]
}

run "valid_config" {
  command = plan

  variables {
    identifier = "abc"
    vpc        = "vpc-23548235"
    subnet     = "subnet-235402395"
    public_key = "test-public-key-123"
  }
}
