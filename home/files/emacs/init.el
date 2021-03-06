;;-*-buffer-read-only: t;-*-

;;; init.el --- Startup file for emacs

;;; Commentary:
;; Initial configuration file loaded by Emacs.
;;  - Sets the custom configuration file location
;; This file is generated from ~/dotfiles/emacs.org and tangled. Changes should
;; be made to that file; also for more information - see details there.
;;
;; (c) 2017 - 2021 Paul Jewell
;; Contributions from many sources, including:
;; - David Wilson
;; - bbatsov
;;
;; Licence: BSD

;;; Code:

;; The default is 800 kb. Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; profile emacs startup

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; Load machine local definitions

(defvar *pj/enable-mu4e-mode* nil   "Enable mu4e mode.")
(defvar *pj/load-site-gentoo* nil   "Load gentoo's config file.")
(defvar *pj/enable-auctex*    nil   "Enable auctex mode.")
(defvar *pj/font-size*        "10"  "Fontsize for this system.")

(defvar *pj/info-default-directory-list* "~/Nextcloud/git/org-mode/doc")

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
  (pj/is-host-p "mercury"))

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


(require 'site-specific "~/.emacs.d/site-specific.el")

(defvar *packages-initialised* nil)

(defun initialise-packages ()
  "Ensure `package-initialize' is called only once."
  (unless *packages-initialised*
    (package-initialize)
    (setq *packages-initialised* t)))

(initialise-packages)

;; To load external version of org-mode, clone the code from git:
;; - cd <directory below which you want the org code>
;; - git clone https://code.orgmode.org/bzg/org-mode.git
;; - cd org-mode
;; - make autoloads # creates org-loaddefs.el in the lisp directory

;; Using the built in version of orgmode - no need to use the git version...
;;;(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
;;;(use-package org)

(defvar init-dir) ;; Initial directory for emacs configuration
(setq init-dir (file-name-directory (or load-file-name (buffer-file-name))))

;;==============================================================================
;;.....General configuration
;;     ---------------------

;; Set default modes
(setq major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Go straight to scratch buffer on startup
(setq inhibit-startup-screen t)

;; dont use tabs for indenting
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)
(set-variable 'confirm-kill-emacs 'yes-or-no-p)

;; Eliminate C-z sleep
(global-unset-key [(control z)])
(global-unset-key [(control x)(control z)])

;; The following lines are always needed. Choose your own keys.
(global-font-lock-mode t)
(global-set-key "\C-x\C-l" 'goto-line)
(global-set-key "\C-x\C-y" 'copy-region-as-kill)

;; Remove the tool-bar from the top
(tool-bar-mode -1)
;; (menu-bar-mode -1)
(scroll-bar-mode -1)

;; Full path in title bar
(setq-default frame-title-format "%b (%f)")

(defalias 'list-buffers 'ibuffer)

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "Backups"))))

;;==============================================================================
;;.....Package management
;;     ------------------

