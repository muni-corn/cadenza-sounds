{
  description = "The Musicaloft sound theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    let allSystems =
      flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          package =
            pkgs.stdenv.mkDerivation {
              pname = "muse-sounds";
              version = "0.0.1";

              src = builtins.path { path = ./.; name = "muse-sounds"; };

              buildInputs = [ ];

              configurePhase = "mkdir -pv $out/share/sounds/";
              dontBuild = true;
              installPhase = ''
                cp -rv musicaloft/ $out/share/sounds/
              '';
            };
        in
        {
          packages = {
            default = package;
            muse-sounds = package;
          };
        }
      );
    in
    {
      inherit (allSystems) packages defaultPackage;
      overlay = final: prev: {
        muse-sounds =
          allSystems.packages.${prev.system}.muse-sounds;
      };
    };
}
