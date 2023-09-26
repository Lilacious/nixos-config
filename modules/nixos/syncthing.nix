{ variables, ... }:
{
  services = {
    syncthing = {
        enable = true;
        user = "${variables.username}";
        dataDir = "/home/${variables.username}/Sync/";    # Default folder for new synced folders
        configDir = "/home/${variables.username}/Sync/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };
}
