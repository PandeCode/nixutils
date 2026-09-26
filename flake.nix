{
  description = "personal flake utils and nix experiments";

  outputs = inputs: import ./flake inputs;

  inputs = {
    # lib comes from here, and the formatter, checks and dev shell of this
    # repo need packages. consumers should make it follow their nixpkgs
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
  };
}
