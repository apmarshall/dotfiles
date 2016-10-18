#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

set -e

# Ask for the administrator password
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew
echo "Checking for Homebrew."
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
 if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi
  
fi
echo "Homebrew is installed."

echo "Checking permissions for the Homebrew cache"
sudo chown -R $(whoami):admin $(brew --cache)

# Make sure we’re using the latest Homebrew.
echo "Making sure Homebrew is up to date."
brew update

# Upgrade any already-installed formulae.
echo "Updating existing formulae."
brew upgrade --all

# Install a few needed packages
echo "Installing preliminary packages"
brew install python3
brew install rcmdnk/file/brew-file

# Install all requested packages
brew file install
				
# Remove outdated versions from the cellar.
echo "Cleaning up outdated versions."
brew cleanup

echo "All packages installed."

exit 0
