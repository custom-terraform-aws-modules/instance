# Module: Instance

This module provides an EC2 instance and creates a key pair with provided public SSH key to provide the option to tunnel into the instance.

## Contents

- [Requirements](#requirements)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Example](#example)
- [Contributing](#contributing)

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| aws       | >= 5.20 |

## Inputs

| Name            | Description                                                                                    | Type           | Default   | Required |
| --------------- | ---------------------------------------------------------------------------------------------- | -------------- | --------- | :------: |
| identifier      | Unique identifier to differentiate global resources.                                           | `string`       | n/a       |   yes    |
| instance_type   | Type of the EC2 instance.                                                                      | `string`       | "t2.nano" |    no    |
| vpc             | ID of the VPC in which the EC2 instance lives in.                                              | `string`       | n/a       |   yes    |
| subnet          | ID of the subnet in which the EC2 instance lives in.                                           | `string`       | n/a       |   yes    |
| security_groups | List of security group IDs the EC2 instance will hold.                                         | `list(string)` | []        |    no    |
| policies        | List of IAM policy ARNs for the Lambda's IAM role.                                             | `list(string)` | []        |    no    |
| public_key      | Public SSH key registered to in EC2 instance to tunnel with corresponding private key into it. | `string`       | n/a       |   yes    |
| tags            | A map of tags to add to all resources.                                                         | `map(string)`  | {}        |    no    |

## Outputs

| Name      | Description                                     |
| --------- | ----------------------------------------------- |
| public_ip | Public IP address assigned to the EC2 instance. |

## Example

```hcl
module "instance" {
  source = "github.com/custom-terraform-aws-modules/instance"

  identifier      = "example-instance-dev"
  instance_type   = "t2.nano"
  vpc             = "vpc-23548235"
  subnet          = "subnet-235402395"
  security_groups = ["sg-wgwego2354", "sg-wtewe23423"]
  policies = [
    "arn:aws:iam::aws:policy/aws-service-role/AccessAnalyzerServiceRolePolicy",
    "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
  ]
  public_key = file("~/.ssh/public_key")

  tags = {
    Project     = "example-project"
    Environment = "dev"
  }
}
```

## Contributing

In order for a seamless CI workflow copy the `pre-commit` git hook from `.github/hooks` into your local `.git/hooks`. The hook formats the terraform code automatically before each commit.

```bash
cp ./.github/hooks/pre-commit ./.git/hooks/pre-commit
```
