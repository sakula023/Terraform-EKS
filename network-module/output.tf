output "w_eip" {
  value       = aws_eip.w_eip.public_ip
}

output "w_vpc" {
  value       = aws_vpc.w_vpc.id
}

output "w_private_subnet" {
  value       = aws_subnet.w_private_subnet.*.id
}

output "w_public_subnet" {
  value       = aws_subnet.w_public_subnet.*.id
}