{
  description = "NixOS configurations and installation tools";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  inputs.disko = {
    url = "github:nix-community/disko/latest";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, disko, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      installer = pkgs.writeShellApplication {
        name = "install-thinkpad";
        runtimeInputs = [
          disko.packages.${system}.disko
          pkgs.age
          pkgs.coreutils
          pkgs.cryptsetup
          pkgs.gnugrep
          pkgs.gnutar
          pkgs.networkmanager
          pkgs.nix
          pkgs.nixos-install-tools
          pkgs.openssl
          pkgs.systemd
          pkgs.util-linux
        ];
        runtimeEnv.THINKPAD_FLAKE = self.outPath;
        text = builtins.readFile ./scripts/install-thinkpad;
      };
    in
    {
      apps.${system}.install-thinkpad = {
        type = "app";
        program = nixpkgs.lib.getExe installer;
      };

      # The installed path flake includes the locally chosen account module.
      nixosConfigurations =
        nixpkgs.lib.optionalAttrs (builtins.pathExists ./thinkpad-account.nix) {
          thinkpad = nixpkgs.lib.nixosSystem {
            modules = [
              disko.nixosModules.disko
              ./hosts/thinkpad
              ./thinkpad-account.nix
            ];
          };
        };

      diskoConfigurations.thinkpad-install =
        { targetDisk, passphraseFile, ... }:
        import ./hosts/thinkpad/disk-layout.nix {
          device = targetDisk;
          inherit passphraseFile;
        };
    };
}
