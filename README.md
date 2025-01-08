# BalatroBuzz
Buttplug integration mod for Balatro

# Installation

1. First, you'll need to download and install Lovely: https://github.com/ethangreen-dev/lovely-injector (These instructions may be helpful as well: https://github.com/Steamodded/smods/wiki)
2. Next, you'll need to download `lovely.toml` and `vibrator.lua` and place them in a folder named "BalatroBuzz" within your Balatro mods folder (Windows: `%AppData%/Balatro`; Mac: `~/Library/Application Support/Balatro`; Linux (WINE/Proton): `~/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro.`)
3. You'll need to update `lovely.toml` based on the toy you're using. If you're using a Lovense device, you can just update the `vibrate_url` variable based on info in the Lovense app under Discover -> Game Mode -> "Enable LAN", like `http://LOCAL_IP_HERE:PORT_HERE/command`. For example, my `vibrate_url` is `http://10.0.0.49:20010/command` (but yours will probably have a different IP address).
4. Finally, open Balatro and verify that your device vibrates whenever there are flames appearing by your current score.
