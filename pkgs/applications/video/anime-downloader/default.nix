{ lib, python3, aria2, mpv, nodejs, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "anime-downloader";
  version = "5.0.14";

  src = fetchFromGitHub {
    owner = "anime-dl";
    repo = "anime-downloader";
    rev = version;
    sha256 = "sha256-Uk2mtsSrb8fCD9JCFzvLBzMEB7ViVDrKPSOKy9ALJ6o=";
  };

  buildInputs = with python3.pkgs; [
    jsbeautifier
    pycryptodome
    requests
  ];

  propagatedBuildInputs = [
    aria2
    mpv
    nodejs
  ] ++ (with python3.pkgs; [
    beautifulsoup4
    cfscrape
    click
    coloredlogs
    fuzzywuzzy
    pySmartDL
    pyqt5
    requests-cache
    selenium
    tabulate
  ]);

  doCheck = false;
  # FIXME: checks must be disabled because they are lacking the qt env.
  #        They fail like this, even if built and wrapped with all Qt and runtime dependencies.
  #        Ref.: https://github.com/NixOS/nixpkgs/blob/634141959076a8ab69ca2cca0f266852256d79ee/pkgs/applications/misc/openlp/lib.nix#L20-L23

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/anime-dl/anime-downloader";
    description = "A simple but powerful anime downloader and streamer";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ WeebSorceress ];
  };
}
