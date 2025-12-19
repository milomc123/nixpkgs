{ 
  pname,
  version,
  src,
  passthru,
  meta,
  appimageTools, 
  xorg
}:
appimageTools.wrapType2 rec {
    inherit
        pname
        version
        src
        passthru
        meta
        ;

    appimageContents = appimageTools.extractType2 { inherit pname version src; };

    extraPkgs = pkgs: [ xorg.libxshmfence ];

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
      install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    '';
};