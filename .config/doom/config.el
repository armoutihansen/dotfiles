;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(set-frame-parameter (selected-frame) 'alpha '(100 . 100))
 (add-to-list 'default-frame-alist '(alpha . (100 . 100)))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jesper Armouti-Hansen"
      user-mail-address "jesper@armouti-hansen.xyz")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Mononoki Nerd Font" :size 27)
      doom-big-font (font-spec :family "Mononoki Nerd Font" :size 36)
      doom-variable-pitch-font (font-spec :family "Mononoki Nerd Font" :size 18))

(map!
  (:after dired
    (:map dired-mode-map
     "C-x i" #'peep-dired
     )))
(evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file
                                             (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)
(setq treemacs-width 32)

(setq +latex-viewers '(pdf-tools))

(setq confirm-kill-emacs nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)

(setq evil-split-window-below t
      evil-vsplit-window-right t)

(use-package emojify
  :hook (after-init . global-emojify-mode))
(add-hook 'after-init-hook #'global-emojify-mode)
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(use-package conda
  :ensure t
  :init
  (setq conda-anaconda-home (expand-file-name "~/.config/miniconda3"))
  (setq conda-env-home-directory (expand-file-name "~/.config/miniconda3")))

(setq ein:output-area-inlined-images t)
(setq ein:worksheet-enable-undo t)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

(setq org-hide-emphasis-markers t)

(use-package! org-superstar
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

(after! org
  (set-face-attribute 'org-level-1 nil
                      :background nil
                      :height 1.2
                      :weight 'normal)
  (set-face-attribute 'org-document-title nil
                      :background nil
                      :height 1.75
                      :weight 'bold))
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 3.0))

(use-package! org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :init
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(setq org-agenda-span 7)

(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:name "Today"
                                   :time-grid t
                                   :scheduled today)
                                  (:name "Due today"
                                   :deadline today)
                                  (:name "Important"
                                   :priority "A")
                                  (:name "Overdue"
                                   :deadline past)
                                  (:name "Due soon"
                                   :deadline future)
                                  (:name "Big Outcomes"
                                   :tag "bo"))
        org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "STRT(s)" "WAIT(w)" "HOLD(h)" "APPT(a)" "|" "DONE(d)" "KILL(k)") (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
         ))
  :config
  (org-super-agenda-mode)
  )
(setq org-agenda-files (quote ("~/Dropbox/org/")))

(require 'calfw-org)

(require 'org-alert)

(use-package! org-wild-notifier
  :after org-agenda
  :init
  :config
  (setq alert-default-style 'libnotify
        org-wild-notifier-notification-title "Schedule")
  (org-wild-notifier-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "912cac216b96560654f4f15a3a4d8ba47d9c604cbc3b04801e465fb67a0234f0" default))
 '(package-selected-packages '(org-superstar conda)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
