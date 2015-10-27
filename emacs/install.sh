# Create Emacs init.el file
echo '(let ((default-directory "/usr/local/share/emacs/site-lisp/")) \
  (normal-top-level-add-subdirs-to-load-path))' > ~/.emacs.d/init.el

echo '(add-to-list 'custom-theme-load-path "/usr/local/Cellar/solarized-emacs/HEAD/share/emacs/site-lisp/solarized") \
(load-theme 'solarized t) \
(setq solarized-termcolors 256)' > ~/.emacs.d/init.el

exit 0