(require 'gnutls)

(defvar pj/python)
(setq pj/python (executable-find "python"))

;; Add marmalade to package repos
(setq package-archives `(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))
      
(initialise-packages)

;; Not sure if this is necessary for guix system.
;; Maybe OK, as it only updates the package list, not the installed code.
(unless (and (file-exists-p (concat init-dir "elpa/archives/gnu"))
             (file-exists-p (concat init-dir "elpa/archives/melpa"))
             (file-exists-p (concat init-dir "elpa/archives/melpa-stable"))
             (file-exists-p (concat init-dir "elpa/archives/org")))
  (package-refresh-contents))

;; Initialise use-package on non-guix systems.
(unless (or (package-installed-p 'use-package)
            (pj/is-guix-p))
  (package-install 'use-package))
(require 'use-package)

;; In guix system - load packages through the guix package manager.
(setq use-package-always-ensure (not (pj/is-guix-p)))

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering)

;; Keep customization settings in a temporary file (thanks Ambrevar!)
(setq custom-file
      (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
        (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

(setq tramp-default-method "ssh")
;; Ensure paths are correct for editing files on guix systems (thanks @janneke)
(with-eval-after-load 'tramp-sh (push 'tramp-own-remote-path tramp-remote-path))

;;==============================================================================
;;.....Ivy
;;     ---

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)

  (push '(completion-at-point . ivy--regex-fuzzy) ivy-re-builders-alist)
  (push '(swiper . ivy--regex-ignore-order) ivy-re-builders-alist)
  (push '(counsel-M-x . ivy--regex-ignore-order) ivy-re-builders-alist)

  (setf (alist-get 'swiper ivy-height-alist) 15)
  (setf (alist-get 'counsel-switch-buffer ivy-height-alist) 7))

(use-package ivy-hydra
  :defer t
  :after hydra)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  :config
  (setcdr  (assq t ivy-format-functions-alist) #'ivy-format-function-line)
  (setq ivy-rich-display-transformers-list
        (plist-put ivy-rich-display-transformers-list
                   'ivy-switch-buffer
                   '(:columns
                     ((ivy-rich-candidate (:width 40))
                      (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)); return the buffer indicators
                      (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))          ; return the major mode info
                      (ivy-rich-switch-buffer-project (:width 15 :face success))             ; return project name using `projectile'
                      (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))  ; return file path relative to project root or `default-directory' if project is nil
                     :predicate
                     (lambda (cand)
                       (if-let ((buffer (get-buffer cand)))
                           ;; Don't mess with EXWM buffers
                           (with-current-buffer buffer
                             (not (derived-mode-p 'exwm-mode)))))))))

;;==============================================================================
;;.....Swiper
;;     ------

;; Counsel - completion package working with ivy.
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

;; TODO: Configure counsel-bbdb to work eith email, or configure a different
;;       package to manage contacts (synced with cardDAV)
(use-package counsel-bbdb
  :ensure t)

(use-package swiper
  :bind (("C-s" . swiper)
         ("C-r" . swiper)
         ("C-c C-r" . ivy-resume)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)))

;;==============================================================================
;;.....which-key
;;     ---------
;; Key completion - offers the keys which complete the sequence.

(use-package which-key
  :config (which-key-mode))

;;==============================================================================
;;.....ispell
;;     ------
;; Spell checker.

(require 'ispell)
(setenv "LANG" "en_GB")
(setq ispell-program-name "hunspell")
(if (string= system-type "windows-nt")
    (setq ispell-hunspell-dict-paths-alist
          '(("en_GB" "c:/Hunspell/en_GB.aff"))))
(setq ispell-local-dictionary "en_GB")
(setq ispell-local-dictionary-alist
      '(("en_GB" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_GB") nil utf-8)))
;; (flyspell-mode 1)
(global-set-key (kbd "M-\\") 'ispell-word)

;;==============================================================================
;;.....ledger
;;     ------
;; Text based accounting program.

(use-package ledger-mode
  :init
  (setq ledger-clear-whole-transactions 1)
  
  :config
  (add-to-list 'auto-mode-alist '("\\.dat$" . ledger-mode))
  (add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode)))

;;==============================================================================
;;.....go
;;     --
;; Package for go programming.

(use-package go-mode
   :config
   (add-hook 'go-mode-hook (lambda () (setq auto-complete-mode 1))))

;;==============================================================================
;;.....Python
;;     ------


;;; Currently commented out - jedi mode should not be installed when using
;;; company mode. company-jedi should be used instead

;;(use-package jedi
;;  
;;  :init
;;  (add-hook 'python-mode-hook 'jedi:setup)
;;  (add-hook 'python-mode-hook 'jedi:ac-setup))
;;; Alternative - use elpy - not yet fully configured
;;(use-package elpy
;;  
;;  :init
;;  (advice-add 'python-mode :before 'elpy-enable))

;;==============================================================================
;;.....SQL
;;     ---


(require 'sql)

(eval-after-load "sql"
  '(progn (sql-set-product 'mysql)))

;;==============================================================================
;;.....c++
;;     ---

(defun my-c++-mode-hook()
  "Customise the default c++ settings."
  (c-set-style "stroustrup"))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;;==============================================================================
;;.....smex
;;     ----
;; M-x enhancement - show most recently used commands which match as typing.

;; (use-package smex
;; 
;; :bind (("M-x" . smex)
;;        ("M-X" . smex-major-mode-commands)
;;        ("C-c C-c M-x" . 'execute-extended-command)) ;; Original M-x command
;; :config (smex-initialize))

(defadvice ido-set-matches-1 (around ido-smex-acronym-matches activate)
  "Filters ITEMS by setting acronynms first."
  (if (and (fboundp 'smex-already-running) (smex-already-running) (> (length ido-text) 1))
      
      ;; We use a hash table for the matches, <type> => <list of items>, where
      ;; <type> can be one of (e.g. `ido-text' is "ff"):
      ;; - strict: strict acronym match (i.e. "^f[^-]*-f[^-]*$");
      ;; - relaxed: for relaxed match (i.e. "^f[^-]*-f[^-]*");
      ;; - start: the text start with (i.e. "^ff.*");
      ;; - contains: the text contains (i.e. ".*ff.*");
      (let ((regex (concat "^" (mapconcat 'char-to-string ido-text "[^-]*-")))
            (matches (make-hash-table :test 'eq)))

        ;; Filtering
        (dolist (item items)
          (let ((key))
            (cond
             ;; strict match
             ((string-match (concat regex "[^-]*$") item)
              (setq key 'strict))

             ;; relaxed match
             ((string-match regex item)
              (setq key 'relaxed))

             ;; text that start with ido-text
             ((string-match (concat "^" ido-text) item)
              (setq key 'start))

             ;; text that contains ido-text
             ((string-match ido-text item)
              (setq key 'contains)))

            (when key
              ;; We have a winner! Update its list.
              (let ((list (gethash key matches ())))
                (puthash key (push item list) matches)))))

        ;; Finally, we can order and return the results
        (setq ad-return-value (append (gethash 'strict matches)
                                      (gethash 'relaxed matches)
                                      (gethash 'start matches)
                                      (gethash 'contains matches))))

    ;; ...else, run the original ido-set-matches-1
    ad-do-it))

;; Delayed loading - initialisation when used for the first time
;; (global-set-key [(meta x)]
;;   (lambda ()
;;     (interactive)
;;     (or (boundp 'smex-cache)
;;         (smex-initialize))
;;     (global-set-key [(meta x)] 'smex) (smex)))

;; (global-set-key [(shift meta x)]
;;   (lambda () (interactive)
;;   (or (boundp 'smex-cache) (smex-initialize))
;;   (global-set-key [(shift meta x)] 'smex-major-mode-commands)
;;   (smex-major-mode-commands)))

;;==============================================================================
;;.....multiple cursors
;;     ----------------

(use-package multiple-cursors
  :config (global-set-key (kbd "C-c m c") 'mc/edit-lines))

;;==============================================================================
  ;;.....org mode
  ;;     --------


  (require 'org)
;;  (require 'org-contribdir)
  (require 'org-agenda)
  (require 'org-clock)
  (require 'org-archive)
;;  (require 'org-checklist)
  (require 'org-crypt)
  (require 'org-protocol)
  (require 'ido)
  (require 'org-id)
;;  (require 'bbdb-com)
  (require 'ox-html)
  (require 'ox-latex)
  (require 'ox-ascii)
  (require 'org-tempo)

  (setq org-agenda-files *pj/org-agenda-files*)
  (load "~/.emacs.d/lisp/my-org-mode.el")
  (require 'org-habit) ;; org-habit is part of org-mode (not a package)
  (global-set-key (kbd "C-c w") 'org-refile)

;;==============================================================================
;;.....org bullet mode
;;     ---------------

(use-package org-bullets
  :config (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;;==============================================================================
;;.....org roam mode
;;     -------------

;; Installation advice from the org-roam documentation website:
;; https://org-roam.readthedocs.io/en/master/installation/
;; and also the System Crafters videos on org-roam (from v2 onwards).

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t) ;; Silence version 2 update message  
  :custom
  (org-roam-db-location *pj/org-roam-db-location*)
  (org-roam-directory *pj/org-roam-directory*)
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
      :unnarrowed t)
     ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: Project\n#+date: %U")
      :unnarrowed t)))
;;  (org-roam-dailies-capture-templates
;;   '(("d" "default" entry "* %<%I:%M %p>: %?"
;;      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>an"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n j" . org-roam-dailies-capture-today)
         ("C-c n g" . org-roam-graph)
         ("C-c n c" . org-roam-capture)
         :map org-mode-map
         ("C-M-i"   . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; ensure the keymap is available
  (org-roam-db-autosync-mode))

;;==============================================================================
;;.....GPL3 File header boilerplate
;;     ----------------------------

(defun boilerplate-gpl3 ()
  "Insert boilerplate for c/c++ file with GPLv3 license."
        (interactive)
        (insert "
/********************************************************************************
 * Copyright (C) " (format-time-string "%Y") " Paul Jewell (paul@teulu.org)                              *
 *                                                                              *
 * This program is free software: you can redistribute it and/or modify         *
 * it under the terms of the GNU General Public License as published by         *
 * the Free Software Foundation, either version 3 of the License, or            *
 * (at your option) any later version.                                          *
 *                                                                              *
 * This program is distributed in the hope that it will be useful,              *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of               *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                *
 * GNU General Public License for more details.                                 *
 *                                                                              *
 * You should have received a copy of the GNU General Public License            *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.        *
 ********************************************************************************/
"))

(defun boilerplate-lgpl3 ()
  "Insert boilerplate for c/c++ file with LGPLv3 license."
        (interactive)
        (insert "
/********************************************************************************
 * Copyright (C) " (format-time-string "%Y") " Paul Jewell (paul@teulu.org)                              *
 *                                                                              *
 * This program is free software: you can redistribute it and/or modify         *
 * it under the terms of the GNU Lesser General Public License as published by  *
 * the Free Software Foundation, either version 3 of the License, or            *
 * (at your option) any later version.                                          *
 *                                                                              *
 * This program is distributed in the hope that it will be useful,              *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of               *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                *
 * GNU Lesser General Public License for more details.                          *
 *                                                                              *
 * You should have received a copy of the GNU Lesser General Public License     *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.        *
 ********************************************************************************/
"))

(defun boilerplate-agpl3 ()
  "Insert boilerplate for c/c++ file with AGPLv3 license."
        (interactive)
        (insert "
/********************************************************************************
 * Copyright (C) " (format-time-string "%Y") " Paul Jewell (paul@teulu.org)                              *
 *                                                                              *
 * This program is free software: you can redistribute it and/or modify         *
 * it under the terms of the GNU Affero General Public License as published by  *
 * the Free Software Foundation, either version 3 of the License, or            *
 * (at your option) any later version.                                          *
 *                                                                              *
 * This program is distributed in the hope that it will be useful,              *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of               *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                *
 * GNU Affero General Public License for more details.                          *
 *                                                                              *
 * You should have received a copy of the GNU Affero General Public License     *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.        *
 ********************************************************************************/
"))

;;==============================================================================
;;.....auctex
;;     ------

(when *pj/enable-auctex*
  (use-package auctex
    :mode ("\\.tex\\'" . latex-mode)
    :config
    (setq TeX-auto-save t)
    (setq TeX-parse-self t)
    (setq-default TeX-master nil)
    
    (add-hook 'LaTeX-mode-hook 
              (lambda ()
                (company-mode)
                (visual-line-mode) ; May prefer auto-fill-mode
                (flyspell-mode)
                (turn-on-reftex)
                (setq TeX-PDF-mode t)
                (setq reftex-plug-into-AUCtex t)
                (LaTeX-math-mode)))
    
    ;; Update PDF buffers after successful LaTaX runs
    (add-hook 'TeX-after-TeX-LaTeX-command-finished-hook
              #'TeX-revert-document-buffer)
    
    ;; to use pdfview with auctex
    (add-hook 'Latex-mode-hook 'pdf-tools-install)))

;;==============================================================================
;;.....reftex
;;     ------

;;(use-package reftex
;;  :defer t
;;  :config
;;  (setq reftex-cite-prompt-optional-args t)) ; prompt for empty optional args in cite


;;==============================================================================
;;.....ivy-bibtex
;;     ----------

;; TODO: Modify the paths etc in this section:

;;(use-package ivy-bibtex
;;  
;;  :bind ("C-c b b" . ivy-bibtex)
;;  :config
;;  (setq bibtex-completion-bibliography 
;;        '("C:/Users/Nasser/OneDrive/Bibliography/references-zot.bib"))
;;  (setq bibtex-completion-library-path 
;;        '("C:/Users/Nasser/OneDrive/Bibliography/references-pdf"
;;          "C:/Users/Nasser/OneDrive/Bibliography/references-etc"))
;;
;;  ;; using bibtex path reference to pdf file
;;  (setq bibtex-completion-pdf-field "File")
;;
;;  ;;open pdf with external viwer foxit
;;  (setq bibtex-completion-pdf-open-function
;;        (lambda (fpath)
;;          (call-process "C:\\Program Files (x86)\\Foxit Software\\Foxit Reader\\FoxitReader.exe" nil 0 nil fpath)))
;;
;;  (setq ivy-bibtex-default-action 'bibtex-completion-insert-citation))

;;==============================================================================
;;.....hydra
;;     -----

(use-package hydra 
  :init 
  (global-set-key
   (kbd "C-x t")
	(defhydra toggle (:color blue)
	  "toggle"
	  ("a" abbrev-mode "abbrev")
	  ("s" flyspell-mode "flyspell")
	  ("d" toggle-debug-on-error "debug")
     ;;	      ("c" fci-mode "fCi")
	  ("f" auto-fill-mode "fill")
	  ("t" toggle-truncate-lines "truncate")
	  ("w" whitespace-mode "whitespace")
	  ("q" nil "cancel"))))
(global-set-key
 (kbd "C-x j")
 (defhydra gotoline 
   (:pre (linum-mode 1)
	      :post (linum-mode -1))
   "goto"
   ("t" (move-to-window-line-top-bottom 0) "top")
   ("b" (move-to-window-line-top-bottom -2) "bottom")
   ("m" (move-to-window-line-top-bottom) "middle")
   ("e" (goto-char (point-max)) "end")
   ("c" recenter-top-bottom "recenter")
   ("n" next-line "down")
   ("p" (lambda () (interactive) (forward-line -1))  "up")
   ("g" goto-line "goto-line")
   ))
    ;;    (global-set-key
;;     (kbd "C-c t")
;;     (defhydra hydra-global-org (:color blue)
;;       "Org"
;;       ("t" org-timer-start "Start Timer")
;;       ("s" org-timer-stop "Stop Timer")
;;       ("r" org-timer-set-timer "Set Timer") ; This one requires you be in an orgmode doc, as it sets the timer for the header
;;       ("p" org-timer "Print Timer") ; output timer value to buffer
;;       ("w" (org-clock-in '(4)) "Clock-In") ; used with (org-clock-persistence-insinuate) (setq org-clock-persist t)
;;       ("o" org-clock-out "Clock-Out") ; you might also want (setq org-log-note-clock-out t)
;;       ("j" org-clock-goto "Clock Goto") ; global visit the clocked task
;;       ("c" org-capture "Capture") ; Don't forget to define the captures you want http://orgmode.org/manual/Capture.html
;;     ("l" (or )rg-capture-goto-last-stored "Last Capture"))
    
    

;; (defhydra multiple-cursors-hydra (:hint nil)
;;   "
;;      ^Up^            ^Down^        ^Other^
;; ----------------------------------------------
;; [_p_]   Next    [_n_]   Next    [_l_] Edit lines
;; [_P_]   Skip    [_N_]   Skip    [_a_] Mark all
;; [_M-p_] Unmark  [_M-n_] Unmark  [_r_] Mark by regexp
;; ^ ^             ^ ^             [_q_] Quit
;; "
;;   ("l" mc/edit-lines :exit t)
;;   ("a" mc/mark-all-like-this :exit t)
;;   ("n" mc/mark-next-like-this)
;;   ("N" mc/skip-to-next-like-this)
;;   ("M-n" mc/unmark-next-like-this)
;;   ("p" mc/mark-previous-like-this)
;;   ("P" mc/skip-to-previous-like-this)
;;   ("M-p" mc/unmark-previous-like-this)
;;   ("r" mc/mark-all-in-region-regexp :exit t)
;;   ("q" nil)

;;   ("<mouse-1>" mc/add-cursor-on-click)
;;   ("<down-mouse-1>" ignore)
;;   ("<drag-mouse-1>" ignore))


;; font zoom mode example taken from hydra wiki
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("+" text-scale-increase "in")
  ("-" text-scale-decrease "out")
  ("0" (text-scale-adjust 0) "reset")
  ("q" nil "quit" :color blue))

;;==============================================================================
;;.....javascript / HTML
;;     -----------------

;; (use-package js2-mode
;;   :config
;;   (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;;   (add-hook 'js2-mode-hook #'js2-imenu-extras-mode))

;; (use-package js2-refactor
  
;;   :config
;;   (add-hook 'js2-mode-hook #'js2-refactor-mode)
;;   ;; (js2-add-keybindings-with-prefix "C-c C-r") ;; Clash with ivy-resume
;;   (define-key js2-mode-map (kbd "C-k") #'js2r-kill)
;;   ;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;;   ;; unbind it.
;;   (define-key js-mode-map (kbd "M-.") nil))
  
;; (add-hook 'js2-mode-hook (lambda ()
;;                            (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

;; (use-package xref-js2)

;;==============================================================================
;;.....company mode
;;     ------------

(use-package company
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (global-company-mode 1))

(use-package company-irony
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package irony
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package irony-eldoc
  :config
  (add-hook 'irony-mode-hook #'irony-eldoc))

(use-package company-jedi
  :config
  (add-hook 'python-mode-hook 'jedi:setup))

(defun my/python-mode-hook ()
  "Python mode hook."
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

;;==============================================================================
;;.....magit
;;     -----

(use-package magit
  :init
  (progn
    (bind-key "C-c g" 'magit-status)
    ))

(use-package git-gutter
  
  :init
  (global-git-gutter-mode +1))

(global-set-key (kbd "M-g M-g") 'hydra-git-gutter/body)


(use-package git-timemachine)

(defhydra hydra-git-gutter (:body-pre (git-gutter-mode 1)
                                      :hint nil)
  "
Git gutter:
  _j_: next hunk        _s_tage hunk     _q_uit
  _k_: previous hunk    _r_evert hunk    _Q_uit and deactivate git-gutter
  ^ ^                   _p_opup hunk
  _h_: first hunk
  _l_: last hunk        set start _R_evision
"
  ("j" git-gutter:next-hunk)
  ("k" git-gutter:previous-hunk)
  ("h" (progn (goto-char (point-min))
              (git-gutter:next-hunk 1)))
  ("l" (progn (goto-char (point-min))
              (git-gutter:previous-hunk 1)))
  ("s" git-gutter:stage-hunk)
  ("r" git-gutter:revert-hunk)
  ("p" git-gutter:popup-hunk)
  ("R" git-gutter:set-start-revision)
  ("q" nil :color blue)
  ("Q" (progn (git-gutter-mode -1)
              ;; git-gutter-fringe doesn't seem to
              ;; clear the markup right away
              (sit-for 0.1)
              (git-gutter:clear))
   :color blue))

;;==============================================================================
;;.....flycheck
;;     --------

(use-package flycheck
  :init
  (global-flycheck-mode 1))

;;==============================================================================
;;.....all the icons
;;     -------------


;; If this configuration is being used on a new installation,
;; remember to run M-x all-the-icons-install-fonts
;; otherwise nothing will work
(use-package all-the-icons
  :config
  (use-package all-the-icons-dired
    :config
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)))

;;==============================================================================
;;.....themes
;;     ------

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox t))
;; Font size is localised in site-local.el
(defvar my:font (concat "Iosevka-" *pj/font-size* ":spacing=110"))
;; Font size setting for Emacs 27:
(set-face-attribute 'default nil :font my:font )
(set-frame-font my:font nil t)
;; Old font size setting:
;;(set-default-font my:font)
;;(set-frame-font my:font t)

;;==============================================================================
;;.....eyebrowse
;;     ---------

;; TODO: currently disabled - clash with org-refile needs to be resolved.
;;(use-package eyebrowse
;;  :ensure r
;;  :config
;;;;  (eyebrowse-setup-opinionated-keys) ;set evil keybindings (gt gT)
;;  (eyebrowse-mode t))

;;==============================================================================
;;.....Projectile
;;     ----------

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;;==============================================================================
;;.....powerline
;;     ---------

(use-package powerline
  :config
  (add-hook 'desktop-after-read-hook 'powerline-reset)
  (defun make-rect (color height width)
    "Create an XPM bitmap."
    (when window-system
      (propertize
       " " 'display
       (let ((data nil)
             (i 0))
         (setq data (make-list height (make-list width 1)))
         (pl/make-xpm "percent" color color (reverse data))))))
  (defun powerline-mode-icon ()
    (let ((icon (all-the-icons-icon-for-buffer)))
      (unless (symbolp icon) ;; This implies it's the major mode
        (format " %s"
                (propertize icon
                            'help-echo (format "Major-mode: `%s`" major-mode)
                            'face `(:height 1.2 :family ,(all-the-icons-icon-family-for-buffer)))))))
  (defun powerline-modeline-vc ()
    (when vc-mode
      (let* ((text-props (text-properties-at 1 vc-mode))
             (vc-without-props (substring-no-properties vc-mode))
             (new-text (concat
                        " "
                        (all-the-icons-faicon "code-fork"
                                              :v-adjust -0.1)
                        vc-without-props
                        " "))
             )
        (apply 'propertize
               new-text
               'face (when (powerline-selected-window-active) 'success)
               text-props
               ))))
  (defun powerline-buffer-info ()
    (let ((proj (projectile-project-name)))
      (if (string= proj "-")
          (buffer-name)
        (concat
         (propertize (concat
                      proj)
                     'face 'warning)
         " "
         (buffer-name)))))
  (defun powerline-ace-window () (propertize (or (window-parameter (selected-window) 'my-ace-window-path) "") 'face 'error))
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (modified (buffer-modified-p))
                          (face1 (if active 'powerline-active1 'powerline-inactive1))
                          (face2 (if active 'powerline-active2 'powerline-inactive2))
                          (bar-color (cond ((and active modified) (face-foreground 'error))
                                           (active (face-background 'cursor))
                                           (t (face-background 'tooltip))))
                          (lhs (list
                                (make-rect bar-color 30 3)
                                (when modified
                                  (concat
                                   " "
                                   (all-the-icons-faicon "floppy-o"
                                                         :face (when active 'error)
                                                         :v-adjust -0.01)))
                                " "
                                (powerline-buffer-info)
                                " "
                                (powerline-modeline-vc)
                                ))
                          (center (list
                                   " "
                                   (powerline-mode-icon)
                                   " "
                                   ;;major-mode
                                   (powerline-major-mode)
                                   " "))
                          (rhs (list
                                (powerline-ace-window)
                                " | "
                                ;;   (format "%s" (eyebrowse--get 'current-slot))
                                ;;   " | "
                                (powerline-raw "%l:%c" face1 'r)
                                " | "
                                (powerline-raw "%6p" face1 'r)
                                (powerline-hud 'highlight 'region 1)
                                " "
                                ))
                          )
                     (concat
                      (powerline-render lhs)
                      (powerline-fill-center face1 (/ (powerline-width center) 2.0))
                      (powerline-render center)
                      (powerline-fill face2 (powerline-width rhs))
                      (powerline-render rhs)))))))

(use-package diminish)

;;==============================================================================
;;.....Paredit
;;     -------

(use-package paredit
  :diminish paredit-mode
  :config
  (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  :bind (("C-c d" . paredit-forward-down))) 

;; Ensure paredit is used EVERYWHERE!
(use-package paredit-everywhere
  :ensure t
  :diminish paredit-everywhere-mode
  :config
  (add-hook 'lisp-mode-hook #'paredit-everywhere-mode))
;;-------------
;; (use-package highlight-parentheses
;;   
;;   :diminish highlight-parentheses-mode
;;   :config
;;   (add-hook 'emacs-lisp-mode-hook
;;             (lambda()
;;               (highlight-parentheses-mode))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  (add-hook 'lisp-mode-hook
            (lambda()
              (rainbow-delimiters-mode))))

;;(global-highlight-parentheses-mode)

;;==============================================================================
;;.....Clojure
;;     -------

(add-hook 'clojure-mode-hook 'enable-paredit-mode)

(use-package cider
  :config
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-mode-hook #'cider-hydra-mode)
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (setq cider-repl-use-pretty-printing t)
  (setq cider-repl-display-help-banner nil)
  (setq cider-default-cljs-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

  :bind (("M-r" . cider-namespace-refresh)
         ("C-c r" . cider-repl-reset)
         ("C-c ." . cider-reset-test-run-tests)))


;; (use-package clj-refactor
;;   
;;   :config
;;   (add-hook 'clojure-mode-hook (lambda ()
;;                                  (clj-refactor-mode 1)
;;                                  ;; insert keybinding setup here
;;                                  ))
;;   (cljr-add-keybindings-with-prefix "C-c C-m")
;;   (setq cljr-warn-on-eval nil)
;;   :bind ("C-c '" . hydra-cljr-help-menu/body)
;;   )

(use-package cider-hydra
  :ensure t)

;;==============================================================================
;;.....lisp - slime
;;     ------------

;; shamelessly copied from 
;; https://github.com/ajukraine/ajukraine-dotemacs/blob/master/aj/rc-modes/init.el
;; 17/11/2018

(use-package slime
;;  :load-path (expand-site-lisp "slime")
  :commands slime
  :config

  (progn
    (add-hook
     'slime-load-hook
     #'(lambda ()
         (slime-setup
          '(slime-fancy
            slime-repl
            slime-fuzzy))))
    (setq slime-net-coding-system 'utf-8-unix)
    (setq inferior-lisp-program "/usr/bin/sbcl")
    (load (expand-file-name "~/quicklisp/slime-helper.el"))
    (setq slime-lisp-implementations '((sbcl ("/usr/bin/sbcl"))))
    
    (use-package ac-slime
      :init
      (progn
        (add-hook 'slime-mode-hook 'set-up-slime-ac)
        (add-hook 'slime-repl-mode-hook 'set-up-slime-ac))
      :config
      (progn
        (eval-after-load "auto-complete"
          '(add-to-list 'ac-modes 'slime-repl-mode))))))

;;==============================================================================
;;.....elisp - slime
;;     -------------

(use-package elisp-slime-nav
  :config
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook #'elisp-slime-nav-mode)))

;;==============================================================================
;;.....mu4e
;;     ----


(when *pj/enable-mu4e-mode*
  (require 'mu4e)
  
  (use-package mu4e
    :ensure nil
    :defer 20
    :config

    (require 'org-mu4e)
    
    (auth-source-pass-enable)
    (setq auth-source-debug t) ;;...temporarily...
    (setq auth-source-do-cache nil)
    (setq auth-sources '(password-store))
    
    (setq message-kill-buffer-on-exit t)
    ;; Need to be 't' to avoid mail syncing issues
    (setq mu4e-change-filenames-when-moving t)
    
    ;; Refresh mail every 10 minutes - using isync
    (setq mu4e-update-interval (* 10 60))
    (setq mu4e-get-mail-command "mbsync -a")
    (setq mu4e-maildir "~/Mail")
    
    (setq smtpmail-debug-info t)
    (setq smtpmail-debug-verb t)
    (setq smtpmail-stream-type 'tls)
    
    (defun sign-or-encrypt-message ()
      "Check whether the message should be encrypted and/or signed."
      (let ((answer (read-from-minibuffer "Sign or encrypt?\nEmpty to do nothing.\n[s/e]: ")))
        (cond
         ((string-equal answer "s") (progn
                                      (message "Signing message.")
                                      (mml-secure-message-sign-pgpmime)))
         ((string-equal answer "e") (progn
                                      (message "Encrypting and signing message.")
                                      (mml-secure-message-encrypt-pgpmime)))
         (t (progn
              (message "Don't sign or encrypt message.")
              nil)))))
    
    (add-hook 'message-send-hook 'sign-or-encrypt-message) 
    
    (setq mu4e-contexts
          `(,(make-mu4e-context
              ;; Personal account
              :name "home"
              :enter-func (lambda ()
                            (mu4e-message "Entering home context")
                            (when (string-match-p (buffer-name (current-buffer)) "mu4e-main")
                              (revert-buffer)))
              :leave-func (lambda ()
                            (mu4e-message "Leaving home context")
                            (when (string-match-p (buffer-name (current-buffer)) "mu4e-main")
                              (revert-buffer)))
              :match-func (lambda (msg)
                            (when msg
                              (string-prefix-p "/teulu.org" (mu4e-message-field msg :maildir))))
              :vars
              `((user-mail-address . "paul@teulu.org")
                (user-full-name . "Paul Jewell")
                (mu4e-drafts-folder . "/teulu.org/Drafts")
                (mu4e-sent-folder . "/teulu.org/Sent")
                (mu4e-refile-folder . ,(concat "/teulu.org/Archive/" (format-time-string "%Y")))
                (mu4e-trash-folder . "/teulu.org/Trash")
                (smtp-queue-dir . "~/.email/teulu.org/queue/cur")
                (smtpmail-smtp-server . "mail.teulu.org")
                (smtpmail-smtp-user . "paul@teulu.org")
                (smtpmail-smtp-server . "mail.teulu.org")
                (smtpmail-smtp-service . 465)
                (mu4e-sent-messages-behavior . sent)
                (mu4e-bookmarks .
                                ((:name "Inbox"
                                        :query "maildir:/teulu.org/Inbox"
                                        :key ?a)
                                 (:name "Unread"
                                        :query "maildir:/teulu.org/Inbox AND flag:unread AND NOT flag:trashed"
                                        :key ?u)))))
            ,(make-mu4e-context
              ;; Applied-jidoka work email
              :name "work"
              :enter-func (lambda ()
                            (mu4e-message "Entering work context")
                            (when (string-match-p (buffer-name (current-buffer)) "mu4e-main")
                              (revert-buffer)))
              :leave-func (lambda ()
                            (mu4e-message "Leaving work context")
                            (when (string-match-p (buffer-name (current-buffer)) "mu4e-main")
                              (revert-buffer)))
              :match-func (lambda (msg)
                            (when msg
                              (string-prefix-p "/applied-jidoka.co.uk" (mu4e-message-field msg :maildir))))
              :vars
              `((user-mail-address . "paul@applied-jidoka.co.uk")
                (user-full-name . "Paul Jewell")
                (mu4e-drafts-folder . "/applied-jidoka.co.uk/Drafts")
                (mu4e-sent-folder . "/applied-jidoka.co.uk/Sent")
                (mu4e-refile-folder . ,(concat "/applied-jidoka.co.uk/Archive/" (format-time-string "%Y")))
                (mu4e-trash-folder . "/applied-jidoka.co.uk/Trash")
                (smtp-queue-dir . "~/.email/applied-jidoka.co.uk/queue/cur")
                (smtpmail-smtp-server . "mail.applied-jidoka.co.uk")
                (smtpmail-smtp-user . "paul@applied-jidoka.co.uk")
                (smtp-smtp-service . 465)
                (mu4e-sent-messages-behavior . sent)
                (mu4e-bookmarks .
                                ((:name "Inbox"
                                        :query "maildir:/applied-jidoka.co.uk/Inbox"
                                        :key ?a)
                                 (:name "Unread"
                                        :query "maildir:/applied-jidoka.co.uk/Inbox AND flag:unread AND NOT flag:trashed"
                                        :key ?u)))))))))
(setq pj/mu4e-inbox-query
        "(maildir:/Personal/Inbox OR maildir:/work/inbox) AND flag:unread")

(use-package mu4e-alert
  :after mu4e
  :config
  ;; Show unread emails from all inboxes
  (setq mu4e-alert-interesting-mail-query pj/mu4e-inbox-query)

  ;; Show notifications for mails already notified
  (setq mu4e-alert-notify-repeated-mails nil)

  (mu4e-alert-enable-notifications))

(use-package org-caldav
  
  :config
  (setq org-caldav-url "https://nextcloud.applied-jidoka.com/remote.php/dav/calendars/paul")
  (setq org-caldav-calendars
        '(,(:calendar-id "caldav-org-test"
                         :files (concat (file-name-as-directory *pj/org-directory*) "caldav-org-test.org")
                         :inbox "~/Calendars/caldav-org-inbox.org")))
  (setq org-caldav-backup-file "~/org-caldav-backup.org")
  (setq org-caldav-save-directory "~/org-caldav/")
  (setq org-icalendar-timezone "Europe/London"))

;;==============================================================================
;;.....helpful
;;     -------

(use-package helpful
  
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Following the ELPA instructions didn't work as expected - came across
;; this approach, which does work. See also changes in gpg-agent.conf
(setq epa-pinentry-mode 'loopback)

;;==============================================================================
;;.....ERC
;;     ---
;; thank you bbatsov - for sharing your code for ERC config.

(require 'erc)
(require 'erc-log)
(require 'erc-notify)
(require 'erc-spelling)
(require 'erc-autoaway)


;; (setq erc-autojoin-channels-alist '(("freenode.net"
;;                                     "#emacs"
;;                                     "#gentoo" "#guile"
;;                                     "#lisp" "#clojure" "#scheme"))

(setq erc-autojoin-channels-alist '(("libera.chat"
                                     "#guix"
                                     "#nonguix"
                                     "#emacs"
                                     "#gentoo"
                                     "#guile"
                                     "#lisp"
                                     "#clojure"
                                     "#scheme")))

;; Interpret mIRC-style colour commands in IRC chats
(setq erc-interpret-mirc-color t)

;; Kill buffers for channels after /part
(setq erc-kill-buffer-on-part t)
;; kill buffers for private queries after quiting the server
(setq erc-kill-queries-on-quit t)
;; Kill buffers for server messages after quitting the server
(setq erc-kill-server-buffer-on-quit t)
;; open query buffers in the current window
(setq erc-query-display 'buffer)

;; exclude boring stuff from tracking
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))

;; logging
(setq erc-log-channels-directory "~/.erc/logs/")

(if (not (file-exists-p erc-log-channels-directory))
    (mkdir erc-log-channels-directory t))

(setq erc-save-buffer-on-part t)
;; (defadvice save-buffers-kill-emacs (before save-logs (arg) activate)
;;   (save-some-buffers t (lambda () (when (eq major-mode 'erc-mode) t))))

;; truncate long irc buffers
(erc-truncate-mode +1)

;; share my real name
(setq erc-user-full-name "Paul Jewell")

;; enable spell checking
(erc-spelling-mode 1)

;; set different dictionaries by different servers/channels
;;(setq erc-spelling-dictionaries '(("#emacs" "american")))
(defun clean-message (s)
  "Clean up message S for notification function."
  (let* ((s (replace-regexp-in-string ">" "&gt;" s))
         (s (replace-regexp-in-string "<" "&lt;" s))
         (s (replace-regexp-in-string "&" "&amp;" s))
         (s (replace-regexp-in-string "\"" "&quot;" s))))
  (replace-regexp-in-string "'" "&apos;" s))

;; TODO - replace this with use of notify.el
;; Notify my when someone mentions my nick.
(defun call-libnotify (matched-type nick msg)
  "Notify when NICK is mentioned in MSG (MATCHED-TYPE)."
  (let* ((cmsg  (split-string (clean-message msg)))
         (nick   (first (split-string nick "!")))
         (msg    (mapconcat 'identity (rest cmsg) " ")))
    (shell-command-to-string
     (format "notify-send -t 5000 -u normal '%s says:' '%s'" nick msg))))

(add-hook 'erc-text-matched-hook 'call-libnotify)

(defvar erc-notify-nick-alist nil
  "Alist of nicks and the last time they tried to trigger a
notification.")

(defvar erc-notify-timeout 10
  "Number of seconds that must elapse between notifications from
the same person.")

(defun erc-notify-allowed-p (nick &optional delay)
  "Return non-nil if a notification should be made for NICK.
If DELAY is specified, it will be the minimum time in seconds
that can occur between two notifications.  The default is
`erc-notify-timeout'."
  (unless delay (setq delay erc-notify-timeout))
  (let ((cur-time (time-to-seconds (current-time)))
        (cur-assoc (assoc nick erc-notify-nick-alist))
        (last-time nil))
    (if cur-assoc
        (progn
          (setq last-time (cdr cur-assoc))
          (setcdr cur-assoc cur-time)
          (> (abs (- cur-time last-time)) delay))
      (push (cons nick cur-time) erc-notify-nick-alist)
      t)))

;; private message notification
(defun erc-notify-on-private-msg (proc parsed)
  "Notify when private message is received (PROC PARSED)."
  (let ((nick (car (erc-parse-user (erc-response.sender parsed))))
        (target (car (erc-response.command-args parsed)))
        (msg (erc-response.contents parsed)))
    (when (and (erc-current-nick-p target)
               (not (erc-is-message-ctcp-and-not-action-p msg))
               (erc-notify-allowed-p nick))
      (shell-command-to-string
       (format "notify-send -t 5000 -u normal '%s says:' '%s'" nick msg))
      nil)))

(add-hook 'erc-server-PRIVMSG-functions 'erc-notify-on-private-msg)

;; autoaway setup
(setq erc-auto-discard-away t)
(setq erc-autoaway-idle-seconds 600)
(setq erc-autoaway-idle-method 'emacs)

;; auto identify
;; (when (file-exists-p (expand-file-name "~/.ercpass"))
;;   (load "~/.ercpass")
;;   (require 'erc-services)
;;   (erc-services-mode 1)
;;   (setq erc-prompt-for-password nil))
  ;; (setq erc-nickserv-passwords
  ;;       `((freenode (("paulj" . ,paulj-pass))))))

;; utf-8 always and forever
(setq erc-server-coding-system '(utf-8 . utf-8))

(defun start-irc ()
  "Connect to IRC."
  (interactive)
  (when (y-or-n-p "Do you want to start IRC? ")
    (erc :server "irc.libera.chat" :port 6667 :nick "paul_j")))

(defun filter-server-buffers ()
  (delq nil
        (mapcar
         (lambda (x) (and (erc-server-buffer-p x) x))
         (buffer-list))))

(defun stop-irc ()
  "Disconnects from all irc servers."
  (interactive)
  (dolist (buffer (filter-server-buffers))
    (message "Server buffer: %s" (buffer-name buffer))
    (with-current-buffer buffer
      (erc-quit-server "Asta la vista"))))

;;==============================================================================
;;.....toc-org
;;     -------

(use-package toc-org
  :config
  (add-hook 'org-mode-hook 'toc-org-mode)

  ;; enable in markdown as well
  (add-hook 'markdown-mode-hook 'toc-org-mode))

;;==============================================================================
;;.....Ox-Hugo
;;     -------

(use-package ox-hugo
  :after ox)

(put 'narrow-to-region 'disabled nil)

(provide 'init)
;;; init.el ends here

;;==============================================================================
;;.....Guix and Guile
;;     --------------

(if (pj/is-guix-p)
    (progn
      (use-package flycheck-guile)
      (use-package guix)
      (use-package geiser
        :custom
        (geiser-active-implementations '(guile)))
      (add-hook 'scheme-mode-hook 'guix-devel-mode)))

;;==============================================================================
;;.....Auto tangle configuration files
;;     -------------------------------

(defun pj/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name "~/dotfiles/"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))


(add-hook 'org-mode-hook 
          (lambda () 
            (add-hook 'after-save-hook
                      #'pj/org-babel-tangle-config)))
