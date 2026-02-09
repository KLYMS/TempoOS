{
  description = "OS Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      # crossPkgs = pkgs.pkgsCross.i686-embedded;
      cc32 = pkgs.pkgsi686Linux.gcc;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          # The Cross Compiler Toolchain (GCC, Binutils, etc.)
          # crossPkgs.buildPackages.gcc
          # crossPkgs.buildPackages.gdb

          cc32           # The 32-bit Compiler (gcc)         
          # Standard OSDev tools
          pkgs.nasm      # Assembly compiler
          pkgs.xorriso   # For making ISOs (grub-mkrescue uses this)
          pkgs.qemu      # Emulator to run your OS
          pkgs.grub2     # If you need grub tools
          pkgs.mtools    # Utilities to access MS-DOS disks
        ];

        shellHook = ''
          export TARGET=i686-elf
          export CC=gcc
          export LD=ld
          export AS=nasm

          echo "🚀 OS Development Environment Loaded"
          echo "Compiler: $(which gcc)"
        '';
      };
    };
}
