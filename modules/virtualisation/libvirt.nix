# QEMU/KVM virtual machines through libvirt, managed with virt-manager.
{ config, ... }:
{
  flake.modules.nixos.virtualisation = {
    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true; # TPM for Windows 11 guests
    };
    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;

    users.users.${config.constants.user.username}.extraGroups = [
      "libvirtd"
      "kvm"
    ];
  };

  flake.modules.homeManager.virtualisation = {
    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
