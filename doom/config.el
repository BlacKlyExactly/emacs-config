;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Hide title bar (macOS)

(setq doom-theme 'doom-outrun-electric)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(defun my/apply-frame-transparency (&optional frame)
  "Apply macOS transparency parameters to FRAME (defaults to selected frame)."
  (with-selected-frame (or frame (selected-frame))
    (set-frame-parameter nil 'alpha-background 0.7)
    (set-frame-parameter nil 'ns-background-blur 30)
    (set-frame-parameter nil 'ns-alpha-elements '(ns-alpha-all))))

(add-hook 'after-make-frame-functions #'my/apply-frame-transparency)
(unless (daemonp)
  (add-hook 'window-setup-hook #'my/apply-frame-transparency))

(when (display-graphic-p)
  (my/apply-frame-transparency))

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(set-frame-parameter nil 'undecorated-round t)

(setq tab-bar-close-button-show nil
      tab-bar-new-button-show nil)

(setq projectile-project-search-path '("~/Projects/"))

(defun my/treemacs-focus-toggle ()
  "Jump to treemacs, or back to the previous window if already in it."
  (interactive)
  (if (eq major-mode 'treemacs-mode)
      (select-window (get-mru-window nil nil t))
    (treemacs-select-window)))

(map! :leader :desc "Toggle treemacs focus" "e" #'my/treemacs-focus-toggle)

(add-hook 'projectile-after-switch-project-hook #'treemacs)

(custom-set-faces!
  '(treemacs-root-face :height 1.0))

(tab-bar-mode -1)

(setq treemacs-user-mode-line-format 'none)

(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'indent-region-advice)
(advice-add 'move-text-down :after 'indent-region-advice)

(use-package! move-text
  :config
  (map! :nv "M-j" #'move-text-down
        :nv "M-k" #'move-text-up))

(yas-global-mode 1)

(global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)

(global-company-mode)

(after! lsp-mode
  (setq lsp-clients-typescript-preferences
        '(:includeCompletionsForModuleExports t
          :includeCompletionsForImportStatements t)))

(setq-default indent-tabs-mode nil
              tab-width 2
              standard-indent 2)

(after! typescript-ts-mode
  (setq typescript-ts-mode-indent-offset 2))

(after! js
  (setq js-indent-level 2))

(after! typescript
  (setq typescript-indent-level 2))

(add-hook 'typescript-mode-hook
          (lambda ()
            (setq-local typescript-indent-level 2)
            (setq-local indent-tabs-mode nil)))

(setq treemacs-project-follow-mode 1)

(use-package! jtsx
  :mode ("\\.tsx\\'" . jtsx-tsx-mode)
  :hook (jtsx-tsx-mode . lsp-deferred))

(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)


(defvar my/vterm-terminals
  '("Web" "Api" "Worker" "Misc"))

(defvar my/vterm-return-buffer nil
  "Buffer to return to from a vterm.")

(defun my/vterm-init ()
  "Create named vterm buffers without changing the startup screen."
  (require 'vterm)
  (let ((original-window-config (current-window-configuration)))
    (dolist (name my/vterm-terminals)
      (unless (get-buffer name)
        (save-window-excursion
          (vterm)
          (rename-buffer name))))
    (set-window-configuration original-window-config)))

(defun my/vterm-switch (number)
  (interactive "nTerminal number: ")
  (unless (<= 1 number (length my/vterm-terminals))
    (user-error "Choose a terminal from 1 to %d"
                (length my/vterm-terminals)))
  (let ((name (nth (1- number) my/vterm-terminals)))
    (unless (get-buffer name)
      (user-error "Terminal %s does not exist" name))
    (unless (member (buffer-name) my/vterm-terminals)
      (setq my/vterm-return-buffer (current-buffer)))
    (delete-other-windows)
    (switch-to-buffer name)))

(defun my/vterm-next ()
  (interactive)
  (let* ((count (length my/vterm-terminals))
         (current (cl-position (buffer-name)
                               my/vterm-terminals
                               :test #'equal)))
    (my/vterm-switch
     (1+ (if current
             (mod (1+ current) count)
           0)))))

(defun my/vterm-previous ()
  (interactive)
  (let* ((count (length my/vterm-terminals))
         (current (cl-position (buffer-name)
                               my/vterm-terminals
                               :test #'equal)))
    (my/vterm-switch
     (1+ (if current
             (mod (1- current) count)
           (1- count))))))

(defun my/vterm-return ()
  "Return to the last non-terminal buffer."
  (interactive)
  (let ((target
         (or (and (buffer-live-p my/vterm-return-buffer)
                  (not (member (buffer-name my/vterm-return-buffer)
                               my/vterm-terminals))
                  my/vterm-return-buffer)
             (seq-some
              (lambda (buffer)
                (unless (member (buffer-name buffer)
                                my/vterm-terminals)
                  buffer))
              (buffer-list)))))
    (if target
        (progn
          (delete-other-windows)
          (switch-to-buffer target))
      (message "No non-terminal buffer found"))))

(add-hook 'emacs-startup-hook #'my/vterm-init)

(map! :leader
      :prefix ("t" . "terminals")
      :desc "Next terminal" "n" #'my/vterm-next
      :desc "Previous terminal" "p" #'my/vterm-previous
      :desc "Return to code buffer" "r" #'my/vterm-return
      :desc "Return to code buffer" "0" #'my/vterm-return)

(with-eval-after-load 'which-key
  (dotimes (i (length my/vterm-terminals))
    (let ((number (1+ i))
          (name (nth i my/vterm-terminals)))
      (define-key
       doom-leader-map
       (kbd (format "t %d" number))
       (let ((n number))
         (lambda ()
           (interactive)
           (my/vterm-switch n))))
      (which-key-add-key-based-replacements
        (format "SPC t %d" number)
        (format "Terminal %s" name)))))

(use-package prettier-js)
(use-package jtsx)
(use-package typescript-mode)

(add-hook 'js-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'jtsx-tsx-mode-hook 'prettier-js-mode)
(add-hook 'jtsx-jsx-mode-hook 'prettier-js-mode)
(add-hook 'typescript-mode-hook 'prettier-js-mode)

(setq prettier-js-use-modules-bin t)
(setq prettier-js-command "prettierd")
