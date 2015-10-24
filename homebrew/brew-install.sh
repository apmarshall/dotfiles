#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Set Directory
export ZSH=$HOME/.dotfiles

set -e

# Check for Homebrew
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

# Check that jq is installed. If not, install it.
if test ! [ brew list | grep "jq" ]
then
  brew install jq

# Ask for the administrator password
# sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
echo "Making sure Homebrew is up to date."
brew update

# Upgrade any already-installed formulae.
echo "Updating existing formulae."
brew upgrade --all

# Tap needed kegs
echo "Checking tapped kegs."

find . -name packages.json | while read packages.json do
# Check for already tapped kegs, tap the ones that aren't already tapped
  for i in $(jq .Taps[])
    if test [ brew tap | grep $(jq .Taps[$i] ]
  then
    echo "$(jq .Taps[$i]) already tapped. Checking next keg"
  else
    brew tap $(jq .Taps[i])
    echo "Installing $(jq .Taps[i]"
  fi

# Install needed packages
echo "Installing requested packages"

# Check for already installed packages, install the ones that aren't already installed
for i in $(jq .Packages.Installs[])
  if test [ brew list | grep $(jq .Packages.Installs[$i])]
  then
    echo "$(jq .Packages.Installs[$i]) already installed. Checking next utility."
  else
    brew install $(jq .Packages.Installs[$i])
    echo "Installing $(jq .Packages.Installs[$i])."
  fi

done

# brew install php56
# brew install brew-php-switcher
# brew install composer
# brew install phpunit


# Remove outdated versions from the cellar.
brew cleanup

echo "All packages installed."

exit 0
