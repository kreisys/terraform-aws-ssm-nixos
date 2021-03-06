output "name" {
  description = "lowercase-kebab-case-name derived from the display_name that has been supplied. Useful as asg name etc..."
  value       = "${local.name}"
}

output "name_prefix" {
  description = "same as `name` but with a dash at the end"
  value       = "${local.name_prefix}"
}

output "image_id" {
  description = "AMI ID corresponding to the NixOS release supplied."
  value       = "${module.ami.ami_id}"
}

output "iam_instance_profile" {
  description = "Instance profile containing all required permissions."
  value       = "${aws_iam_instance_profile.this.name}"
}

output "tags_map" {
  description = "Tags required for the correct operation of this module; in map format expected by the aws_instance resource."

  value = {
    Name     = "${var.display_name} (${local.pet_title})"
    ssm-path = "${local.ssm_path}"
  }
}

output "tags" {
  description = "Tags required for the correct operation of this module; in array format expected by the aws_autoscaling_group resource."

  value = [
    {
      key                 = "Name"
      value               = "${var.display_name} (${local.pet_title})"
      propagate_at_launch = true
    },
    {
      key                 = "ssm-path"
      value               = "${local.ssm_path}"
      propagate_at_launch = true
    },
  ]
}

output "userdata" {
  description = "The user metadata document that must be passed to the instance in order to bootstrap the SSM agent which is required by this module."
  value       = "${module.userdata_nix.rendered}"
}

output "ssm_path" {
  value = "${local.ssm_path}"
}

output "secretsmanager_path" {
  value = "${local.secretsmanager_path}"
}
