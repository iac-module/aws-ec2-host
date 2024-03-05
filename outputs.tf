output "id" {
  description = "The ID of the instance"
  value       = module.ec2_instance.id
}

output "arn" {
  description = "The ARN of the instance"
  value       = module.ec2_instance.arn
}

output "capacity_reservation_specification" {
  description = "Capacity reservation specification of the instance"
  value       = module.ec2_instance.capacity_reservation_specification
}

output "instance_state" {
  description = "The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped`"
  value       = module.ec2_instance.instance_state
}

output "outpost_arn" {
  description = "The ARN of the Outpost the instance is assigned to"
  value       = module.ec2_instance.outpost_arn
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance. Useful for getting the administrator password for instances running Microsoft Windows. This attribute is only exported if `get_password_data` is true"
  value       = module.ec2_instance.password_data
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = module.ec2_instance.primary_network_interface_id
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_instance.private_dns
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_instance.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.ec2_instance.public_ip
}

output "private_ip" {
  description = "The private IP address assigned to the instance."
  value       = module.ec2_instance.private_ip
}

output "ipv6_addresses" {
  description = "The IPv6 address assigned to the instance, if applicable."
  value       = module.ec2_instance.ipv6_addresses
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = module.ec2_instance.tags_all
}

output "spot_bid_status" {
  description = "The current bid status of the Spot Instance Request"
  value       = module.ec2_instance.spot_bid_status
}

output "spot_request_state" {
  description = "The current request state of the Spot Instance Request"
  value       = module.ec2_instance.spot_request_state
}

output "spot_instance_id" {
  description = "The Instance ID (if any) that is currently fulfilling the Spot Instance request"
  value       = module.ec2_instance.spot_instance_id
}

################################################################################
# IAM Role / Instance Profile
################################################################################

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.ec2_instance.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.ec2_instance.iam_role_arn
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.ec2_instance.iam_role_unique_id
}

output "iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = module.ec2_instance.iam_instance_profile_arn
}

output "iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = module.ec2_instance.iam_instance_profile_id
}

output "iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = module.ec2_instance.iam_instance_profile_unique
}


output "attach_ebs" {
  description = "Details about operators roles"
  value = try([
    { for volume in aws_ebs_volume.this : volume.id => { ID = volume.id, arn = volume.arn } }
  ], "")
}

################################################################################
# Security Group
################################################################################

output "sg_id" {
  description = "The created or target Security Group ID"
  value       = try(module.sg[0].id, "")
}

output "sg_arn" {
  description = "The created Security Group ARN (null if using existing security group)"
  value       = try(module.sg[0].arn, "")
}

output "sg_name" {
  description = "The created Security Group Name (null if using existing security group)"
  value       = try(module.sg[0].name, "")
}

output "sg_rules_terraform_ids" {
  description = "List of Terraform IDs of created `security_group_rule` resources, primarily provided to enable `depends_on`"
  value       = try(module.sg[0].rules_terraform_ids, "")
}

output "sg_ids_list" {
  description = "The ID's of all the security groups"
  value       = var.security_group_create ? compact(concat([module.sg[0].id], var.vpc_security_group_ids)) : var.vpc_security_group_ids
}
################################################################################
# Route53 Group
################################################################################

output "route53_record_name" {
  description = "The name of the record"
  value       = try(module.route53_record[0].route53_record_name, "")
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = try(module.route53_record[0].route53_record_fqdn, "")
}
