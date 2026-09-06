{
  flake.nixosMoudles.fonts = { ... }: {
    fonts.fontconfig = {
  enable = true;          # usually already true
  hinting = {
    enable = true;
    style = "hintslight";   # or "hintfull", "hintnone"
  };
  antialias = true;
  subpixel = {
    enable = true;
    rgba = "rgb";
    lcdfilter = "lcddefault";
  };
  dpi = 96;               # optional, standard DPI
};
  };
}
