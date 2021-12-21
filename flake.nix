{
  description = "The Musicaloft sound theme";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
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
          packages.muse-sounds = package;
          defaultPackage = package;
        }
      );
    in
    {
      inherit (allSystems) packages defaultPackage;
      overlay = final: prev: {
        muse-sounds =
          allSystems.packages.${final.system}.muse-sounds;
      };
    };
}
