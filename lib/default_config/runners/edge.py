import subprocess
import sys

# Check if an argument is given
if len(sys.argv) > 1:
    # Use the first argument as the URL to open
    url = sys.argv[1]
else:
    # Use bing.com as the default URL
    url = "https://www.bing.com"

subprocess.run(["microsoft-edge", url])
