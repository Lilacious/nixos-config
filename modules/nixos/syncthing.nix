{
  services = {
    syncthing = {
        enable = true;
        user = "kailee";
        dataDir = "/home/kailee/Sync/";    # Default folder for new synced folders
        configDir = "/home/kailee/Sync/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };
}
