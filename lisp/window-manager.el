;; To silence warnings about missing functions at runtime
(eval-when-compile
  (setq use-package-expand-minimally byte-compile-current-file))

(use-package exwm
  :preface
    (defun increase-brightness ()
    (interactive)
    (start-process-shell-command "brightness" nil "xbacklight -inc 5"))
  (defun decrease-brightness ()
    (interactive)
    (start-process-shell-command "brightness" nil "xbacklight -dec 5"))

  :config

  (require 'exwm-randr)
  (setq exwm-randr-workspace-output-plist '(1 "HDMI1"))
  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
	      (start-process-shell-command
	       "xrandr" nil "xrandr --output HDMI1 --auto")))
  (exwm-randr-enable)

  (require 'exwm-input) ; To silence warning about set-local-sim...
  (defun firefox-hook ()
    (when (and exwm-class-name
	       (string= exwm-class-name "Firefox"))
      (exwm-input-set-local-simulation-keys
       '(([?\C-b] . [left])
	 ([?\C-f] . [right])
	 ([?\C-p] . [up])
	 ([?\C-n] . [down])
	 ([?\M-v] . [prior])
	 ([?\C-v] . [next])
	 ([?\C-d] . [delete])
	 ([?\C-k] . [S-end delete])
	 ([?\C-s] . ?\C-f) ; find
	 ([?\M-w] . ?\C-c) ; copy
	 ([?\C-y] . ?\C-v) ; paste
	 ([?\M-<] . [home])
	 ([?\M->] . [end])
	 ([?\C-g] . [esc]) ; TODO: [EXWM] Invalid key: <esc>
	 ;; ([?\C-l] . ?\M-left) ; Go back
	 ;; ([?\C-r] . ?\M-right) ; Go forward
	 ))))
  (add-hook 'exwm-manage-finish-hook #'firefox-hook)

  (use-package windmove
    :config
    (exwm-input-set-key (kbd "s-h") #'windmove-left)
    (exwm-input-set-key (kbd "s-j") #'windmove-down)
    (exwm-input-set-key (kbd "s-k") #'windmove-up)
    (exwm-input-set-key (kbd "s-l") #'windmove-right))
  (exwm-input-set-key (kbd "s-;") #'other-frame)
  (exwm-input-set-key (kbd "<XF86MonBrightnessUp>") #'increase-brightness)
  (exwm-input-set-key (kbd "<XF86MonBrightnessDown>") #'decrease-brightness)
  ;;(setq exwm-workspace-minibuffer-position 'bottom) ; Hide minibuffer when idle
  (require 'exwm-config)
  (exwm-config-default)

  ;; TODO move this to when the first frame is created
  ;;(async-shell-command "compton --config ~/.config/compton.conf" "*compton*")

  ;; Enable moving of windows to other workspaces
  (setq exwm-workspace-show-all-buffers t
	exwm-layout-show-all-buffers t))

(use-package symon
  :config
  (setq symon-monitors '(symon-linux-memory-monitor
			 symon-linux-cpu-monitor
			 symon-linux-battery-monitor
			 symon-current-time-monitor))
  (symon-mode))
