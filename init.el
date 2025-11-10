;; --- Basic UI Settings ---
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(hl-line-mode t)
(blink-cursor-mode -1)
(toggle-truncate-lines -1)

;; --- LINE NUMBERING  ---
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; --- FONT ---
;;d(set-frame-font "JetBrainsMono Nerd Font Mono" nil t)
;;(set-frame-font "FiraCode Nerd Font" nil t)
;;(set-frame-font "BlexMono Nerd Font" nil t)
(set-frame-font "Terminess Nerd Font Mono" nil t)


;; --- C/C++ INDENTATION ---
(setq c-default-style "k&r")
(setq c-basic-offset 4)


;; --- PACKAGE MANAGEMENT ---
(require 'package)
(setq package-archives '(
			 ("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 )
      )

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


;; --- THEME LOADING ---
(use-package dracula-theme :ensure t)
(load-theme 'dracula t)
(custom-set-variables '(custom-safe-themes (quote (t))))

;; --- PDF Tools ---
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install) ;; compiles the C parts and sets up
  (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode)))

;; --- Expand region ---
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; Enable lsp-mode
(add-hook 'latex-mode-hook #'lsp-latex-enable)
(setq lsp-latex-server 'latex-lsp)

;; Configure company for autocompletion
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.5) ;; Delay before completion starts

;; Configure AUCTeX for LaTeX
(setq TeX-auto-save t) ;; Auto-save on compilation
(setq TeX-parse-self t) ;; Parse LaTeX file on save

;; Org mode & Org agenda
(setq org-agenda-files '("~"))


