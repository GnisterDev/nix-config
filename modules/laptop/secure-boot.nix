# Secure Boot with lanzaboote. Opt-in (import `secure-boot` in a host) because
# it needs keys before the first build:
#
#   1. sudo sbctl create-keys              (writes /var/lib/sbctl)
#   2. add `secure-boot` to the host's imports, `nh os switch`
#   3. sudo sbctl verify                   (everything but the kernel signed)
#   4. firmware: clear keys / enter Setup Mode, boot back in, then
#      sudo sbctl enroll-keys --microsoft  (keep Microsoft keys for dual boot)
#   5. reboot, enable Secure Boot, check `bootctl status`
#
# Replaces GRUB with systemd-boot + lanzaboote; Windows still shows up in
# the boot menu when it lives on the same EFI partition.
{ inputs, ... }:
{
  flake.modules.nixos.secure-boot =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot.loader.grub.enable = lib.mkForce false;
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      environment.systemPackages = [ pkgs.sbctl ];
    };
}
