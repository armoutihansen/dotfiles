;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(set-frame-parameter (selected-frame) 'alpha '(95 . 95))
 (add-to-list 'default-frame-alist '(alpha . (95 . 95)))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jesper Armouti-Hansen"
      user-mail-address "jesper@armoutihansen.xyz")

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
 (setq doom-font (font-spec :family "monospace" :size 27 :weight 'semi-light)
       doom-variable-pitch-font (font-spec :family "sans" :size 27))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-palenight)
;; (custom-set-faces
;;  '(default ((t (:background "#282A36"))))
;;  )

;; (setq doom-leader-key ",")

(setq confirm-kill-emacs nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


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
(use-package conda
  :ensure t
  :init
  (setq conda-anaconda-home (expand-file-name "~/.config/miniconda3"))
  (setq conda-env-home-directory (expand-file-name "~/.config/miniconda3")))

(add-hook! '+org-babel-load-functions
  (defun +org-babel-load-jupyter-h (lang)
    (and (string-prefix-p "jupyter-" (symbol-name lang))
         (require 'ob-jupyter)
         (require lang nil t))))

;; (use-package org-super-agenda
;;   :after org-agenda
;;   :init
;;   (setq org-super-agenda-groups '((:name "Today"
;;                                    :time-grid t
;;                                    :scheduled today)
;;                                   (:name "Due today"
;;                                    :deadline today)
;;                                   (:name "Important"
;;                                    :priority "A")
;;                                   (:name "Overdue"
;;                                    :deadline past)
;;                                   (:name "Due soon"
;;                                    :deadline future)
;;                                   (:name "Big Outcomes"
;;                                    :tag "bo")))
;;   :config
;;   (org-super-agenda-mode)
;;   )

;; (setq ein:output-area-inlined-images t)

;; (after! org
;;   (map! :map org-mode-map
;;         :n "M-j" #'org-metadown
;;         :n "M-k" #'org-metaup))

(use-package interleave)
