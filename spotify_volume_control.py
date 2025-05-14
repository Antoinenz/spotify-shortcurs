import spotipy
from spotipy.oauth2 import SpotifyOAuth
import sys
import json
import os

SCOPE = "user-modify-playback-state user-read-playback-state"
VOLUME_STEP = 5
CONFIG_FILE_NAME = "spotify_config.json"

script_dir = os.path.dirname(os.path.abspath(__file__))
config_path = os.path.join(script_dir, CONFIG_FILE_NAME)

try:
    with open(config_path, 'r') as f:
        config_data = json.load(f)
    
    CLIENT_ID = config_data.get('SPOTIPY_CLIENT_ID')
    CLIENT_SECRET = config_data.get('SPOTIPY_CLIENT_SECRET')
    REDIRECT_URI = config_data.get('SPOTIPY_REDIRECT_URI')

    if not all([CLIENT_ID, CLIENT_SECRET, REDIRECT_URI]):
        print(f"Error: Missing one or more credentials in '{CONFIG_FILE_NAME}'.")
        print("Please ensure SPOTIPY_CLIENT_ID, SPOTIPY_CLIENT_SECRET, and SPOTIPY_REDIRECT_URI are defined.")
        sys.exit(1)

except FileNotFoundError:
    print(f"Error: Configuration file '{CONFIG_FILE_NAME}' not found in '{script_dir}'.")
    print(f"Please create '{CONFIG_FILE_NAME}' and add your Spotify API credentials.")
    sys.exit(1)
except json.JSONDecodeError:
    print(f"Error: Could not decode JSON from '{CONFIG_FILE_NAME}'. Please check its format.")
    sys.exit(1)
except Exception as e:
    print(f"An unexpected error occurred while loading config: {e}")
    sys.exit(1)

def change_spotify_volume(direction):
    try:
        auth_manager = SpotifyOAuth(
            client_id=CLIENT_ID,
            client_secret=CLIENT_SECRET,
            redirect_uri=REDIRECT_URI,
            scope=SCOPE,
            cache_path=os.path.join(script_dir, ".spotify_token_cache") 
        )
        sp = spotipy.Spotify(auth_manager=auth_manager)

        playback = sp.current_playback()

        if playback is None or playback.get('device') is None:
            print("No active Spotify Connect device found or nothing is playing.")
            return

        device_id = playback['device']['id']
        current_volume = playback['device']['volume_percent']

        new_volume = current_volume
        if direction == "up":
            new_volume = min(current_volume + VOLUME_STEP, 100)
        elif direction == "down":
            new_volume = max(current_volume - VOLUME_STEP, 0)
        else:
            print("Invalid direction. Use 'up' or 'down'.")
            return

        if new_volume != current_volume:
            sp.volume(new_volume, device_id=device_id)

    except Exception as e:
        print(f"An error occurred in change_spotify_volume: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        command = sys.argv[1]
        change_spotify_volume(command)