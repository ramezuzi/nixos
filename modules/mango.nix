{inputs,...}:
{
flake.nixosModules.mango = { pkgs,... }: {
imports = [ inputs.mango.nixosModules.mango ];
programs.mango.enable = true;

environment.systemPackages = with pkgs; [
  waybar
  rofi
  mako
  swaybg
  grim
  slurp
  wl-clipboard
  polkit_gnome
  wl-clip-persist
  cliphist
  udiskie
  wireplumber
  awww
  swaynotificationcenter
  gammastep
  cava
];
};
}
