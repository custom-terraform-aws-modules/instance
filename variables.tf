variable "identifier" {
  description = "Unique identifier to differentiate global resources."
  type        = string
  validation {
    condition     = length(var.identifier) > 2
    error_message = "Identifier must be at least 3 characters"
  }
}

variable "instance_type" {
  description = "Type of the EC2 instance."
  type        = string
  default     = "t2.nano"
}

variable "vpc" {
  description = "ID of the VPC in which the EC2 instance lives in."
  type        = string
  validation {
    condition     = startswith(var.vpc, "vpc-")
    error_message = "Must be valid VPC ID"
  }
}

variable "subnet" {
  description = "ID of the subnet in which the EC2 instance lives in. (subnet must be located in VPC)"
  type        = string
  validation {
    condition     = startswith(var.subnet, "subnet-")
    error_message = "Must be valid subnet ID"
  }
}

variable "security_groups" {
  description = "List of security group IDs the EC2 instance will hold."
  type        = list(string)
  default     = []
  validation {
    condition     = !contains([for v in var.security_groups : startswith(v, "sg-")], false)
    error_message = "Elements must be valid security group IDs"
  }
}

variable "policies" {
  description = "List of IAM policy ARNs for the EC2's IAM role."
  type        = list(string)
  default     = []
}

variable "public_key" {
  description = "Public SSH key registered to in EC2 instance to tunnel with corresponding private key into it."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
