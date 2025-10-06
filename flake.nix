{
  description = "Minimal development environment for Java & Python";

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

        # Python minimal tanpa packages yang bermasalah
        pythonMinimal = pkgs.python311.withPackages (ps: with ps; [
          pip
          setuptools
          wheel
          virtualenv
          requests
          pytest
        ]);

        # Python dengan data science (tanpa matplotlib yang butuh tkinter)
        pythonDataScience = pkgs.python311.withPackages (ps: with ps; [
          pip
          setuptools
          wheel
          virtualenv
          numpy
          pandas
          scipy
          scikit-learn
          requests
          pytest
        ]);

        # Python untuk web development
        pythonWeb = pkgs.python311.withPackages (ps: with ps; [
          pip
          setuptools
          wheel
          virtualenv
          flask
          requests
          pytest
          black
        ]);

      in
      {
        devShells = {
          # Shell default - Java + Python minimal
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              # Java
              jdk21
              maven
              gradle
              
              # Python minimal
              pythonMinimal
              poetry

              jq
            ];

            shellHook = ''
              echo "🚀 Java & Python Development Environment (Minimal)"
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              echo ""
              echo "📦 Java:"
              echo "  - JDK: $(java -version 2>&1 | head -n 1)"
              echo "  - Maven: $(mvn -version 2>&1 | head -n 1)"
              echo ""
              echo "🐍 Python: $(python --version)"
              echo "  Packages: pip, setuptools, wheel, virtualenv,"
              echo "            requests, pytest"
              echo ""
              echo "💡 Other shells available:"
              echo "  - nix develop .#java       (Java only)"
              echo "  - nix develop .#python     (Python minimal)"
              echo "  - nix develop .#data       (Python + data science)"
              echo "  - nix develop .#web        (Python + web dev)"
              echo ""
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              
              export JAVA_HOME="${pkgs.jdk21}"
              export PATH="$JAVA_HOME/bin:$PATH"
              
              export PYTHONPATH="$PWD:$PYTHONPATH"
              export PIP_PREFIX="$PWD/.local"
              export PATH="$PIP_PREFIX/bin:$PATH"
              
              alias python=python3
              alias pip=pip3
            '';

            JAVA_OPTS = "-Xmx2g";
            MAVEN_OPTS = "-Xmx2g";
          };

          # Java only
          java = pkgs.mkShell {
            buildInputs = with pkgs; [
              jdk21
              jdk17
              maven
              gradle
              git
              visualvm
            ];
            
            shellHook = ''
              echo "☕ Java Development Environment"
              echo ""
              echo "Available:"
              echo "  - JDK 21 (default)"
              echo "  - JDK 17"
              echo "  - Maven"
              echo "  - Gradle"
              echo "  - VisualVM"
              
              export JAVA_HOME="${pkgs.jdk21}"
              export PATH="$JAVA_HOME/bin:$PATH"
            '';
          };

          # Python minimal
          python = pkgs.mkShell {
            buildInputs = [
              pythonMinimal
              pkgs.poetry
              pkgs.git
            ];
            
            shellHook = ''
              echo "🐍 Python Development Environment (Minimal)"
              echo ""
              echo "Python: $(python --version)"
              echo "Packages: pip, setuptools, wheel, virtualenv,"
              echo "          requests, pytest"
              echo ""
              echo "Install additional packages:"
              echo "  pip install ipython matplotlib pandas numpy"
              echo "Or use poetry: poetry add <package>"
              
              export PYTHONPATH="$PWD:$PYTHONPATH"
              export PIP_PREFIX="$PWD/.local"
              export PATH="$PIP_PREFIX/bin:$PATH"
            '';
          };

          # Python + Data Science
          data = pkgs.mkShell {
            buildInputs = [
              pythonDataScience
              pkgs.poetry
              pkgs.git
            ];
            
            shellHook = ''
              echo "🐍 Python + Data Science Environment"
              echo ""
              echo "Python: $(python --version)"
              echo "Packages: numpy, pandas, scipy, scikit-learn"
              echo "          + requests, pytest"
              echo ""
              echo "Note: matplotlib/ipython tidak disertakan."
              echo "Install dengan: pip install matplotlib ipython plotly"
              
              export PYTHONPATH="$PWD:$PYTHONPATH"
              export PIP_PREFIX="$PWD/.local"
              export PATH="$PIP_PREFIX/bin:$PATH"
            '';
          };

          # Python + Web Development
          web = pkgs.mkShell {
            buildInputs = [
              pythonWeb
              pkgs.poetry
              pkgs.git
              pkgs.postgresql
              pkgs.redis
            ];
            
            shellHook = ''
              echo "🐍 Python Web Development Environment"
              echo ""
              echo "Python: $(python --version)"
              echo "Packages: flask, requests, pytest, black"
              echo ""
              echo "Available services:"
              echo "  - PostgreSQL client"
              echo "  - Redis client"
              echo ""
              echo "Install additional packages:"
              echo "  pip install django fastapi uvicorn ipython"
              
              export PYTHONPATH="$PWD:$PYTHONPATH"
              export PIP_PREFIX="$PWD/.local"
              export PATH="$PIP_PREFIX/bin:$PATH"
            '';
          };
        };
      }
    );
}
