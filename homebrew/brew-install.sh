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

# Fix permissions issues that might stop Homebrew from working
echo "Checking that Homebrew has the permissions it needs to work"
echo "Checking usr/local"
sudo chown -R $(whoami):admin /usr/local

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

# Check that jq is installed. If not, install it.
#echo "Checking for needed packages"

#CHECKREQ=$(brew list | grep "jq")

#echo "Already installed packages:" $CHECKREQ

#if [ "$CHECKREQ" == "jq" ]; then
#	echo 'JQ already installed'
#else
#	echo "Installing JQ"
#	brew install jq
#fi

# Upgrade any already-installed formulae.
#echo "Updating existing formulae."
#brew upgrade --all

# Find Kegs and Packages From JSON files
echo "Finding requested kegs."
BREWKEGS=$(cat ~/.dotfiles/*/taps.txt)

# Tap needed kegs
echo "Checking if kegs are tapped."

# Check for already tapped kegs, tap the ones that aren't already tapped
for i in ${$BREWKEGS[@]} do
   TESTKEG=$(brew tap | grep "{$BREWKEGS[$i]}")
    if test $TESTKEG = $BREWKEGS[$i]
    then
      echo "{$BREWKEGS[$i]} already tapped. Checking next keg"
    else
      brew tap {$BREWKEGS[$i]}
      echo "Tapping {$BREWKEGS[$i]}"
    fi
done

# Install needed packages
echo "Finding requested packages."
BREWPKGS=$(cat ~/.dotfiles/*/packages.txt)

echo "Checking if packages are installed."

# Check for already installed packages, install the ones that aren't already installed
for i in ${$BREWPKGS[@]} do
   TESTPKG=$(brew tap | grep "{$BREWPKGS[$i]}")
   if test $TESTPKG = $BREWPKGS[$i] 
   then
      echo "{$BREWKEGS[$i]} already installed. Checking next package"
   else
      brew install {$BREWPKGS[$i}
      echo "Installing {$BREWPKGS[$i]}"
   fi
done

# Remove outdated versions from the cellar.
echo "Cleaning up outdated versions."
brew cleanup

echo "All packages installed."

exit 0
