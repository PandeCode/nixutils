# tldr

this repo contains personal:
- nix functions i've written and colleted (kinda like a personal flake utils)
- flake templates
- devShells

# info

i probably need to write this down

nixutils - kinda like a personal flake-utils/flake-parts - everything depends on this - does not need nixpkgs

> all the below need to have the same version of nixpkgs

nixbuilds - for cache purposes
    - assortment of derivations - ci # TODO, structure like nixpkgs (pkg-name/package.nix), remove old derivations
    - flake inputs i've collected

having multiple caches slows down nix builds, so i only need 3, nix, nix-community, charon(personal)

i also have trust issues so i dont want to use other unoffical caches, i would have to really trust the owners or not be lazy and check every time i do a flake update


- don't want to create a cyclic dependency problem, technically(i think, probably, maybe) nix lazyeval will resolve this but i dont like the verbosity

these 2 should be synced so i dont install 2 versions of haskell-language-server
- hermes - neovim config - ci
- libysa - emacs config - ci # NOTE just experimenting
- ... not sure of what else i need to package standalone that would warrant its own flake

dotnix - public facing nixconfig so i can share with others
    - inputs:
        - nixbuilds - for derivations
        - heremes#full
        - libys#full

secrets - local backedup flake input into dotnix so i can have secretes and more personal parts of my osconfig still declarative but hidded from the internet


# other stuff

if i stop being lazy, i should the make templates

```bash
nix flake init --template templates#zig
```

devShells
