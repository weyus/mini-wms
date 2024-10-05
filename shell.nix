let
  pkgs = import
    (builtins.fetchTarball
      {
        # Released on 8/26/2024
        name = "nixpkgs-24.11pre670565.ae815cee91b4";
        url = "https://releases.nixos.org/nixpkgs/nixpkgs-24.11pre670565.ae815cee91b4/nixexprs.tar.xz";
        sha256 = "sha256:1h87v5729fz27a1k90b0iy5c4bzs8b7dg747v777iss8wn4jljpb";
      })
    { };
in
pkgs.mkShell {
  # See https://stackoverflow.com/a/63123144 for details
  # about locale
  LOCALE_ARCHIVE_2_27 = if !pkgs.stdenv.isDarwin then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  buildInputs = [
    pkgs.elixir
    pkgs.nodejs
    pkgs.nodePackages.ts-node
    pkgs.postgresql
  ]
  ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    pkgs.inotify-tools
  ]
  ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
    CoreFoundation
    CoreServices
  ]);
  shellHook =
    ''
      export PATH=$(pwd)/frontend/node_modules/.bin:$PATH
    '';
}
