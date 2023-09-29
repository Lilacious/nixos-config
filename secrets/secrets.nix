let
  nas-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzOvjEuo5/HAVphmO20zd7ltt0nSY9L4hsT/2HWjqWw";
  laptop-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc5xk4R+2CfNV1fyyvZEZgzjaRomO0hCJ55E00pSOsv";
  users = [ nas-user laptop-user ];

  nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLN5Wu+GSsdLJfPZXy8q6CGL9VmCHN2hTObNpbXf5YR";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGTfIF2MLDp01ISXoP67lymVV7cnQugW5SP/E5zfgkk";
  systems = [ nas laptop ];
in {
  "nextcloud1.age".publicKeys = users ++ systems;
}
