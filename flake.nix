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
        in
        {
          default = pkgs.buildGoModule {
            pname = "koi";
            version = "0.2.0";
            src = self;
            modules = ./gomod2nix.toml;

            vendorHash = "sha256-eq8wtckFoXpwubNpD/RtkylC0Uyg8j40MeOlJELFOs8=";

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
              type = lib.types.enum [ "dark" "light" "notty" "dracula" ];
              default = "dark";
              description = ''
                Default theme for koi. Sets the KOI_DEFAULT_THEME environment variable.
                Possible values: dark, light, notty, dracula.
              '';
            };
          };

          config = lib.mkIf cfg.enable {
            home.packages = [ self.packages.${pkgs.system}.default ];

            home.sessionVariables = {
              KOI_DEFAULT_THEME = cfg.theme;
            };
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
