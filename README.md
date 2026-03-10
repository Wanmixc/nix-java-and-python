# nix-java-and-python

A [Nix flake](https://nixos.wiki/wiki/Flakes) that provides a reproducible development shell with **Java** and **Python (NumPy)** toolchains.

## What's Included

| Category | Tool / Package | Version |
|----------|---------------|---------|
| Java | JDK | 21 |
| Java | Maven | latest from nixpkgs |
| Java | Gradle | latest from nixpkgs |
| Python | Python | 3.11 |
| Python | NumPy | latest from nixpkgs |
| Python | pip | latest from nixpkgs |
| Python | setuptools | latest from nixpkgs |
| Python | wheel | latest from nixpkgs |

## Prerequisites

- [Nix](https://nixos.org/download/) with flakes enabled
- *(Optional)* [direnv](https://direnv.net/) for automatic shell activation

### Enable Flakes

If you haven't enabled flakes yet, add the following to `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

## Usage

### Enter the Dev Shell

```bash
nix develop
```

This drops you into a shell with Java, Maven, Gradle, and Python (with NumPy) all available.

### With direnv (Automatic Activation)

If you have [direnv](https://direnv.net/) installed, the included `.envrc` will automatically activate the dev shell when you `cd` into the project directory:

```bash
cd nix-java-and-python
direnv allow
```

### Verify the Environment

Once inside the shell, you should see output similar to:

```
☕ Java + 🐍 Python (NumPy) shell
Java : openjdk version "21.x.x" ...
Maven: Apache Maven 3.x.x ...
Gradle: Gradle 8.x.x
Python: Python 3.11.x
```

## Project Structure

```
.
├── .envrc        # direnv integration (auto-activates the dev shell)
├── .gitignore    # Ignored files and directories
├── flake.lock    # Pinned dependency versions
├── flake.nix     # Nix flake defining the dev shell
└── README.md     # This file
```

## License

This project does not currently specify a license. Please contact the repository owner for usage terms.
