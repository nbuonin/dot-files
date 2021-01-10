;;; Startup improvements
;;;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;;;; Fonts
(column-number-mode 1)
(when (eq system-type 'darwin)
  (set-face-font 'default "-*-Menlo-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))
;;;; Don't dump custom variables into init.el
;; (setq custom-file "~/.emacs.d/custom.el")
;; (load custom-file)

;;;; Bootstrap package management
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
	"straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;; Saner defaults
(setq-default
 ring-bell-function               'ignore ;; Stop ringing bell
 sentence-end-double-space        nil	  ; I prefer single space
 )

(defalias 'yes-or-no-p #'y-or-n-p)

;; Lifted from technomancy's better-defaults package
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(require 'saveplace)
(setq-default save-place t)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(show-paren-mode 0)
(setq-default indent-tabs-mode nil)
(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally
      save-place-file (concat user-emacs-directory "places")
      auto-save-default nil
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
(global-auto-revert-mode t)

;;; Core editor facilities
;; This sets up basic text editing commands, e.g. evil
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-want-minibuffer t)
  (setq evil-disable-insert-state-bindings t)
  :config
  (evil-mode 1))

(use-package evil-escape
  :after evil
  :config
  (evil-escape-mode 1)
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2))

(use-package evil-collection
  :after evil
  :custom (evil-collection-setup-minibuffer t)
  :init
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode))

(use-package evil-goggles
  :config
  (evil-goggles-mode)
  (setq evil-goggles-blocking-duration 0.010))

(use-package evil-exchange
  :after evil
  :config
  (evil-exchange-install))

(use-package evil-unimpaired
  :after evil
  :straight (evil-unimpaired :host github :repo "zmaas/evil-unimpaired"))

;;; Mac specific
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (setenv "SHELL" "/bin/bash")
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-envs '("PATH"))))

;; Use command as meta on mac
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)))

;;; Visual improvements
(use-package eshell-git-prompt
  :config
  (eshell-git-prompt-use-theme 'powerline))
(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode))

(global-linum-mode t)
;(when (version<= "26.0.50" emacs-version)
  ;(add-hook 'prog-mode-hook 'display-line-numbers-mode))

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

;; Modeline
(use-package doom-modeline
  :hook (after-init . doom-modeline-init)
  :config
  (setq doom-modeline-height 70)
  (setq doom-modeline-bar-width 4))

;;; Interface management (stuff that makes it easier to remember keybindings and commands)
(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-show-operator-state-maps t)
  (setq which-key-idle-delay 0.3))

;; Ivy (taken from "How to make your own Spacemacs")
(use-package ivy-hydra)
(use-package wgrep
  :commands
  (wgrep-change-to-wgrep-mode))

