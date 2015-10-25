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

# Chown usr/local to get around the new SIP issues
sudo chown -R $(whoami):admin /usr/local

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

# Make sure we’re using the latest Homebrew.
echo "Making sure Homebrew is up to date."
brew update

# Check that jq is installed. If not, install it.
echo "Checking for needed packages"

CHECKREQ=$(brew list -1 | grep "jq")

echo "Already installed packages:" $CHECKREQ

if [ "$CHECKREQ" == "jq" ]; then
	echo 'JQ already installed'
else
	echo "Installing JQ"
	brew install jq
fi

# Upgrade any already-installed formulae.
# echo "Updating existing formulae."
# brew upgrade --all

# Find Kegs and Packages From JSON files
BREWKEGS=$( find ~/.dotfiles/ -name packages.json | jq '[.Taps[]]')
BREWPKGS=$( find ~/.dotfiles/ -name packages.josn | jq '[.Packages[.Installs[]]]')

# Tap needed kegs
echo "Checking tapped kegs."

# Check for already tapped kegs, tap the ones that aren't already tapped
  for i in ${$BREWKEGS[@]}
  do
   TESTKEG=$(brew tap | grep -q "{$BREWKEGS[$i]}")
    if test $TESTKEG = 0
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
   TESTPKG=$(brew tap | grep -q "{$BREWPKGS[@]}")
    if test $TESTPKG = 0
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
