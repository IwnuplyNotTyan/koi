{
  description = "🍣 Basic .md file reader";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    gomod2nix.url = "github:nix-community/gomod2nix";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
	  version = "0.2.1";
	  commit = self.rev or "dirty";
        in
        {
          default = pkgs.buildGoModule {
            pname = "koi";
	    inherit version;
            src = self;
            modules = ./gomod2nix.toml;

	    ldflags = [
              "-X main.version=${version}"
              "-X main.commit=${commit}"
	      "-s"
	      "-w"
            ];

            vendorHash = "sha256-DpGuofxmkcrdi8hYeWM+hBI2XNqNYCTxcmLx69gnAJU=";

            meta = {
              description = "Basic .md file reader";
              homepage = "https://github.com/IwnuplyNotTyan/koi";
              mainProgram = "koi";
            };
          };
        });

      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.programs.koi;
        in
        {
          options.programs.koi = {
            enable = lib.mkEnableOption "koi markdown reader";

            theme = lib.mkOption {
              type = lib.types.enum [ "dark" "light" "notty" "dracula" "pink" "tokyo-night" ];
              default = "dark";
              description = ''
                Default theme for koi. Sets the KOI_DEFAULT_THEME environment variable.
                Possible values: dark, light, notty, dracula, pink, tokyo-night.
              '';
            };

	    mosaic = lib.mkOption {
	    	type = lib.types.bool;
		default = true;
		description = ''
		  Enable or disable image render
		'';
	    };

	    badges = lib.mkOption {
	    	type = lib.types.bool;
		default = true;
		description = ''
		  Enable or disable shield io badges
		'';
	    };

	    nerd = lib.mkOption {
	    	type = lib.types.bool;
		default = false;
		description = ''
		  Enable or disable nerd fonts icons for GitHub-Style Callout Blocks
		'';
	    };
          };

          config = lib.mkIf cfg.enable {
            home.packages = let
              koiPkg = self.packages.${pkgs.system}.default;
            in [
              (pkgs.writeShellScriptBin "koi" ''
                export KOI_DEFAULT_THEME="${cfg.theme}"
                export KOI_BADGES="${if cfg.badges then "true" else "false"}"
                export KOI_NERD_FONTS="${if cfg.nerd then "true" else "false"}"
                export KOI_MOSAIC="${if cfg.mosaic then "true" else "false"}"
                exec ${koiPkg}/bin/koi "$@"
              '')
            ];
          };
        };

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              go
              gopls
              gotools
              golangci-lint
            ];
          };
        });
    };
}
