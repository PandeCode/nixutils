{
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:
appimageTools.wrapType2 rec {
  pname = "helium";
  version = "0.11.7.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/0.11.7.1/helium-0.11.7.1-x86_64.AppImage";
    hash = "sha256-qzc135IP5F2btxtOMUGMz+0azJhYL9KI0lcPG2KjcxU=";
  };

  # ERROR not working
  desktopItem = makeDesktopItem {
    desktopName = "Helium";
    name = pname;
    exec = pname;
    icon = pname;
    genericName = "Web Browser";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    actions = {
      new-window = {
        name = "New Window";
        exec = "${pname} --new-window %U";
      };
      new-private-window = {
        name = "New Private Window";
        exec = "${pname} --private-window %U";
      };
      profile-manager-window = {
        name = "Profile Manager";
        exec = "${pname} --ProfileManager";
      };
    };
  };
}
