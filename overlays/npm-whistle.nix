{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "whistle";
  version = "2.9.53";

  src = fetchFromGitHub {
    owner = "avwo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MrAiBekciYL0Dc2Nyh0dzpDePcDqMV9aw981xJ4Uya0=";
  };

  npmDepsHash = "sha256-+4VGRQXCWpg4X2U/3yZ+mVNAzvb9ktdh8NyiTnwSQXw=";
  dontNpmBuild = true;

  meta = with lib; {
    description = "HTTP, HTTP2, HTTPS, Websocket debugging proxy";
    homepage = "https://github.com/avwo/whistle";
    license = licenses.mit;
    maintainers = with maintainers; [ "beet <i@beetcb.com>" ];
  };
}

