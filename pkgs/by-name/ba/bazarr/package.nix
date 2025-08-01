{
  stdenv,
  lib,
  fetchzip,
  makeWrapper,
  python3,
  unar,
  ffmpeg,
  nixosTests,
}:

let
  runtimeProgDeps = [
    ffmpeg
    unar
  ];
in
stdenv.mkDerivation rec {
  pname = "bazarr";
  version = "1.5.2";

  src = fetchzip {
    url = "https://github.com/morpheus65535/bazarr/releases/download/v${version}/bazarr.zip";
    hash = "sha256-A6fm5zqlrml7iT3jS9r/XJbCyL+lr/V6WCisxtTKDjA=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    (python3.withPackages (ps: [
      ps.lxml
      ps.numpy
      ps.gevent
      ps.gevent-websocket
      ps.pillow
      ps.setuptools
      ps.psycopg2
    ]))
  ]
  ++ runtimeProgDeps;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{bin,share/${pname}}
    cp -r * "$out/share/${pname}"

    # Add missing shebang and execute perms so that patchShebangs can do its
    # thing.
    sed -i "1i #!/usr/bin/env python3" "$out/share/${pname}/bazarr.py"
    chmod +x "$out/share/${pname}/bazarr.py"

    makeWrapper "$out/share/${pname}/bazarr.py" \
        "$out/bin/bazarr" \
        --suffix PATH : ${lib.makeBinPath runtimeProgDeps}

    runHook postInstall
  '';

  passthru.tests = {
    smoke-test = nixosTests.bazarr;
  };

  meta = with lib; {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    mainProgram = "bazarr";
    platforms = platforms.all;
  };
}
