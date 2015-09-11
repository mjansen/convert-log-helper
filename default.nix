{ mkDerivation, base, bytestring, directory, directory-traversal
, filepath, SHA, stdenv
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
}
