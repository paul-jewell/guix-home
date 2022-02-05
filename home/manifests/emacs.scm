(specifications->manifest
 '(
   "emacs"
   "emacs-use-package"
   "emacs-no-littering"
   "emacs-ivy"
   "emacs-ivy-hydra"
   "emacs-ivy-rich"
   "emacs-swiper"
   "emacs-counsel-bbdb"
   "emacs-counsel"
   "emacs-which-key"
   "ispell"
   "hunspell"
   "hunspell-dict-en-gb"
   "emacs-ledger-mode"
   "emacs-go-mode"
   
   "emacs-multiple-cursors"
   "emacs-org-bullets"
   "emacs-org-roam"
   ;; "emacs-org-roam-dailies" ;; package not available under guix
   "emacs-auctex"
   ;;"reftex" ;; included in emacs
   "emacs-hydra"
   ;;"emacs-js2-mode"
   ;;"emacs-js2-reflector-el"
   "emacs-company"
   "emacs-company-irony"
   "emacs-irony-mode"
   "emacs-irony-eldoc"
   "emacs-company-jedi"
   "emacs-magit"
   "emacs-git-gutter"
   "emacs-git-timemachine"
   "emacs-flycheck"
   "emacs-all-the-icons"
   "emacs-all-the-icons-dired"
   "emacs-gruvbox-theme"
   "emacs-projectile"
   "emacs-counsel-projectile"
   "emacs-powerline"
   "emacs-diminish"
   "emacs-paredit"
   ;;"emacs-paredit-everywhere"
   "emacs-rainbow-delimiters"
   "emacs-cider"
   ;;"emacs-cider-hydra"
   "emacs-slime"
   "emacs-elisp-slime-nav"
   "mu"
   "emacs-mu4e-alert"
   "isync"
   "emacs-org-caldav"
   "emacs-helpful"
   "pinentry"
   "emacs-pinentry"
   ;;"emacs-erc"
   ;;"emacs-erc-log"
   ;;"emacs-erc-notify"
   ;;"emacs-erc-spelling"
   ;;"emacs-erc-autoaway"
   "emacs-toc-org"
   "emacs-ox-hugo"
   "emacs-flycheck-guile"
   "emacs-guix"
   "emacs-geiser"
   ))

;; (define-public services
;;   (list
;;    (service home-emacs-service-type
;;             (home-emacs-configuration
;;              (package emacs)
;;              ;;Useful for native-comp - not for emacs27
;;              ;;(rebuild-elisp-packages? #t)
	     
;;              ;; Because the init.el and early-init.el are used in my gentoo
;;              ;; systems, I load them up directly. They are generated when
;;              ;; the emacs.org file is tangled.
;;              (init-el
;;               `(,(slurp-file-gexp (local-file "files/init.el"))))
;;              (early-init-el
;;               `(,(slurp-file-gexp (local-file "files/early-init.el"))))
;;              (elisp-packages packages)))))
