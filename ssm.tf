module "ssm_nixos_rebuild_switch" {
  source = "./ssm-document"
  name   = "${local.name_CamelCase}-${local.pet_CamelCase}-NixOS-RebuildSwitch"
  type   = "Command"

  content = {
    schemaVersion = "2.2"

    description = ""
    parameters  = {}

    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "nixosRebuildSwitch"

        inputs = {
          runCommand = [
            "cp /root/.nix-defexpr/channels/bootstrap/nixos/user.nix /etc/nixos/user.nix",
            "/run/current-system/sw/bin/nix-channel --update",
            "/root/.nix-defexpr/channels/bootstrap/fetch-ec2-tags",
            "/root/.nix-defexpr/channels/bootstrap/fetch-ssm-params",
            "/run/current-system/sw/bin/nixos-rebuild switch",
          ]
        }
      },
    ]
  }
}

resource "aws_ssm_association" "nixos_rebuild_switch" {
  name                = "${module.ssm_nixos_rebuild_switch.name}"
  schedule_expression = "rate(30 minutes)"

  targets {
    key    = "tag:Id"
    values = ["${local.id}"]
  }
}
