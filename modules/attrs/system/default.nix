# modules/attrs/system/default.nix
#
# Base system composition: boot, hardware services, networking, nix, users,
# secrets and the Home Manager bridge.  Features that are always present on a
# machine belong here; host-specific choices stay in modules/hosts.
{ self, ... }: {
  flake.nixosModules.system = {
    imports = with self.nixosModules; [
      audio
      boot
      fonts
      homeManager
      keyboard
      laptop
      libvirt
      locale
      netbird
      networking
      nh
      nix-ld
      nixSettings
      nixTools
      nur
      podman
      printing
      services
      sops
      ramez
    ];
  };
}
