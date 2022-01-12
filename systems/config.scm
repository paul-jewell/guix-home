;; System configuration for qemu based guix system
;; Hostname: mercury
;; Developed from the system generated config.

(use-modules (gnu)
	     (gnu packages admin)
	     (gnu packages certs)
	     (gnu packages emacs)
	     (gnu packages emacs-xyz)
	     (gnu packages version-control))

(use-service-modules desktop networking ssh xorg)

(operating-system
 (locale "en_GB.utf8")
 (timezone "Europe/London")
 (keyboard-layout (keyboard-layout "gb" "extd"))
 (host-name "mercury")
 (users (cons* (user-account
                (name "paul")
                (comment "Paul Jewell")
                (group "users")
                (home-directory "/home/paul")
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))
 (packages
  (append
   (list nss-certs
	 emacs
	 emacs-guix
	 git)
   %base-packages))
 (services
  (append
   (list (service xfce-desktop-service-type)
         (service enlightenment-desktop-service-type)
         (service openssh-service-type)
         (set-xorg-configuration
          (xorg-configuration
           (keyboard-layout keyboard-layout))))
   %desktop-services))
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets (list "/dev/sda"))
   (keyboard-layout keyboard-layout)))
 (swap-devices
  (list (swap-space
	 (target (uuid "2cb4b997-8b28-4a30-9bcb-e042ad48c964")))))
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device
           (uuid "3e63b27e-2906-45c8-a6eb-35b2a8d91d2a"
                 'ext4))
          (type "ext4"))
         %base-file-systems)))
