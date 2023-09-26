{
  services = {
    syncthing = {
        enable = true;
        user = "yunix";
        dataDir = "/home/yunix/Sync/";    # Default folder for new synced folders
        configDir = "/home/yunix/Sync/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };
}
