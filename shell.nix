{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7101" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, directory
      , directory-traversal, filepath, SHA, stdenv
      }:
      mkDerivation {
        pname = "convert-log-helper";
        version = "0.1.0.0";
        src = ./.;
        buildDepends = [
          base bytestring directory directory-traversal filepath SHA
        ];
        description = "A Framework for Parsing Log Files";
        license = stdenv.lib.licenses.mit;
      };

  drv = pkgs.haskell.packages.${compiler}.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
