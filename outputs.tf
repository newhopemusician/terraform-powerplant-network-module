output "vpcid" {
  value = aws_vpc.Main.id
}

output "subnetid" {
  value = aws_subnet.publicsubnet.id
}

output "sgid" {
  value = aws_security_group.allow_all.id
}
