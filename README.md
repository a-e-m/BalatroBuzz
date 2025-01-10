The old Lovense version is on this branch: https://github.com/a-e-m/BalatroBuzz/tree/lovense

This main branch now has the buttplug.io integration rather than Lovense

# BalatroBuzz
Buttplug.io integration mod for Balatro

# Installation

1. First, you'll need to download and install Lovely: https://github.com/ethangreen-dev/lovely-injector (These instructions may be helpful as well: https://github.com/Steamodded/smods/wiki)
2. Next, you'll need to download the project files to a folder named "BalatroBuzz" within your Balatro mods folder (Windows: `%AppData%/Balatro`; Mac: `~/Library/Application Support/Balatro`; Linux (WINE/Proton): `~/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro` or `~/.steam/debian-installation/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro`) For example, `lovely.toml` on my computer is at `C:\Users\Amy\AppData\Roaming\Balatro\Mods\BalatroBuzz\lovely.toml`
3. Then, you'll need to install and run Intiface Central: https://intiface.com/central/
4. Finally, open Balatro and verify that your device vibrates whenever there are flames appearing by your current score.

Alternately, take a look at these instructions on the buttplug.io forums: https://discuss.buttplug.io/t/balatrobuzz-balatro-buttplug-io-mod-installation-tutorial/534 

# Troubleshooting
* This project currently assumes you're running Balatro and Intiface Central on the same machine, and if you're not you may need to update `intiface_host` in `lovely.toml`
* By default this uses the first device returned from Intiface Central
* If you see an error like `Websocket server accept error: Protocol(HttparseError(Version))` in Intiface Central, this is NOT an issue with this particular mod. The fix is updating to the latest version of https://github.com/Steamodded/smods
