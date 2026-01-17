#!/usr/bin/env bash

# eas-build-pre-install.sh
# This script runs before eas build installs dependencies
# It creates a .netrc file for Mapbox SDK downloads

# Exit on error
set -e

echo "Creating .netrc file for Mapbox downloads..."

# Create .netrc file with Mapbox credentials
cat > ~/.netrc << EOF
machine api.mapbox.com
login mapbox
password $RNMAPBOX_MAPS_DOWNLOAD_TOKEN
EOF

# Set proper permissions (required by curl)
chmod 600 ~/.netrc

echo ".netrc file created successfully"
echo "Mapbox token configured for SDK downloads"
