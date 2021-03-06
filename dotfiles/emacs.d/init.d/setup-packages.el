;; ============================================================================
;; Define and install required packages
;; ============================================================================


(defvar package-list
  '(
    ;; Jump to anywhere in a window/frame by pressing <C-c> <Space>
    ace-jump-mode

    ;; Auto-completion framework that can work with many backends.
    company

    ;; interface between irony-mode and company-mode
    company-irony

    ;; Select words, sentences, within-quotes, etc
    expand-region

    ;; For haskell editing
    haskell-mode

    ;; Incremental completion (e.g. for finding buffers, files, etc)
    helm

    ;; interface between helm and company-mode
    helm-company

    ;; Highlight the symbol under the cursor
    highlight-symbol

    ;; Visually highlight indentation to make alignment easier
    indent-guide

    ;; C/C++ completion via libclang
    irony

    ;; Python autcompletion
    jedi

    ;; Control git from emacs
    magit

        ;; Color theme based on Sublime Text's monokai-theme
    monokai-theme

    ;; NerdTree-like directory navigator
    neotree

    ;; Pandoc-friendly markdown syntax
    pandoc-mode

    ;; Represent undo history as a tree
    undo-tree

    ;; surround.vim, but for emacs
    wrap-region

    ;; Snippets for quickly filling in boilerplate
    yasnippet
   )
  "Packages to install by default")

;; ----------------------------------------------------------------------------
;; Install packages
;; ----------------------------------------------------------------------------
(require 'package)

;; Add repositories
(add-to-list 'package-archives '(    "melpa" .          "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Load installed packages
(package-initialize)

;; initialize package listing
(unless package-archive-contents
  (package-refresh-contents))

;; install missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; ----------------------------------------------------------------------------
;; Plugin-specific settings
;; ----------------------------------------------------------------------------

;; ace-jump-mode
;; =============
;;
;; <C-c> <Space>: quickly jump within a window with
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; auto-fill-mode
;; ==============
;;
;; Automatically start new lines when exceeding per-line character line
(auto-fill-mode t)

;; company
;; =======
;; Tab-completion with lots of backends
;;
;; M-[np]
;;   next/previous selection
;; <CR>
;;   select highlighted option
;; <SPC>
;;   complete common part
(add-hook 'after-init-hook 'global-company-mode)

;; irony-company
;; =============
;;
;; Add irony-mode as a backend to company-mode
(eval-after-load 'company '(add-to-list 'company-backends 'company-irony))

;; Start completion after `std::` and the like
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

;; irony-mode
;; ==========
;;
;; C/C++ autocomplete
(add-hook 'c++-mode-hook  'irony-mode)
(add-hook 'c-mode-hook    'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)


;; delete-selection-mode
;; =====================
;;
;; If you start typing when some text is selected, overwrite it
(delete-selection-mode t)

;; expand-region
;; =============
;;
;; Select progressively more wide semantic regions
(global-set-key (kbd "C-c =") 'er/expand-region)
(global-set-key (kbd "C-c -") 'er/contract-region)

;; helm-mode
;; =========
;;
;; Incremental name completion for buffers et al.
(eval-after-load 'company
  '(progn
     (define-key   company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-active-map (kbd "C-:") 'helm-company)))
(helm-mode 1)

;; replace standard keybindings with helm variants
(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key (kbd "M-y")     'helm-show-kill-ring)
(global-set-key (kbd "C-x b")   'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c o")   'helm-occur)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c /")   'helm-find-files-up-one-level)

;; highlight-symbol-mode
;; =====================
;;
;; Highlight symbol under cursor
(highlight-symbol-mode 1)
(setq highlight-symbol-idle-delay 0)

;; hl-line
;; =======
;;
;; Highlight line pointer is on
(global-hl-line-mode 1)

;; indent-guide
;; ============
;;
;; Show vertical lines to highlight indentation
(indent-guide-global-mode)

;; jedi
;; ====
;;
;; Python autocomplete
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; linum
;; =====
;;
;; Minor mode for line numbering.
(global-linum-mode 1)             ; always enable line numbering
(setq linum-format "%4d \u2502 ") ; "123 | int fibonacci(int n) {...}"

;; magit
;; =====
;;
;; Control git from within emacs.
;;   <M-x> magit-status

;; monokai-theme
;; =============
;;
;; Prettiness for everyone!
(load-theme 'monokai t)

;; pandoc-mode
;; ===========
;;
;; Enable pandoc-mode when loading a markdown file
(add-hook 'markdown-mode-hook 'pandoc-mode)

;; prettify-symbols-mode
;; =====================
;;
;; Replace lambda with the lambda symbol, etc. Note that this was called
;; "pretty-symbols-mode" before emacs 24.4, so this command will fail on older
;; builds.
(if (version< emacs-version "24.4")
    nil
  (global-prettify-symbols-mode 1))

;; show-paren-mode
;; ================
;;
;; When hovering over 1 end of a parentheses, highlight the other
(show-paren-mode t)

;; subword-mode
;; ============
;;
;; Treat CamelCaseWords  as individual words
(global-subword-mode t)

;; tramp-mode
;; ==========
;;
;; Remote connection to a running emacs instance over ssh.

;; Use ssh (not scp) as the default protocol for making connections.
(setq tramp-default-mode "ssh")

;; Use bash, not the default shell, with tramp. This avoids errors caused by
;; fancy command line prompts zsh may use.
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

;; undo-tree
;; =========
;;
;; Visualize "undo ring"
;; C-x u      Visualize undo tree
;; C-_        undo
;; M-_        redo
(global-undo-tree-mode)

(require 'setup-variables) ;; for `tmp-dir` variable
(let* ((undo-root (file-name-as-directory tmp-dir))
       (undo-path (concat undo-root "undo")))
  (setq-default
    undo-tree-auto-save-history        t
    undo-tree-history-directory-alist `((".*" . ,undo-path))))

;; windmove
;; ========
;;
;; Use <Shift+Arrow> to navigate between windows
(when (fboundp 'windmove-default-keybindings)
    (windmove-default-keybindings))

;; wrap-region
;; ===========
;;
;; Select text, then type ", ", (, {, [
(wrap-region-mode t)


;; ----------------------------------------------------------------------------
(provide 'setup-packages)
