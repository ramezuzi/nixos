# modules/printing.nix
{
  flake.nixosModules.printing = { pkgs, ... }: {
    # CUPS print server. Driverless IPP (AirPrint/IPP Everywhere) works for
    # most modern network printers with no driver at all; gutenprint covers
    # older models and hplip covers HP printers.
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters # driverless backend, comes with CUPS filters
        gutenprint # wide legacy printer coverage
        hplip # HP printers (hpcups, no proprietary plugin)
      ];
    };

    # mDNS so network printers advertise themselves and show up in
    # "Add Printer" dialogs without manual URIs.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true; # allows incoming mDNS printer discovery
    };

    # Configure and print from the browser at http://localhost:631
  };
}
