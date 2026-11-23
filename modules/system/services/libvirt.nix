# modules/libvirt.nix
{
  flake.nixosModules.libvirt = { pkgs, ... }: {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    programs.virt-manager.enable = true;
    users.users.ramez.extraGroups = [ "libvirtd" ];
    environment.systemPackages = [ pkgs.cloud-utils ];
  };
}
