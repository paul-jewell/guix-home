;;; -*-buffer-read-only: t;-*- 
;;; package ---  early-init.el: Prevent package-initialize being called before loading the init file
;;; Commentary:
;;; This file is tangled from ~/dotfiles/emacs.org. Any changes should be made there...

;;; Code:

(if (> emacs-major-version 27)
    (setq package-enable-at-startup nil))
