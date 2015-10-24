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

#Array of Kegs to Be Tapped
KEGS=("homebrew/dupes","homebrew/versions")

# Check if Keg already tapped. If Not, tap it.
for i in {$KEGS[@]}
  if test [ brew tap | grep '{$KEGS[$i]}' ]
  then
    echo "{$KEGS[$i]} already tapped. Checking next keg"
  else
    brew tap {$KEGS[$i]}
    echo "Installing {$KEGS[$i]}"
  fi

# Install Utilities (those that come with OS X are outdated).
# ?? Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
echo "Installing Utilities."

# Array of OSX Tools to Be Installed
BREWUTILS=("coreutils", "findutils", "gnu-sed", "wget", "grep", "openssh", "git")

# Check if pakcages already installed. If not, install them.
for i in {$BREWUTILS[@]}
  if test [ brew list | grep "{$BREWUTILS[$i]}"]
  then
    echo "{$BREWUTILS[$i]} already installed. Checking next utility."
  else
    brew install {$BREWUTILS[$i]}
    echo "Installing {$BREWUTILS[$i]}."
  fi

# Install Add-on Tools
echo "Installing extensions to tools you use."

# Array of OSX Tools to Be Installed
BREWADDS=("git-extras", "fasd", "bundler", "hub", "tmux", "the_silver_searcher")

# Check if pakcages already installed. If not, install them.
for i in {$BREWADDS[@]}
  if test [ brew list | grep "{$BREWADDS[$i]}"]
  then
    echo "{$BREWADDS[$i]} already installed. Checking next utility."
  else
    brew install {$BREWUTILS[$i]}
    echo "Installing {$BREWADDS[$i]}."
  fi

# Install Web Development Tools
echo "Installing web development tools."

# Array of OSX Tools to Be Installed
BREWWEB=("awscli", "foreman", "mysql", "node", "postgresql", "redis", "wp-cli")

# Check if pakcages already installed. If not, install them.
for i in {$BREWWEB[@]}
  if test [ brew list | grep "{$BREWWEB[$i]}"]
  then
    echo "{$BREWUTILS[$i]} already installed. Checking next utility."
  else
    brew install {$BREWWEB[$i]}
    echo "Installing {$BREWWEB[$i]}."
  fi

# Install Other Packages
echo "Installing a few other packages."
BREWOTHER=("imagemagick")

# Check if pakcages already installed. If not, install them.
for i in {$BREWOTHER[@]}
  if test [ brew list | grep "{$BREWOTHER[$i]}"]
  then
    echo "{$BREWOTHER[$i]} already installed. Checking next utility."
  else
    brew install {$BREWOTHER[$i]}
    echo "Installing {$BREWOTHER[$i]}."
  fi

# brew install php56
# brew install brew-php-switcher
# brew install composer
# brew install phpunit


# Remove outdated versions from the cellar.
brew cleanup

echo "All packages installed."

exit 0
