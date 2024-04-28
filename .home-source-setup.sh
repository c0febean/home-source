#!/bin/bash

if ! which git &>/dev/null; then
    echo "Git is not installed. Please install Git first."
    exit 1
fi

temp_dir=$(mktemp -d ~/temp.XXXXXX)
echo "Created temporary directory at $temp_dir"
if ! git clone https://github.com/c0febean/home-source.git $temp_dir; then
    echo "Error occurred during git clone. Aborting."
    rm -rf $temp_dir
    exit 1
fi
echo "Repository cloned into $temp_dir"

if ! command -v zsh &> /dev/null
then
    echo "zsh is not installed. Installing zsh..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y zsh
        elif command -v yum &> /dev/null; then
            sudo yum update
            sudo yum install -y zsh
        else
            echo "Unsupported package manager. Install zsh manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install zsh
    else
        echo "Unsupported OS. Install zsh manually."
        exit 1
    fi
fi

if ! grep -q $(which zsh) /etc/shells; then
    echo $(which zsh) | sudo tee -a /etc/shells
fi
chsh -s $(which zsh)
echo "Switched to zsh."

cp -ra $temp_dir/. ~/

exec zsh
source ~/.zshrc
echo ".zshrc reloaded."

rm -rf $temp_dir
echo "Configuration is complete."
