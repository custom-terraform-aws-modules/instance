output "public_ip" {
  description = "Public IP address assigned to the EC2 instance."
  value       = aws_instance.main.public_ip
}
