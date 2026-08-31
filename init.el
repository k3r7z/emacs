;; ==========================================
;; 1. BASIC UI SETTINGS
;; ==========================================
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(hl-line-mode t)
(blink-cursor-mode nil)
(setq truncate-lines nil)

;; --- LINE NUMBERING ---
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

;; --- FONT ---
(set-frame-font "JetBrainsMono Nerd Font Mono-12" nil t)

;; ==========================================
;; 2. PACKAGE MANAGEMENT & BACKUPS
;; ==========================================
(require 'package)
(setq package-archives '(
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Centralize all backup files to keep project directories clean
(defvar my-backup-dir (expand-file-name "backups/" user-emacs-directory)
  "Directory to store Emacs backup files.")
(unless (file-exists-p my-backup-dir)
  (make-directory my-backup-dir t))
(setq backup-directory-alist `(("." . ,my-backup-dir)))

;; ==========================================
;; 3. GLOBAL IDE PACKAGES & EXPERIENCES
;; ==========================================
(load-theme 'modus-vivendi-tinted t)

(use-package move-text :ensure t)

(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; Configure company globally for autocompletion
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 1))

;; --- YASNIPPET (Enables LSP snippet expansion & placeholder jumping) ---
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;; --- EVIL MODE (Vim Emulation - Currently Disabled) ---
;; (use-package evil
;;   :ensure t
;;   :init
;;   (setq evil-want-integration t)
;;   (setq evil-want-keybinding nil)
;;   :config
;;   (evil-mode 1))
;;
;; (use-package evil-collection
;;   :after evil
;;   :ensure t
;;   (evil-collection-init))

;; ==========================================
;; 4. UNIFIED LSP MODE CONFIGURATION (C, Octave, LaTeX)
;; ==========================================
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  ;; Hook lsp into LaTeX, Octave, C, and C++ modes
  :hook ((LaTeX-mode . lsp-deferred)
         (octave-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred))
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-latex-server 'texlab)

  ;; --- THE YASNIPPET FIX ---
  (setq lsp-enable-snippet t)

  ;; --- THE INDENTATION FIX ---
  ;; Stops LSP from overriding c-basic-offset with its own 2-space rules
  (setq lsp-enable-indentation nil)

  ;; --- OCTAVE & CLANGD SPECIFIC CONFIG ---
  (add-to-list 'lsp-language-id-configuration '(octave-mode . "octave"))
  (setq lsp-clients-clangd-args '("--header-insertion=iwyu" "--background-index"))

  ;; Better UX settings
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-enable-on-type-formatting nil)
  (lsp-enable-which-key-integration t))

;; ==========================================
;; 5. LANGUAGE MODES SETTINGS
;; ==========================================

;; --- OpenGL (Moved out of LSP for safer loading) ---
(use-package glsl-mode
  :ensure t
  :mode ("\\.glsl\\'" "\\.vert\\'" "\\.frag\\'" "\\.vs\\'" "\\.fs\\'"))

;; --- C/C++ INDENTATION ---
(setq c-basic-offset 4)

;; --- OCTAVE CONFIG ---
(use-package octave
  :mode ("\\.m\\'" . octave-mode)
  :config
  (setq octave-block-offset 4)
  (add-hook 'octave-mode-hook
            (lambda ()
              (abbrev-mode 1)
              (auto-fill-mode 1)
              (font-lock-mode 1))))

;; Keybindings for the Octave Interactive experience
(with-eval-after-load 'octave
  (define-key octave-mode-map (kbd "C-c C-c") 'octave-send-block)       ;; Run current block
  (define-key octave-mode-map (kbd "C-c C-r") 'octave-send-region)      ;; Run selected code
  (define-key octave-mode-map (kbd "C-c C-l") 'octave-send-line)        ;; Run current line
  (define-key octave-mode-map (kbd "C-c C-s") 'octave-show-process-buffer)) ;; Show Octave terminal

;; --- LATEX / AUCTeX CONFIG ---
(use-package tex
  :ensure auctex
  :defer t
  :hook (LaTeX-mode . LaTeX-math-mode)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-engine 'luatex)
  (setq-default TeX-PDF-mode t)
  (setq TeX-save-query nil)
  (setq TeX-show-compilation t)
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)

  ;; Auto revert PDF after compilation finishes
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

(setq electric-pair-skip-self t)
(electric-pair-mode 1)

(use-package cdlatex
  :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex)
  :config
  (define-key cdlatex-mode-map (kbd "<tab>") #'cdlatex-tab)
  (setq cdlatex-tab-always-indent t))

(use-package reftex
  :hook (LaTeX-mode . reftex-mode)
  :config
  (setq reftex-plug-into-AUCTeX t))

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)

;; --- PDF TOOLS ---
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode)))

;; ==========================================
;; 6. ORG MODE & ORG MODERN CONFIGURATION
;; ==========================================
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 110)
(set-face-attribute 'variable-pitch nil :font "FiraCode Nerd Font Mono" :height 1.15)
(add-hook 'org-mode-hook 'variable-pitch-mode)

(setq org-agenda-files '("~"))

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t)
  (setq org-appear-autolinks t)
  (setq org-appear-autosubmarkers t))

(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

;; --- NEW: ORG MODERN INTEGRATION ---
(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "✸" "✿" "♦" "✜"))
  (setq org-modern-table t)
  ;; Ensures the styling matches your font sizing smoothly
  (set-face-attribute 'org-modern-symbol nil :font "JetBrainsMono Nerd Font Mono" :height 1.0))

;; ==========================================
;; 7. SYSTEM INTERNALS (AUTO-GENERATED DATA)
;; ==========================================
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
     "b9761a2e568bee658e0ff723dd620d844172943eb5ec4053e2b199c59e0bcc22"
     "9fb69436c074b82a62b78b8d733e6274d0bd16d156f7b094e2afe4345c040c49"
     "3f24dd8f542f4aa8186a41d5770eb383f446d7228cd7a3413b9f5e0ec0d5f3c0"
     "3613617b9953c22fe46ef2b593a2e5bc79ef3cc88770602e7e569bbd71de113b"
     default))
 '(package-selected-packages
   '(ac-clang auctex catppuccin-theme company cyberpunk-theme doom-themes
	      dracula-theme evil evil-collection expand-region
	      glsl-mode gruvbox-theme lsp-latex magit move-text
	      org-appear org-bullets org-modern org-roam pdf-tools
	      projectile transpose-frame treemacs-all-the-icons
	      yaml-mode yasnippet)))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
