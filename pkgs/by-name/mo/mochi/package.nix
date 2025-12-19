{
  lib,
  callPackage,
  stdenvNoCC,
  fetchurl,
  fetchzip,
}:
let
  inherit (stdenvNoCC.hostPlatform) isDarwin system;

  sources = import ./sources.nix { inherit fetchurl fetchzip; };
in
callPackage (if isDarwin then ./darwin.nix else ./linux.nix) {
  pname = "mochi";
  appName = "Mochi";
  
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Simple markdown-powered SRS app";
    homepage = "https://mochi.cards/";
    changelog = "https://mochi.cards/changelog";
    mainProgram = "mochi";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ poopsicles milomc123 ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
  };
}