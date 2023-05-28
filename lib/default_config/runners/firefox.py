# Import the webbrowser module
import webbrowser

# Import the sys module to access command-line arguments
import sys

# Check if an argument is given
if len(sys.argv) > 1:
    # Use the first argument as the URL to open
    url = sys.argv[1]
else:
    # Use bing.com as the default URL
    url = "https://www.bing.com"

# Open the URL in a new tab of Firefox
webbrowser.get("firefox").open_new_tab(url)
