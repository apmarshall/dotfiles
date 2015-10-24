#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

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

# Ask for the administrator password
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
echo "Making sure Homebrew is up to date."
brew update

# Upgrade any already-installed formulae.
echo "Updating existing formulae."
brew upgrade --all

# Tap appropriate kegs
echo "Tapping needed kegs."
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
echo "Installing Utilities."
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some OS X tools.
echo "Installing more recent version of some OS X tools."
brew install grep
brew install openssh
brew install screen
brew install php56
brew install git

# Install Add-on Tools
echo "Installing extensions to tools you use."
brew install git-extras
brew install fasd
brew install bundler
brew install hub
brew install tmux
brew install the_silver_searcher

# Install Web Development Tools
echo "Installing web development tools."
brew install awscli
brew install brew-php-switcher
brew install composer
brew install foreman
brew install mysql
brew install node
brew install phpunit
brew install postgresql
brew install redis
brew install ruby
brew install wp-cli

# Install Other Packages
echo "Installing a few other packages."
brew install imagemagick

# Remove outdated versions from the cellar.
brew cleanup

echo "All packages installed."

exit 0
