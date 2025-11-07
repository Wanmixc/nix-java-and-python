
{
  description = "Dev shell sederhana: Java + Python (NumPy)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Python 3.11 + NumPy (ditambahkan lewat withPackages)
        pythonEnv = pkgs.python311.withPackages (ps: with ps; [
          numpy
          pip          # opsional, biar ada pip yang match ke interpreter ini
          setuptools   # opsional
          wheel        # opsional
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Java toolchain
            jdk21
            maven
            gradle

            # Python + NumPy
            pythonEnv
          ];

          shellHook = ''
            echo "☕ Java + 🐍 Python (NumPy) shell"
            echo "Java : $(java -version 2>&1 | head -n1)"
            echo "Maven: $(mvn -version 2>&1 | head -n1)"
            echo "Gradle: $(gradle --version 2>/dev/null | head -n1 || true)"
            echo "Python: $(python --version)"
            echo
          '';
        };
      }
    );
}

