pkgs: let
  inherit (pkgs) callPackage;
in {
  sddm-custom-theme = callPackage ../derivations/sddm-custom-theme.nix {
    video = builtins.fetchurl {
      url = "https://github.com/PandeCode/dotnix/raw/refs/heads/media/sddm/factorio.mp4";
      sha256 = "0hrj4x8q068ih398gcjsr7ai6qb7mlj8mbdgcdqjcm98pjbchvaj";
    };
    placeholder = builtins.fetchurl {
      url = "https://github.com/PandeCode/dotnix/raw/refs/heads/media/sddm/factorio.png";
      sha256 = "0g6ph1zqfrqqclswd5xnczdj0rkw26sn168f3260kcd43cx7100b";
    };
  };
  # plymouth-theme-custom = callPackage ../derivations/plymouth-theme-custom.nix {};
  plymouth-theme-cat = callPackage ../derivations/plymouth-theme-cat.nix {};
  notify-send-py = callPackage ../derivations/notify-send-py.nix {};
  grub-custom-theme = callPackage ../derivations/grub-custom-theme.nix {};
  xdg-xmenu = callPackage ../derivations/xdg-xmenu.nix {};
  surge-downloader = callPackage ../derivations/surge-downloader.nix {};
  helium = callPackage ../derivations/helium.nix {};
}
