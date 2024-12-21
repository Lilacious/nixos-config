{
  self,
  inputs,
  config,
  ...
}:
let
  username = "yunix";
in
{
  imports = [
    ./nixos.nix
    ../modules

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
        };
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${username} = {
          home = {
            username = "${username}";
            homeDirectory = "${config.users.users.${username}.home}";
            stateVersion = "23.05";
          };
          imports = [
            ../users/${username}/git.nix
            self.nixosModules.home-core
            self.nixosModules.home-programs
          ];
        };
      };
    }

    ../users/${username}
  ];

  services.openssh = {
    enable = true;
    settings = {
      # require public key authentication for better security
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };
}
