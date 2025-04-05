output "public_ec2_public_ip" {
  description = "Public IP of public EC2 instance"
  value       = aws_instance.public-ec2.public_ip
}

output "privat_ec2_private_ip" {
  description = "Private IP of private EC2 instance"
  value       = aws_instance.private-ec2.private_ip
}

output "private_ssh_key" {
  description = "Private SSH key"
  value       = tls_private_key.generated.private_key_pem
  sensitive   = true
}

