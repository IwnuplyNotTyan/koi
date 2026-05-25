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
            version = "0.1.0";
            src = self;
	    modules = ./gomod2nix.toml;

            vendorHash = "sha256-eNBgdxOd0vpcbam0iYXDmBZKFsFNqmJbXhP3qX4yPWk=";

            meta = {
              description = "Basic .md file reader";
              homepage = "https://github.com/IwnuplyNotTyan/koi";
              mainProgram = "koi";
            };
          };
        });

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
