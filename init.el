;;; Visual Buffer Defaults

(setq-default inhibit-startup-screen t
              default-cursor-type 'bar
              indicate-empty-lines t
              initial-scratch-message nil)

;;; Window System Customization

(when (window-system)
  ;; Disable tool bar & scroll bar
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))
  ;; Set window size
  (set-frame-size (selected-frame) 200 60))

;;; Other Graphics Defaults

(blink-cursor-mode 0)
(global-hl-line-mode 1)

;;; Aliases

(defalias 'yes-or-no-p 'y-or-n-p)

;;; Package

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;;; Theme

(load-theme 'oldlace t)

;;; Loads
(add-to-list 'load-path "/Users/mustafashameem/Documents/dev-work/paxedit")
(add-to-list 'load-path "/Users/mustafashameem/Documents/dev-work/config-utils")
(add-to-list 'load-path "/Users/mustafashameem/Documents/dev-work/xtest")

;;; Config File Utils
(require 'config-util)

;;; General Productivity
(recentf-mode 1)
(savehist-mode 1)
(delete-selection-mode 1)

;;; File Size Indicator
(size-indication-mode)

;;; Editing

(setq-default indent-tabs-mode nil
              ;; File Name
              frame-title-format '(buffer-file-name "%f" "%b")
              ;; Copy & Paste
              x-select-enable-clipboard t
              x-select-enable-primary t
              ;; Warn when opening files larger than 100MB
              large-file-warning-threshold 100000000
              ;; Deletion of Files
              delete-by-moving-to-trash t
              trash-directory "~/.Trash"
              ;; File Backup & Saving
              make-backup-files nil
              auto-save-default nil
              ;; Yasnippet Directory
              yas-snippet-dirs (list (cu-emacs-directory "mslisp/snippets")
                                     (cu-emacs-directory "elpa/haskell-mode-20141130.1012/snippets"))
              ;; Savehist Settings
              savehist-save-minibuffer-history 1
              savehist-additional-variables '(kill-ring
                                              search-ring
                                              regexp-search-ring)
              ;; Save Place
              save-place t
              save-place-file (cu-emacs-directory "saved-places"))

;;; Helm & Yasnippet

(require 'helm-config)
(require 'yasnippet)

(helm-mode 1)
(yas-global-mode 1)

;;; Enable disabled features

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;;; Files

;;; Mode and File Type Associations
(append auto-mode-alist
        '(("\\.md$" . markdown-mode)
          ("\\.cljs$" . clojure-mode)
          ("\\.\\(org\\|org_archive\\|te?xt\\)$" . org-mode)
          ("\\.yasnippet$" . snippet-mode)))

;;; General Functions

(defun ms-count-chars (start end)
  "Count the number of chars in the region."
  (interactive "r")
  (if (null start)
      (error "Please select a region.")
    (message (concat "Number of chars in region: "
                     (number-to-string (- end start))))))

;;; General Productivity

(defun ms-simple-text ()
  (visual-line-mode t))

;;; Development

;;; (add-hook 'after-init-hook #'global-flycheck-mode)

;;; General LISP

;;; Turn on expression highlighting

(show-paren-mode 1)
(setq-default blink-matching-paren nil
              show-paren-style 'expression
              show-paren-delay 0)

;;; Font Lock

(defun ms-pretty-lambdas ()
  (font-lock-add-keywords nil
                          `(("(?\\(lambda\\>\\)"
                             (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                                       ,(make-char 'greek-iso8859-7 107))
                                       nil))))))

(defun ms-add-watchwords ()
  (font-lock-add-keywords nil
                          '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\):" . font-lock-warning-face))))

(defun ms-elisp-mode-keywords ()
  (font-lock-add-keywords nil
                          '(("\\<\\(defun[a-zA-Z0-9-]+\\)" . font-lock-keyword-face))))

;;; Hook Setup Function

(defun ms-lisp-setup ()
  (paredit-mode)
  (paxedit-mode)
  (company-mode)
  (aggressive-indent-mode)
  (eldoc-mode)
  (ms-simple-text)
  (ms-pretty-lambdas)
  (ms-add-watchwords)
  (ms-elisp-mode-keywords))

;;; Emacs LISP Setup

;;; Paxedit Setup
(cu-require 'aggressive-indent
            'paredit
            'paxedit
            'undo-tree
            'yasnippet)

(cu-add-hooks 'emacs-lisp-mode-hook 'ms-lisp-setup
              'lisp-interaction-mode 'ms-lisp-setup
              'clojure-mode-hook 'ms-lisp-setup)

(eval-after-load "emacs-lisp"
  '(cu-mode-keyboard emacs-lisp-mode-map
                     "M-." 'find-function-at-point
                     "M-*" 'helm-occur))

(eval-after-load "paredit"
  '(cu-mode-keyboard paredit-mode-map
                     "[" 'paredit-open-round
                     "(" 'paredit-open-bracket
                     "C-j" 'eval-defun
                     "C-f" 'forward-sexp
                     "C-b" 'backward-sexp
                     "C-7" 'paredit-backward-slurp-sexp
                     "C-8" 'paredit-backward-barf-sexp
                     "C-9" 'paredit-forward-slurp-sexp
                     "C-0" 'paredit-forward-barf-sexp))

(eval-after-load "paxedit"
  '(cu-mode-keyboard paxedit-mode-map
                     "C-c C-c" 'paxedit-cleanup
                     ";" 'paxedit-insert-semicolon
                     "C-;" (lambda () (interactive)
                             (insert ?\;))
                     "M-<right>" 'paxedit-transpose-forward
                     "M-<left>" 'paxedit-transpose-backward
                     "M-<up>" 'paxedit-backward-up
                     "M-<down>" 'paxedit-backward-end
                     "M-b" 'paxedit-previous-symbol
                     "M-f" 'paxedit-next-symbol
                     "C-%" 'paxedit-copy
                     "C-&" 'paxedit-kill
                     "C-*" 'paxedit-delete
                     "C-^" 'paxedit-sexp-raise
                     "M-u" 'paxedit-symbol-change-case
                     "C-@" 'paxedit-symbol-copy
                     "C-#" 'paxedit-symbol-kill
                     "C-=" 'paxedit-wrap-parent-sexp
                     "C-!" 'paxedit-flatten
                     "C-~" 'paxedit-dissolve
                     "C-<return>" 'paxedit-context-new-statement))

;;; User Functions

(defun ms--simple-pair (start-pair-symbol end-pair-symbol)
  (insert start-pair-symbol end-pair-symbol)
  (setf (point) (- (point) (length end-pair-symbol))))

(defun ms-simple-paren-insert ()
  "Simple paren pair insert for non-lisp modes. Saves loading of Paredit."
  (interactive)
  (ms--simple-pair "(" ")"))

(defun ms-simple-bracket-insert ()
  "Simple bracket pair insert for non-lisp modes. Saves loading of Paredit."
  (interactive)
  (ms--simple-pair "[" "]"))

(defun ms-simple-single-quote-insert ()
  "Simple bracket pair insert for non-lisp modes. Saves loading of Paredit."
  (interactive)
  (ms--simple-pair "'" "'"))

(defun ms-goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for line number to goto."
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (call-interactively 'goto-line))
    (linum-mode -1)))

(defun ms-revert-file ()
  "Revert the current file to the version on disk."
  (interactive)
  (when (yes-or-no-p "Revert current buffer to file on disk?")
    (when (revert-buffer t t t)
      (message "Successfully reverted buffer to file on disk."))))

(defun ms-goto-init-file ()
  "Go to the innit file."
  (interactive)
  (find-file user-init-file))

(defun-paxedit-region paxedit-cxt-string? ()
  "Check if region is a string."
  (and (= ?\" (char-after rstart))
       (= ?\" (char-before rend))))

(defun-paxedit-region paxedit-string-region ()
  ""
  (cons (1+ rstart)
        (1- rend)))

(defun ms-string-fill ()
  ""
  (interactive)
  (let ((user-message "No string found to fill."))
    (paxedit-awhen (paxedit-expression user-message)
      (let ((sregion (paxedit-get it :region)))
        (paxedit-aif (and (paxedit-cxt-string? sregion)
                          (paxedit-string-region sregion))
            (paxedit-region-modify it
                                   (lambda (s) (with-temp-buffer (insert s)
                                                            (mark-whole-buffer)
                                                            (call-interactively 'fill-region)
                                                            (buffer-string)))))))))

;;; Global Keyboard Map

(cu-global-keyboard "s-f" 'recentf-open-files
                    ;; Simple Matching Pair Insert
                    "[" 'ms-simple-paren-insert
                    "(" 'ms-simple-bracket-insert
                    ;; "'" 'ms-simple-single-quote-insert
                    "C-t" 'ms-goto-line-with-feedback
                    ;; Whitespace Mode
                    "C-c C-w" 'whitespace-mode
                    ;; Undo & Redo
                    "s-z" 'undo-tree-undo
                    "s-Z" 'undo-tree-redo
                    "s-q" 'paxedit-delete-whitespace
                    "C-c r" 'replace-regexp
                    "C-c C-r" 'ms-revert-file
                    "C-c C-e" 'helm-show-kill-ring
                    "C-c C-u" 'undo-tree-visualize
                    "C-c C-b" 'helm-bookmarks
                    "C-w" 'backward-kill-word
                    "M-x" 'helm-M-x)

;;; Haskell Mode

(defun ms--haskell-hooks ()
  "Functions to execute when editing Haskell source files."
  (paredit-mode)
  (paxedit-mode)
  (turn-on-haskell-indentation))

;;; Haskell Functions

(defun ms-haskell-arrow-forward ()
  "Insert '->' after the cursor."
  (interactive)
  (insert "->"))

(defun ms-haskell-arrow-backward ()
  "Insert '->' after the cursor."
  (interactive)
  (insert "<-"))

;;; Haskell Setup

(cu-add-hooks 'haskell-mode-hook 'ms--haskell-hooks)

(let ((my-cabal-path (expand-file-name "/Users/mustafashameem/Library/Haskell/bin")))
  (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))

(setq-default haskell-process-auto-import-loaded-modules t
              haskell-process-log t
              haskell-process-suggest-remove-import-lines t
              haskell-tags-on-save t)

(eval-after-load "haskell-mode"
  '(cu-mode-keyboard haskell-mode-map
                     "`" 'ms-haskell-arrow-forward
                     "~" 'ms-haskell-arrow-backward))

(eval-after-load 'haskell-mode
  '(progn
     (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
     (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
     (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
     (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
     (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
     (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)
     (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))

(eval-after-load 'haskell-cabal
  '(progn
     (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
     (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
     (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
     (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

;;; XML / HTML

(cu-add-hooks 'html-mode-hook 'smartparens-mode)

(eval-after-load 'html-mode
  '(cu-mode-keyboard html-mode-map
                     "M-<up>" 'sp-backward-up-sexp
                     "M-<down>" 'sp-backward-down-sexp
                     ;; "M-b" 'paxedit-previous-symbol
                     ;; "M-f" 'paxedit-next-symbol
                     ;; "C-%" 'paxedit-copy
                     ;; "C-&" 'paxedit-kill
                     ;; "C-*" 'paxedit-delete
                     ;; "C-^" 'paxedit-sexp-raise
                     ;; "M-u" 'paxedit-symbol-change-case
                     ;; "C-@" 'paxedit-symbol-copy
                     ;; "C-#" 'paxedit-symbol-kill
                     ;; "C-=" 'paxedit-wrap-parent-sexp
                     ;; "C-!" 'paxedit-flatten
                     ;; "C-~" 'paxedit-dissolve
                     ;; "C-<return>" 'paxedit-context-new-statement
                     ))

;;; ORG Mode

(require 'org-bullets)
(eval-after-load "org-toc-autoloads"
  '(progn
     (if (require 'org-toc nil t)
         (add-hook 'org-mode-hook 'org-toc-enable)
       (warn "org-toc not found"))))

;;; Defaults

(defun ms--org-default ()
  (org-indent-mode)
  (org-bullets-mode))

(setf org-src-fontify-natively t
      org-log-done 'time
      org-catch-invisible-edits 'show
      org-src-preserve-indentation t)

(cu-add-hooks 'org-mode-hook 'ms--org-default
              'org-mode-hook 'ms-simple-text)
