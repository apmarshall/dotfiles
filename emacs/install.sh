# Install emacs via Homebrew, replace sytem version

echo "Installing Emacs from Homebrew"
brew install emacs --with-cocoa

# Tap Homebrew Emacs Keg

echo "Tapping Emacs Keg"
brew tap homebrew/emacs

# Create Emacs init.el file
echo '(let ((default-directory "/usr/local/share/emacs/site-lisp/"))
  (normal-top-level-add-subdirs-to-load-path))' > ~/.emacs.d/init.el

# Install Emacs Customization Packages

echo "Installing Emacs Packages"

echo "Magit"
brew install magit

echo "Flycheck"
brew install flycheck

echo "Smex"
brew install smex

echo "Markdown Mode"
brew install markdown-mode

echo "PHP Mode"
brew install php-mode

echo "Web Mode"
brew install web-mode

echo "Helm"
brew install helm

# Finish up
brew cleanup

echo "All Emacs extensions installed!"

exit 0
