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

# Find Needed Kegs in  txt files
echo "Finding requested kegs."
KEGFILES=$(find ~/.dotfiles/*/taps.txt)
for file in $KEGFILES[@]; do
    declare -a kegsArray
    let i=0
    while IFS=$'\n' read -r line_data; do
	$kegsArray[$i]="$(line_data)"
	((++i))
    done < $KEGFILES[$file]

    #Tap Needed kegs
    echo "Checking if kegs are tapped."
    for i in $kegsArray[@]; do
	TESTKEG=$(brew tap | grep "{$kegsArray[$i]}"
	      if test $TESTKEG = $kegsArray[$i]
		  then
		      echo "{$kegsArray[$i]} already tapped. Checking next keg."
		  else
		      brew tap {$kegsArray[$i]}
		      echo "Tapping {$kegsArray[$i]}"
		  fi
     done
done
		  
# Find Needed Packages in txt files
echo "Finding requested packages."
PKGSFILES=$(find ${HOME}/.dotfiles/*/packages.txt)
for file in $PKGSFILES[@]; do
     delcare -a packagesArray
     let i=0
     while IFS=$'\n' read -r line_data; do
	 $packagesArray[$i]="${line_data}"
	 ((i++))
     done < $PKGSFILES[$file]

     # Install needed packages
     echo "Checking if packages are installed."

     for i in ${$packagesArray[@]} do
	      TESTPKG=$(brew tap | grep "{$packagesArray[$i]}")
	      if test $TESTPKG = $packagesArray[$i]
	      then
		  echo "{$packagesArray[$i]} already installed. Checking next package"
	      else
		  brew install {$packagesArray[$i}
		  echo "Installing {$packagesArray[$i]}"
	      fi
      done
done
				
# Remove outdated versions from the cellar.
echo "Cleaning up outdated versions."
brew cleanup

echo "All packages installed."

exit 0
