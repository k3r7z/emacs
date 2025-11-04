
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; theme
(load-theme 'doom-nord)

(setq package-enable-at-startup nil)
(package-initialize) 
(require 'evil)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; PDF Tools
(package-initialize)
(require 'pdf-tools)
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install) ;; compiles the C parts and sets up
  (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode)))

(blink-cursor-mode -1)


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

(use-package expand-region
  :bind ("C-=" . er/expand-region))
