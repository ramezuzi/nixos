# modules/rex.nix
{ inputs, ... }: {
  # ── Rex (Superlogical) — server/client terminal multiplexer ────────────
  # Personal server setup: the server runs as ramez via a systemd user
  # service, so sessions and programs run as your own user. The macOS Rex
  # app (or the rex CLI from any machine over `ssh://ramez@zbook`) can
  # connect to it.
  flake.homeModules.rex = {
    imports = [ inputs.rex.homeManagerModules.default ];

    programs.rex.enable = true;

    # The ssh guard needs home-manager to own ~/.ssh/config
    # (programs.ssh.enable), which this config does not do. If you ever ssh
    # out of a Rex terminal, run `rex terminfo setup` once instead — it adds
    # the same guard to your own ~/.ssh/config.
    programs.rex.sshGuard = false;

    # Long-running personal server (systemd user service `rex`). Restart it
    # manually after updates — home-manager keeps the running server:
    #   systemctl --user restart rex
    # Remote access can be enabled later with services.rex.tailscale.enable
    # (Rex runs its own embedded Tailscale node; no host tailscale needed).
    services.rex.enable = true;
  };

  # The personal server must survive logging out — important now that the
  # machine has several wayland sessions to switch between (a logout would
  # otherwise end rex and every session in it). Note: lingering also starts
  # the other enabled user services (mpd, ollama, …) at boot.
  flake.nixosModules.rex = {
    users.users.ramez.linger = true;
  };
}
