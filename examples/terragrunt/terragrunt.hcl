include {
  path = find_in_parent_folders()
}
iam_role = local.account_vars.iam_role

terraform {
  source = "git::https://github.com/iac-module/aws-ec2-host.git//?ref=v1.0.0"
}

dependency "vpc" {
  config_path = find_in_parent_folders("core/vpc/${local.account_vars.locals.env_name}")
}

dependency "ssh-key" {
  config_path = find_in_parent_folders("core/ec2_keys/ec2-workload")
}

dependency "pull_role" {
  config_path = find_in_parent_folders("core/iam/policies/ecr_pull_all_registry")
}

locals {
  common_tags  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region       = local.region_vars.locals.aws_region
  name         = basename(get_terragrunt_dir())
}

inputs = {

  security_group_name = ["ec2-${local.name}"]
  rule_matrix = [
    {
      key         = "ssh"
      cidr_blocks = ["0.0.0.0/0"]
      rules = [
        {
          key         = "ssh"
          type        = "ingress"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          description = "Allow SSH from anywhere"
        }
      ]
    },
    {
      key         = "backend"
      cidr_blocks = dependency.vpc.outputs.public_subnets_cidr_blocks
      rules = [
        {
          key         = "Backend"
          type        = "ingress"
          from_port   = 3000
          to_port     = 3000
          protocol    = "tcp"
          description = "backend"
        }
      ]
    },
    {
      key         = "frontend"
      cidr_blocks = dependency.vpc.outputs.public_subnets_cidr_blocks
      rules = [
        {
          key         = "frontend"
          type        = "ingress"
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          description = "frontend"
        }
      ]
    },
    {
      key         = "out-443"
      cidr_blocks = ["0.0.0.0/0"]
      rules = [
        {
          key         = "443-out"
          type        = "egress"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "Allow outgoing TCP/443 traffic to anywhere"
        }
      ]
    }
  ]
  #ec2 instance
  name                        = local.name
  ami                         = "ami-0156b61643fdfee5c" #Amazon Linux 2023 AMI 2023.3.2
  vpc_id                      = dependency.vpc.outputs.vpc_id
  create_iam_instance_profile = true
  metadata_options = {
    "http_endpoint"               = "enabled"
    "http_put_response_hop_limit" = 2
    "http_tokens"                 = "required"
  }
  subnet_id                   = dependency.vpc.outputs.public_subnets[0]
  key_name                    = dependency.ssh-key.outputs.key_pair_name
  associate_public_ip_address = true
  instance_type               = "t3a.small"
  iam_role_policies = {
    ecr_pull = dependency.pull_role.outputs.arn
  }
  iam_role_name     = local.name
  kms_key_id        = "arn:aws:kms:ca-central-1:YYYYYYYY:key/xxxxxxxx"
  availability_zone = "${local.region_vars.locals.aws_region}a"
  root_block_device = {
    volume_size = 20
  }
  # overwrite default size for additional volumes
  attach_ebs = {
    1 = {
      name        = "data"
      device_name = "/dev/sde"
      volume_size = 20
    }
  }
  route_53_record = {
    enabled      = true
    zone_name    = local.account_vars.locals.main_domain
    private_zone = false
    private_ip   = false
    name         = local.name
  }
  tags = local.common_tags.locals.common_tags
}
