let
  hades-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzOvjEuo5/HAVphmO20zd7ltt0nSY9L4hsT/2HWjqWw";
  users = [ hades-user ];

  hades = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLN5Wu+GSsdLJfPZXy8q6CGL9VmCHN2hTObNpbXf5YR";
  systems = [ hades ];
in
{
  "secret2.age".publicKeys = users ++ systems;
}
