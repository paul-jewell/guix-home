(use-modules (gnu home)
	     (gnu home services)
	     (gnu home services shells)
	     (gnu services)
	     (gnu packages)
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

(define %home-apps
  (list "htop"))

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

   (simple-service 'inputrc-config
		   home-files-service-type
		   (list `("inputrc"
			   ,%inputrc))))))

