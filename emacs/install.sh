# Create Emacs init.el file
echo '(let ((default-directory "/usr/local/share/emacs/site-lisp/"))
  (normal-top-level-add-subdirs-to-load-path))' > ~/.emacs.d/init.el

exit 0
