
output "vpcid" {
  description = "ID of project VPC"
  value       = aws_vpc.VPC1.id
}

output "Igw" {
  description = "ID of subnets"
  value       = aws_internet_gateway.gw.id
  }


output "pub-sub-ids" {
  value = [for subnet in aws_subnet.pubsubnets : subnet.id]
}

output "pir-sub-ids" {
  value = [for subnet in aws_subnet.pirsubnets : subnet.id]
}

