# spotify-shortcuts

control spotify volume with page up and page down, because who really uses those keys anyway?

this project uses an autohotkey script to capture keyboard shortcuts. this script then runs a python script that securely signs into your spotify account using api credentials stored locally in a `spotify_config.json` file, allowing it to control the playback volume.

## how to install

1.  **autohotkey:**
    * download and install autohotkey v1 from the [official autohotkey website](https://www.autohotkey.com/). (ensure you are getting version 1.x for compatibility with the provided `.ahk` script).

2.  **python:**
    * download and install python from the [official python website](https://www.python.org/).
    * during installation, it's highly recommended to check the box that says "add python to path".

3.  **spotipy library:**
    * open your command prompt (cmd) or powershell.
    * install the spotipy python library by running: `pip install spotipy`

4.  **project files:**
    * download the `.zip` file from the project's releases page.
    * extract its contents to your desired installation location (e.g., `documents\autohotkey scripts\spotify volume`). the zip should include:
        * `spotify_volume.ahk` (the autohotkey script)
        * `spotify_volume_control.py` (the python script)
        * `spotify_config.json` (the configuration file for your spotify api credentials)

5.  **spotify developer setup & configuration file:**
    * go to the [spotify developer dashboard](https://developer.spotify.com/dashboard/) and log in or create an account.
    * create a new app (you can name it something like "volume controller").
    * once created, you'll see your `client id` and you can view your `client secret`.
    * open the `spotify_config.json` file (from the extracted zip) in a text editor.
    * copy your `client id` and `client secret` into the respective fields in `spotify_config.json`.    
        ```json
        {
          "spotipy_client_id": "your_client_id_here",
          "spotipy_client_secret": "your_client_secret_here",
          "spotipy_redirect_uri": "http://127.0.0.1:8888/callback"
        }
        ```
    * in your app settings on the spotify developer dashboard, add a redirect uri and set it to **exactly**: `http://127.0.0.1:8888/callback`
    * save the settings on the spotify developer dashboard.
    * **important security note:** never share your `spotify_config.json` file or commit it to a public git repository. if using git, add `spotify_config.json` to your `.gitignore` file.

6.  **configure python path in autohotkey script (if needed):**
    * open `spotify_volume.ahk` in a text editor.
    * find the line: `pythonexepath := "python.exe"`
    * if you didn't add python to your system path during installation, or if you have multiple python versions and need to specify which one to use, change `"python.exe"` to the full path of your python executable (e.g., `c:\python39\python.exe`).

7.  **first run & authorization:**
    * double-click the `spotify_volume.ahk` file to run the script.
    * the first time you trigger a volume change (by pressing page up or page down), a browser window should open.
    * log in to your spotify account in the browser and grant the application permission.
    * after successful authorization, spotify will redirect to a `127.0.0.1` address, and a `.cache` file will be created in your script directory to store the authorization token. you don't need to do anything with this cache file.

## running it

once configured, simply ensure `spotify_volume.ahk` is running in the background. you can add a shortcut to it in your windows startup folder if you want it to run automatically when you log in.

## settings (customization)

you can customize the script behavior by editing the relevant files:

* **hotkeys & actions (`spotify_volume.ahk`):**
    * change `pgup::` and `pgdn::` to different keys if desired.
    * modify the arguments passed to the python script (e.g., `"skip_next"` instead of `"up"`) if you adapt the python script to handle other actions.

* **tooltip behavior (`spotify_volume.ahk`):**
    * to remove the tooltip (the small text that appears near your cursor when a hotkey is pressed), you can comment out or delete the lines starting with `tooltip,` and `settimer, removetooltip,`.

* **volume step (`spotify_volume_control.py`):**
    * open the `spotify_volume_control.py` script.
    * find the line `volume_step = 5`.
    * change the value `5` to your desired volume increment/decrement percentage (e.g., `10` for 10%).
