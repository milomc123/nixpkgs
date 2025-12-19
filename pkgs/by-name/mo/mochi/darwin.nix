{
  pname,
  version,
  src,
  passthru,
  meta,
  appName,
  stdenvNoCC,
  _7zz
}:
stdenvNoCC.mkDerivation {
    inherit
        pname
        version
        src
        passthru
        meta
        appName
        ;

    sourceRoot = "${appName}.app";
    nativeBuildInputs = [ _7zz ];

    installPhase = ''
        runHook preInstall

        mkdir -p $out/Applications/Mochi.app
        cp -r . $out/Applications/Mochi.app

        runHook postInstall
    '';

    dontUpdateAutotoolsGnuConfigScripts = true;
    dontConfigure = true;
    dontFixup = true;
}