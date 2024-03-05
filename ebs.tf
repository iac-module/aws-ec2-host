resource "aws_ebs_volume" "this" {
  for_each          = var.create ? var.attach_ebs : {}
  availability_zone = var.availability_zone
  size              = each.value.volume_size
  type              = each.value.volume_type
  throughput        = each.value.throughput
  iops              = each.value.iops
  kms_key_id        = var.kms_key_id
  encrypted         = each.value.encrypted
  tags              = merge(var.tags, { "Name" = "${var.name}-${each.value.name}", "instance_device_name" = each.value.device_name }, each.value.tags)
}

resource "aws_volume_attachment" "this" {
  for_each     = var.create ? var.attach_ebs : {}
  device_name  = each.value.device_name
  volume_id    = aws_ebs_volume.this[each.key].id
  instance_id  = module.ec2_instance.id
  skip_destroy = each.value.delete_on_termination
}