(use-package ivy
  :init (ivy-mode 1)                  ; enable ivy globally at startup
  :config
  (setq ivy-use-virtual-buffers t) ; extend searching to bookmarks and …
  (setq ivy-height 10)             ; set height of the ivy window
  (setq ivy-count-format "(%d/%d) ") ; count format, from the ivy help page
  (define-key ivy-minibuffer-map "\C-j" 'ivy-next-line)
  (define-key ivy-minibuffer-map "\C-k" 'ivy-previous-line)
  (define-key ivy-minibuffer-map (kbd "C-SPC") 'ivy-toggle-fuzzy))

(use-package ivy-rich
  :after (counsel)
  :config (ivy-rich-mode 1))

;; Counsel (same as Ivy above)
(use-package counsel
  :init
  (counsel-mode 1)
  :commands      ; Load counsel when any of these commands are invoked
  (counsel-M-x   ; M-x use counsel
   counsel-find-file          ; C-x C-f use counsel-find-file
   counsel-recentf            ; search recently edited files
   counsel-git                ; search for files in git repo
   counsel-git-grep           ; search for regexp in git repo
   counsel-ag                 ; search for regexp in git repo using ag
   counsel-locate             ; search for files or else using locate
   counsel-rg)                ; search for regexp in git repo using
  :config
  (setq counsel-rg-base-command
	    "rg -i -M 120 --follow --glob \"!.git/*\" --no-heading --ignore-case\
      --line-number --column --color never %s ."))
;; Remeber searches
(use-package prescient
  :config (prescient-persist-mode))
(use-package ivy-prescient
  :config (ivy-prescient-mode))

;;; Autocompletion
;;;; Company
(use-package company
  :hook (prog-mode . company-mode)
  :config
  (company-tng-configure-default)
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.1))

;; Add fuzzy backend to company
(use-package company-flx
  :after company
  :config
  (with-eval-after-load 'company
    (company-flx-mode +1))
  (setq company-flx-limit 250))

;; Remember completions
(use-package company-prescient
  :config (company-prescient-mode))

;; https://emacs.stackexchange.com/questions/10431/get-company-to-show-suggestions-for-yasnippet-names
;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  "Add yasnippets to a company mode BACKEND."
  (if (or (not company-mode/enable-yas)
	  (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))


;;; Language Server Protocol


;;;; Snippets
;; Yasnipet
(use-package yasnippet
  :config
  (yas-global-mode 1)
  (global-set-key (kbd "C-c s") 'company-yasnippet))

;;; Project management
;;;; Magit
(use-package magit
  :commands (magit-status)
  :config
  ;; Stolen from magnars whattheemacs.d
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  (defun magit-quit-session ()
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen))
  :bind (:map magit-status-mode-map
              ("q" . magit-quit-session)))

(use-package evil-magit
  :after magit
  :config
  (add-hook 'with-editor-mode-hook 'evil-insert-state))

(use-package git-timemachine
  :commands (git-timemachine))

(use-package projectile
  :config
  (projectile-mode 1)
  (setq projectile-completion-system 'ivy))
(use-package counsel-projectile
  :commands (counsel-projectile projectile-find-file)
  :after (projectile counsel)
  :config (counsel-projectile-mode))

;;; General programming concerns
;;;; Parentheses
(electric-pair-mode 1)
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;;;; Linting
(use-package flycheck)

;;;; Formatting
(use-package format-all
  :commands (format-all-buffer))

(use-package evil-nerd-commenter
  :after evil
  :commands (evilnc-comment-or-uncomment-lines))

;;; Language specific programming concerns
;;;; Javascript (idk)

;;;; Python
(use-package anaconda-mode
  :hook (python-mode . anaconda-mode)
  (python-mode . anaconda-eldoc-mode))
(use-package company-anaconda
  :config
  (eval-after-load "company"
    '(add-to-list 'company-backends '(company-anaconda :with company-capf))))

;;;; C
(use-package cc-mode
  :custom (c-basic-offset 2)
  :mode (("\\.mc\\'" . c-mode)))        ; loads c-mode for microc files

;;;; Ocaml
(use-package tuareg)
;; Ocaml's tooling doesn't get installed by emacs or in the same place for everyone
;; so we have a bunch of code to find the correct paths for everything
(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share"))))
      (ocamlmerlin-command (ignore-errors (car (process-lines "which" "ocamlmerlin")))))
  (when (and opam-share ocamlmerlin-command (file-directory-p opam-share))
    (use-package merlin
      :straight (merlin
                 :local-repo (expand-file-name "emacs/site-lisp" opam-share)
                 :files ("merlin*.elc"))
      :config
      (add-hook 'tuareg-mode-hook 'merlin-mode)
      (add-hook 'caml-mode-hook 'merlin-mode)
      (setq merlin-error-after-save nil)
      (setq merlin-command ocamlmerlin-command))))

(use-package flycheck-ocaml
  :config
  (flycheck-ocaml-setup)
  (add-hook 'tuareg-mode-hook 'flycheck-mode))


;;;; Haskell
(use-package haskell-mode
  :hook (haskell-mode . haskell-decl-scan-mode))

(use-package intero
  :after haskell-mode
  :hook (haskell-mode . intero-mode)
  :config (flycheck-add-next-checker 'intero '(warning . haskell-hlint)))

;;;; Idris
(use-package idris-mode)

;;;; Rust
(use-package rust-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
  (projectile-register-project-type 'rust-cargo '("Cargo.toml")
                                    :compile "cargo build"
                                    :test "cargo test"
                                    :run "cargo run"))

(use-package flycheck-rust
  :after (flycheck rust-mode)
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package racer
  :after (rust-mode company)
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode))

;;;; Yaml
(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  :hook
  (yaml-mode . ryo-modal-mode))

;;;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;;;; Lilypond
(when (and (executable-find "lilypond") (eq system-type 'darwin))
  (use-package lilypond-mode
    :straight
    (:local-repo "/usr/local/Cellar/lilypond/2.18.2/share/emacs/site-lisp/lilypond/"
                 :files ("lilypond*.el"))
    :config
    (add-to-list 'auto-mode-alist '("\\.ly\\'" . LilyPond-mode))))

;;; Kitchen sink
;;;; Pdf
;; Stolen from doom
(use-package pdf-tools
  :preface
  (defun +pdf|cleanup-windows ()
    "Kill left-over annotation buffers when the document is killed."
    (when (buffer-live-p pdf-annot-list-document-buffer)
      (pdf-info-close pdf-annot-list-document-buffer))
    (when (buffer-live-p pdf-annot-list-buffer)
      (kill-buffer pdf-annot-list-buffer))
    (let ((contents-buffer (get-buffer "*Contents*")))
      (when (and contents-buffer (buffer-live-p contents-buffer))
        (kill-buffer contents-buffer))))
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (unless noninteractive (pdf-tools-install))
  (add-hook 'pdf-view-mode-hook
            (add-hook 'kill-buffer-hook #'+pdf|cleanup-windows nil t))
  (setq-default pdf-view-display-size 'fit-page)
  :bind (:map pdf-view-mode-map
              ("q" . kill-this-buffer)))
