# Disk encryption support. The LUKS volume itself is declared in the host's
# _hardware.nix (nixos-generate-config writes it during install). To unlock
# it with the TPM instead of a passphrase, after the first boot run:
#
#   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/<luks-partition>
#
# and add `crypttabExtraOpts = [ "tpm2-device=auto" ];` to that LUKS device.
# Secure Boot is a separate, opt-in aspect: see ./secure-boot.nix.
{ config, ... }:
{
  flake.modules.nixos.laptop = {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    users.users.${config.constants.user.username}.extraGroups = [ "tss" ];
  };
}
