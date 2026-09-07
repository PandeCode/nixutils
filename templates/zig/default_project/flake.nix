{
  description = "default_project";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    accept-flake-config = true;
    show-trace = true;
    auto-optimise-store = true;

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://charon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "charon.cachix.org-1:epdetEs1ll8oi8DT8OG2jEA4whj3FDbqgPFvapEPbY8="
    ];
  };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    # zig-overlay = {
    #   url = "github:mitchellh/zig-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #
    # zls = {
    #   url = "github:zigtools/zls";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {self, ...} @ inputs: let
    self' =
      self
      // {
        # overlays = (import ./nix/overlays.nix) inputs;
      };

    iterSys = final:
      (
        inputs.nixpkgs.lib.genAttrs
        inputs.nixpkgs.lib.systems.flakeExposed # this has everything
        # [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      ) ((
          self: system: let
            pkgs = self.inputs.nixpkgs.legacyPackages.${system};
          in
            final {inherit pkgs;}
        )
        self');

    name = "default_project";
    meta' = pkgs:
      with pkgs; {
        description = "default_project";
        longDescription = ''
          default_project in Zig
        '';
        homepage = "https://codeberg.org/d3bug64/default_project";
        license = lib.licenses.gpl3;
        # maintainers = with lib.maintainers; [];
        platforms = lib.platforms.linux;
      };

    zig' = pkgs:
      pkgs.zig_0_16;
    # self.inputs.zig-overlay.packages.${pkgs.stdenv.hostPlatform.system}."0.16.0".overrideAttrs {};
    # self.inputs.zig-overlay.packages.${pkgs.stdenv.hostPlatform.system}."master-2026-08-04";

    zls' = pkgs:
      pkgs.zls_0_16;
    #  self.inputs.zls.packages.${pkgs.stdenv.hostPlatform.system}.default;

    buildInputs' = pkgs:
      with pkgs; [
        # (enableDebugging (glibc.overrideAttrs (o: {
        #   preConfigure = o.preConfigure + ''export CFLAGS="-Wno-error=maybe-uninitialized $CFLAGS"'';
        # })))
      ];

    nativeBuildInputs' = pkgs:
      with pkgs; [
        (zig' pkgs)
        pkg-config
      ];

    devInputs' = pkgs:
      with pkgs; [
        (zls' pkgs)

        zon2nix

        ccls
        bear
        gdb
      ];

    env = pkgs:
      with pkgs; {
        LD_LIBRARY_PATH = lib.makeLibraryPath [];
        LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
      };

    treefmtEval = iterSys ({pkgs, ...}:
      inputs.treefmt-nix.lib.evalModule pkgs (_: {
        projectRootFile = "flake.nix";
        programs.zig.enable = true;
      }));
  in {
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    self.submodules = true;

    formatter = iterSys ({pkgs, ...}: treefmtEval.${pkgs.system}.config.build.wrapper);
    checks = iterSys ({pkgs, ...}: {
      formatting = treefmtEval.${pkgs.system}.config.build.check self;
    });

    devShells = iterSys (
      {pkgs, ...}: {
        default = pkgs.mkShell ({
            packages =
              (buildInputs' pkgs)
              ++ (nativeBuildInputs' pkgs)
              ++ (devInputs' pkgs);
          }
          // (env pkgs));
      }
    );

    packages = iterSys (
      {pkgs, ...}: let
        meta = meta' pkgs;
      in {
        default = pkgs.stdenv.mkDerivation (finalAttrs: {
          inherit name meta;
          src = ./.;

          buildInputs = buildInputs' pkgs;
          nativeBuildInputs = nativeBuildInputs' pkgs;

          zigBuildFlags = ["--system" "${finalAttrs.deps}"];
          strictDeps = true;
          deps = pkgs.callPackage (import ./deps.nix) {};
        });
      }
    );

    nixosModules = iterSys ({pkgs, ...}: {
      environment.systemPackages = [
        inputs.self.packages.${pkgs.system}.default
      ];
    });
    homeConfigurations = iterSys ({pkgs, ...}: {
      home.packages = [
        inputs.self.packages.${pkgs.system}.default
      ];
    });
  };
}
