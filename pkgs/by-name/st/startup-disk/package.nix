{
  lib,
  rustPlatform,
  fetchFromGitLab,
  nix-update-script,
  pkg-config,
  libadwaita,
  gtk4,
  glib,
  polkit,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "startup-disk";
  version = "0.1.6";

  src = fetchFromGitLab {
    owner = "davide125";
    repo = "startup-disk";
    tag = finalAttrs.version;
    hash = "sha256-LbuuhINJ7L0iMwiMTBl0CwkKeTZ6iJbO1YutSc/1ZIg=";
    domain = "gitlab.gnome.org";
  };

  nativeBuildInputs = [
    pkg-config
    glib # glib-compile-resources
  ];

  buildInputs = [
    libadwaita
    gtk4
    glib
    polkit
  ];

  cargoHash = "sha256-IIx0nvCBFT4Bokm/eduZPeZ6lQzGT1aKS/3c1D4PoEU=";

  postInstall = ''
    install -Dm644 res/org.startup_disk.StartupDisk.desktop -t $out/share/applications/
    install -Dm644 res/org.startup_disk.StartupDisk.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm644 res/org.startup_disk.StartupDisk.metainfo.xml -t $out/share/metainfo/
    install -Dm644 res/org.startup_disk.StartupDisk.policy -t $out/share/polkit-1/actions/
  '';

  postFixup = ''
    substituteInPlace $out/share/polkit-1/actions/org.startup_disk.StartupDisk.policy \
      --replace-fail /usr/bin/startup-disk $out/bin/startup-disk
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interface to choose the startup volume on Apple Silicon systems";
    homepage = "https://gitlab.gnome.org/davide125/startup-disk";
    changelog = "https://gitlab.gnome.org/davide125/startup-disk/-/tags/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "startup-disk";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ milomc123 ];
  };
})
