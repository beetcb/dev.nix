let
  pkgs = import <nixos-unstable> { };
in
pkgs.mkShell {
  buildInputs = [
    pkgs.cargo
    pkgs.rustc
    pkgs.rustfmt
    # Necessary for the openssl-sys crate 
    pkgs.openssl
    pkgs.pkg-config
  ];

  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  TMPDIR = "/tmp";
}
