{...}: {
  nixpkgs.config.problems.handlers = {
    fabric.broken = "warn"; # or "ignore" if "warn" still aborts
  };
}
