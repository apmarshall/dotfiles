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
  echo "Installing jq"
fi

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

# Find Kegs and Packages From JSON files
BREWKEGS=$( find . -name packages.json | jq '[.Taps[]]')
BREWPKGS=$( find . -name packages.josn | jq '[.Packages[.Installs[]]]')

# Tap needed kegs
echo "Checking tapped kegs."

# Check for already tapped kegs, tap the ones that aren't already tapped
  for i in ${$BREWKEGS[@]}
  do
    if test [ brew tap | grep {$BREWKEGS[$i]} ]
    then
      echo "{$BREWKEGS[$i]} already tapped. Checking next keg"
    else
      brew tap {$BREWKEGS[$i]}
      echo "Tapping {$BREWKEGS[$i]}"
    fi
  done

# Install needed packages
echo "Installing requested packages"

# Check for already installed packages, install the ones that aren't already installed
  for i in ${$BREWPKGS[@]}
  do
    if test [ brew tap | grep {$BREWPKGS[@]} ]
    then
      echo "{$BREWKEGS[$i]} already installed. Checking next package"
    else
      brew install {$BREWPKGS[@]}
      echo "Installing {$BREWPKGS[@]}"
    fi
  done

# Remove outdated versions from the cellar.
brew cleanup

echo "All packages installed."

exit 0
