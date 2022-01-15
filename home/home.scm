(use-modules
 (gnu home)
 (gnu home services)
 (gnu home services shells)
 (gnu home services shepherd)
 (gnu services)
 (gnu packages)
 (gnu packages syncthing)
 (gnu packages admin)
 (gnu packages emacs)
 (guix gexp))

(define %inputrc
  (plain-file
   "inputrc"
   (string-append
    "set input-meta on\n"
    "set convert-meta off\n"
    "set output-meta on\n\n"
    "set editing-mode emacs\n\n"
    
    "$if mode=emacs\n"
    "# Allow the use of the home/end keys\n"
    "\"\\e[1~\": beginning-of-line\n"
    "\"\\e[4~\": end-of-line\n\n"
    "# Map 'page up' and 'page down' to search history based on current cmdline\n"
    "\"\\e[5~\": history-search-backward\n"
    "\"\\e[6~\": history-search-forward\n"
    "$endif\n")))

(define %emacs-packages
  ;;  (map specification->package
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
    "emacs-geiser"))

(define %programming
  (list
   "sbcl"))

(define %fonts
  (list
   "font-iosevka"
   "font-fira-mono"
   "font-fira-code"
   "font-google-noto"
   "font-gnu-freefont"
   "font-awesome"
   "font-google-material-design-icons"
   ))
   
(define %home-apps
  (append
   (list
    "htop"
    "syncthing"
    "nyxt")
   %emacs-packages
   %programming
   %fonts))

(home-environment
 (packages (map specification->package+output
		%home-apps))
 (services
  (list
   (service home-bash-service-type
	         (home-bash-configuration
	          (guix-defaults? #t)
	          (environment-variables
	           '(("XDG_CACHE_HOME" . "~/.cache")
		          ("INPUTRC" . "~/.inputrc")
		          ("HISTFILE" . "$XDG_CACHE_HOME/.bash_history")))))

   (service home-shepherd-service-type
            (home-shepherd-configuration
             (shepherd shepherd)
             (services
              (list
               (shepherd-service
                (provision '(syncthing))
                (documentation "Run 'syncthing' without calling the browser")
                (start #~(make-forkexec-constructor
                          (list #$(file-append syncthing "/bin/syncthing")
                                "-no-browser"
                                "-logflags=3" ; prefix with date and time
                                "-logfile=/home/paul/log/syncthing.log")))
                (stop #~(make-kill-destructor)))))))
                           
             
   (simple-service 'inputrc-config
		   home-files-service-type
		   (list `("inputrc"
			   ,%inputrc)))

   (simple-service 'emacs-config
		   home-files-service-type
		   (list `("emacs.d/early-init.el"
			   ,(local-file "files/emacs/early-init.el"))
			 `("emacs.d/init.el"
			   ,(local-file "files/emacs/init.el"))
			 `("emacs.d/site-specific.el"
			   ,(local-file "files/emacs/site-specific.el"))
          `("emacs.d/lisp/my-org-mode.el"
            ,(local-file "files/emacs/lisp/my-org-mode.el")))))))



