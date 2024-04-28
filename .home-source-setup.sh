#!/bin/bash

if ! command -v git &> /dev/null
then
    echo "Git is not installed. Please install Git first."
    exit 1
fi

temp_dir=$(mktemp -d)
echo "Created temporary directory at $temp_dir"

git clone https://github.com/c0febean/home-source.git $temp_dir
echo "Repository cloned into $temp_dir"

cp -ra $temp_dir/. ~/

rm -rf $temp_dir

echo "Configuration is complete."
