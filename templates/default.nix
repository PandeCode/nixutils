{
  default = {
    path = ./nixflake;
    description = "Default flake for modification";
  };

  zig = {
    path = ./zig/default_project;
    description = "Zig project with flake devshell, package, {nixos,home}Module ";
    welcomeText = ''
      # Run
    ''
    + "sed -i '' -e 's/project/default_project/g' $(find . -type f);"
    + ''
      echo use flake > .envrc;
      direnv allow;
      zig init -m;
      zon2nix > deps.nix;
    '';
  };
}
