# nixutils

Personal flake utils: a small lib, flake templates, and nix language
experiments.

## Use

```nix
{
  inputs = {
    nixutils = {
      type = "github";
      owner = "PandeCode";
      repo = "nixutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixutils, ... }:
    {
      packages = nixutils.lib.forAllPkgs nixpkgs (pkgs: {
        default = pkgs.hello;
      });
    };
}
```

## Lib

| function                             | does                                                   |
| ------------------------------------ | ------------------------------------------------------ |
| `defaultSystems`                     | x86_64-linux, aarch64-linux, aarch64-darwin            |
| `forSystems systems fn`              | `{ <system> = fn system; }` for the given systems      |
| `forAllSystems fn`                   | `forSystems defaultSystems`                            |
| `forAllPkgs nixpkgs fn`              | `fn pkgs` for each default system, from that nixpkgs   |
| `wrapProgram pkgs package { ... }`   | wrap the main program with `envs.set`, `envs.prefix`, `args` |
| `forceAttrs attrs`                   | `mkForce` every value                                  |
| `toZON value`                        | nix to ZON (zig object notation); `zon.enum "x"` is `.x` |
| `treefmtModule`                      | treefmt config shared by my repos                      |

The lib is built with `makeExtensible`, so it can be extended:

```nix
nixutils.lib.extend (final: prev: { hello = "world"; })
```

## Templates

```bash
nix flake init -t github:PandeCode/nixutils
nix flake init -t github:PandeCode/nixutils#zig
```

## Develop

```bash
nix fmt
nix flake check
```

`experiments/` holds nix language experiments; the flake does not export
them.
