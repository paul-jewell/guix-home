(use-modules (gnu home)
	     (gnu home services)
	     (gnu home services shells)
	     (gnu services)
	     (gnu packages admin)
	     (guix gexp))


(home-environment
 (packages (list htop))
 (services
  (list
   (service home-bash-service-type
	    (home-bash-configuration
	     (guix-defaults? #t)
	     (environment-variables
	      '(("XDG_CACHE_HOME" . "~/.cache")
		("HISTFILE" . "$XDG_CACHE_HOME/.bash_history"))))))))		 
		 
