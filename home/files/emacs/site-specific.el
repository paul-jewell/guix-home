;; -*-buffer-read-only: t;-*-
;;; Site-specific.el --- local variables for each system
;;; Commentary: Support funtions to enable configuration to be configured
;;;             for different machines.
;;;             This code is tangled from .dotfiles/emacs.org, so changes should
;;;             be made there, and not here.
;;; code:

;; Globals to configure which blocks are loaded

(defvar *pj/enable-mu4e-mode* nil   "Enable mu4e mode.")
(defvar *pj/load-site-gentoo* nil   "Load gentoo's config file.")
(defvar *pj/enable-auctex*    nil   "Enable auctex mode.")
(defvar *pj/font-size*        "10"  "Fontsize for this system.")

t(defvar *pj/info-default-directory-list* "~/Nextcloud/git/org-mode/doc")

(defun pj/is-windows-p ()
  "True if run in windows environment."
  (string= "windows-nt" system-type))

(defun pj/is-linux-p ()
  "True if run in linux environment."
  (string= "gnu/linux" system-type))

(defun pj/is-host-p (name)
  "True if running on system NAME."
  (string= (system-name) name))

;; Currently only zeus is a guix system. This may need changing in the future.
(defun pj/is-guix-p ()
  "True if system is running guix."
  (pj/is-host-p "zeus"))

;; Three possibilities for specifying values:

;; - Globally, for all systems
;; - By operating system
;; - By system name

(cond
 ((pj/is-linux-p)
  (cond
   ((string-prefix-p "DESKTOP" (system-name)) ;; Windows WSL2 on Tristan
    (progn
      (require 'gnutls)
      (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
	   (setq *pj/enable-mu4e-mode* t)
	   (setq *pj/load-site-gentoo* nil)
	   (setq *pj/enable-auctex* t)
	   
	   ;; define the location of the orgmode code - currently using the built in version.
	   ;;(add-to-list 'load-path "/mnt/c/Users/paul/Nextcloud/git/org-mode/lisp")
	   ;;(add-to-list 'load-path "/mnt/c/Users/paul/Nextcloud/git/org-mode/contrib/lisp")
      (defvar *pj/org-agenda-files* '("/mnt/c/Users/paul/Nextcloud/org"))
      (defvar *pj/org-roam-directory*   "/mnt/c/Users/paul/Nextcloud/org/roam/")
      (defvar *pj/org-roam-db-location* "/mnt/c/Users/paul/Nextcloud/org/org-roam.db")
	   (setq *pj/font-size* "10")))
   ((pj/is-guix-p)
    (progn
      (setq *pj/enable-mu4e-mode* t)
      (setq *pj/load-site-gentoo* nil)
      (setq *pj/enable-auctex* t)
	   ;; define the location of the orgmode code
	   ;;(add-to-list 'load-path "~/Nextcloud/git/org-mode/lisp")
	   ;;(add-to-list 'load-path "~/Nextcloud/git/org-mode/contrib/lisp")
      (defvar *pj/org-agenda-files* '("~/Nextcloud/org"))
      (defvar *pj/org-roam-directory*   "~/Nextcloud/org/roam/")
      (defvar *pj/org-roam-db-location* "~/Nextcloud/org/org-roam.db")))
   (t (progn
        (setq *pj/enable-mu4e-mode* t)
        (setq *pj/load-site-gentoo* t)
        (setq *pj/enable-auctex* t)
	     ;; define the location of the orgmode code
	     ;;(add-to-list 'load-path "~/Nextcloud/git/org-mode/lisp")
	     ;;(add-to-list 'load-path "~/Nextcloud/git/org-mode/contrib/lisp")
        (defvar *pj/org-agenda-files* '("~/Nextcloud/org"))
        (defvar *pj/org-roam-directory*   "~/Nextcloud/org/roam/")
        (defvar *pj/org-roam-db-location* "~/Nextcloud/org/org-roam.db")))))
 ((pj/is-windows-p) ;; Not WSL2 installation - that is declared as linux
  (progn
    (setq *pj/enable-mu4e-mode* nil)
    (setq *pj/load-site-gentoo* nil)
    (setq *pj/enable-auctex* nil)
    
    ;; define the location of the orgmode code
    ;;(add-to-list 'load-path  "c:/users/paul/Nextcloud/git/org-mode/lisp")
    ;;(add-to-list 'load-path "c:/users/Paul/Nextcloud/git/org-mode/contrib/lisp")
    (defvar *pj/my-org-roam-directory* "c:/users/Paul/Nextcloud/org/roam/")
    (defvar *pj/org-agenda-files* '("~/Nextcloud/org"))
    (defvar *pj/org-roam-directory*   "~/Nextcloud/org/roam/")
    (defvar *pj/org-roam-db-location* "~/Nextcloud/org/org-roam.db")
    (setq *pj/font-size* "10")))
 (t
  (error "Undefined system-type %s" system-type)))

;; Make the output file read-only when loaded into emacs - reduce the chance of accidentally
;; editing the file outside of emacs.org.
;; Local Variables:
;; buffer-read-only: t
;; End:

(provide 'site-specific)
;;; site-specific.el ends here
