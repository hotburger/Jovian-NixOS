{ 
  stdenv, 
  fetchFromGitHub, 
  substituteAll, 
  jovian-steam-protocol-handler, 
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "jupiter-hw-support-source";
  version = "20240919.2";

  src = fetchFromGitHub {
    owner = "Jovian-Experiments";
    repo = "jupiter-hw-support";
    rev = "9bf0d4f715f9b558e6a9c3926032f8e3463d0e55";
    hash = "sha256-WnWvfp1vk7JM96qH+0UV9gwfv5ucymPhitFUMchOtFM=";
  };

  patches = [
    (substituteAll {
      handler = jovian-steam-protocol-handler;
      systemd = systemd;
      src = ./jovian.patch;
    })
    ./btrfs.patch
    # Fix controller updates with python-hid >= 1.0.6
    ./hid-1.0.6.patch
  ];

  installPhase = ''
    cp -r . $out
  '';
}
