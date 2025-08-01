{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  appstream-glib,
  glib,
  wrapGAppsHook3,
  pythonPackages,
  gtk3,
  adwaita-icon-theme,
  gobject-introspection,
  libnotify,
  libsecret,
  gst_all_1,
}:

pythonPackages.buildPythonApplication rec {
  pname = "pithos";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = version;
    hash = "sha256-3j6IoMi30BQ8WHK4BxbsW+/3XZx7rBFd47EBENa2GiQ=";
  };

  format = "other";

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    appstream-glib
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libnotify
    libsecret
    glib
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-bad
  ]);

  propagatedBuildInputs = [
    adwaita-icon-theme
  ]
  ++ (with pythonPackages; [
    pygobject3
    pylast
  ]);

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Pandora Internet Radio player for GNOME";
    mainProgram = "pithos";
    homepage = "https://pithos.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ obadz ];
  };
}
