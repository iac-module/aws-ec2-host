module "sg" {
  source = "git::https://github.com/cloudposse/terraform-aws-security-group.git?ref=679216f1bc0b1c39a9bea03456e3eae8261f8dbb" #2.2.0
  count  = var.security_group_create && var.create ? 1 : 0

  security_group_name           = var.security_group_name
  security_group_description    = var.security_group_description
  create_before_destroy         = var.create_before_destroy
  preserve_security_group_id    = var.preserve_security_group_id
  allow_all_egress              = var.allow_all_egress
  rules                         = var.rules
  rules_map                     = var.rules_map
  rule_matrix                   = var.rule_matrix
  security_group_create_timeout = var.security_group_create_timeout
  security_group_delete_timeout = var.security_group_delete_timeout
  revoke_rules_on_delete        = var.revoke_rules_on_delete
  vpc_id                        = var.vpc_id
  inline_rules_enabled          = var.inline_rules_enabled
}
