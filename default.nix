{
    pkgs ? import ./nix/pkgs.nix {}
}:
[
    pkgs.bash
    pkgs.coreutils
    pkgs.findutils
    pkgs.hivemind
    pkgs.ldc
    pkgs.lighttpd
    pkgs.perl
    pkgs.which
]
