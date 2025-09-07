#!/bin/bash

cd "$(dirname "$0")"
mkdir -p assets/fonts

echo "Downloading Roboto fonts..."
curl -L -o assets/fonts/Roboto-Regular.ttf "https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Regular.ttf"
curl -L -o assets/fonts/Roboto-Medium.ttf "https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Medium.ttf"
curl -L -o assets/fonts/Roboto-Bold.ttf "https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Bold.ttf"

echo "Font download completed!"
