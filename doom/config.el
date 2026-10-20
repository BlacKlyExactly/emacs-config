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


(defun my/apply-frame-transparency (&optional frame)
  "Apply macOS transparency parameters to FRAME (defaults to selected frame)."
  (with-selected-frame (or frame (selected-frame))
    (set-frame-parameter nil 'alpha-background 0.7)
    (set-frame-parameter nil 'ns-background-blur 30)
    (set-frame-parameter nil 'ns-alpha-elements '(ns-alpha-all))))

(add-hook 'after-make-frame-functions #'my/apply-frame-transparency)
(unless (daemonp)
  (add-hook 'window-setup-hook #'my/apply-frame-transparency))

;; Apply transparency immediately for non-daemon graphical startup,
;; where neither after-make-frame-functions nor window-setup-hook fires.
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

;; Default indentation: 2 spaces, no tabs
(setq-default indent-tabs-mode nil
              tab-width 2
              standard-indent 2)

;; JavaScript / TypeScript
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

(setq treemacs-project-follow-mode nil)

(use-package! jtsx
  :mode ("\\.tsx\\'" . jtsx-tsx-mode)
  :hook (jtsx-tsx-mode . lsp-deferred))
