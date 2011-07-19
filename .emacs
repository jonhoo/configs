(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen 1)
 '(line-number-mode 1)
 '(vc-follow-symlinks 1)
)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; Add local modules to LoadPath
(let ((default-directory "~/.emacs.d/site-lisp/"))
      (normal-top-level-add-to-load-path '("."))
      (normal-top-level-add-subdirs-to-load-path))

;; Shift+Tab = Four spaces
(defun fourspace (&optional n)
  (interactive "p")
  (beginning-of-line)
  (let ((last-command-char ?\s))
    (self-insert-command (* (or n 1) default-tab-width))))
(define-key global-map (kbd "<backtab>") 'fourspace)
;; Remap RET to do indenting
(define-key global-map (kbd "RET") 'newline-and-indent)
;; But not for text mode or AsTMa mode
(add-hook 'text-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline)))
(add-hook 'astma-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline)))
;; But especially for HTML mode
(add-hook 'html-mode-hook '(lambda ()
                             (local-set-key (kbd "RET") 'newline-and-indent)))
;; We want flyspell in text modes
(dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))

;; Syntax highlight LESS like CSS
(setq auto-mode-alist (cons '("\\.less$" . css-mode) auto-mode-alist))

;; Autocomplete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/jon/.emacs.d/site-lisp/auto-complete/ac-dict")
(ac-config-default)
(setq ac-auto-start 2)
(setq ac-delay 0.1)
(setq ac-auto-show-menu nil)
(setq ac-show-menu-immediately-on-auto-complete t)
(setq ac-trigger-key nil)
(define-key ac-complete-mode-map "\r" nil)

;; Autoload modes
; PHP
(autoload 'php-mode "php-mode.el" "Php mode." t)
(setq auto-mode-alist (append '(("\\.php[345]?$" . php-mode)) auto-mode-alist))
; Python
(autoload 'python-mode "python-mode.el" "Python mode." t)
(setq auto-mode-alist (append '(("\\.py$" . python-mode)) auto-mode-alist))
; Markdown
(autoload 'markdown-mode "markdown-mode.el" "Markdown mode" t)
(setq auto-mode-alist (append '(("\\.md$" . markdown-mode)) auto-mode-alist))
; AsTMa
(autoload 'astma-mode "astma-mode.el" "AsTMa mode" t)
(setq auto-mode-alist (append '(("\\.atm$" . astma-mode)) auto-mode-alist))
; YAML
(autoload 'yaml-mode "yaml-mode.el" "YAML mode" t)
(setq auto-mode-alist (append '(("\.yml\'" . yaml-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\.yaml\'" . yaml-mode)) auto-mode-alist))
; Apache config mode
(autoload 'apache-mode "apache-mode.el" "Apache conf mode." t)
(setq auto-mode-alist (cons '("/httpd.conf$" . apache-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".htaccess$" . apache-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("^/etc/httpd/conf/.*\.conf" . apache-mode) auto-mode-alist))
; PKGBUILD mode
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

(require 'color-theme)

;; Use aspell
(setq-default ispell-program-name "aspell")

;; sudoing should always be available
(require 'sudo-save)

;; SAL mode
; (require 'sal-mode)

;; Indent
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq standard-indent 4)

;; Mouse scroll
(mouse-wheel-mode t)

;; Interface tweaks
(line-number-mode 1)
(column-number-mode 1)
(set-cursor-color "white")
(set-mouse-color "white")
(tool-bar-mode -1)

;; No backup files
(setq make-backup-files nil) 

;; Syntax highlighting
(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t) 

;; Treat 'y' or <CR> as yes, 'n' as no.
(fset 'yes-or-no-p 'y-or-n-p)
(define-key query-replace-map [return] 'act)
(define-key query-replace-map [?\C-m] 'act)

;; UTF-8
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Keyboard shortcuts
(global-set-key (kbd "<f3>") 'apropos)

;; save a list of open files in ~/.emacs.desktop
;; save the desktop file automatically if it already exists
(setq desktop-save 'if-exists)
(desktop-save-mode 1)

;; Highlight line
(global-hl-line-mode 1)
(setq hl-line-sticky-flag nil)
(set-face-background hl-line-face "gray13")

;; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

;; Move lines
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; Apply theme
(color-theme-solarized 'dark)
