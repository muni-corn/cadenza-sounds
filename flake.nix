{
  description = "The Musicaloft sound theme";

  inputs = {
    # we still need nixpkgs to get runCommand and the basic tools (coreutils, bash) it uses.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      allSystems = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pname = "muse-sounds";
          version = "0.2.2";

          # define the source path clearly
          src = builtins.path {
            path = ./.;
            name = "muse-sounds-src";
          };

          package =
            pkgs.runCommand "${pname}-${version}"
              {
                inherit src;

                # add metadata for Nix tooling (optional but recommended)
                meta = {
                  description = "The Musicaloft sound theme";
                  license = pkgs.lib.licenses.cc-by-sa-40;

                  # this is platform independent
                  platforms = pkgs.lib.platforms.all;
                };
              }
              ''
                # the build script: $out is the destination directory
                echo "installing muse sounds to $out..."
                mkdir -pv $out/share/sounds/

                # copy the specific directory from the source
                cp -rv ${src}/musicaloft $out/share/sounds/
                echo "done!"
              ''; # end of build script
        in
        {
          packages.default = package;
        }
      );
    in
    allSystems
    // {
      # provide the overlay as before
      overlay = final: prev: {
        muse-sounds = self.packages.${prev.system}.default;
      };
    };
}
