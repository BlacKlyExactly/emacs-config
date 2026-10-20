;;; duskfox-theme.el -*- lexical-binding: t; -*-

(deftheme duskfox
  "Duskfox color theme generated from the nightfox.nvim palette.")

(let ((class '((class color) (min-colors 89)))
      ;; Oficjalna paleta barw Duskfox
      (bg      "#232136")
      (fg      "#e0def4")
      (bg-alt  "#2a283e")
      (fg-alt  "#908caa")
      (cursor  "#f6c177")
      (black   "#393552")
      (red     "#eb6f92")
      (green   "#a3be8c")
      (yellow  "#f6c177")
      (blue    "#569fba")
      (magenta "#c4a7e7")
      (cyan    "#9ccfd8")
      (white   "#e0def4")
      (grey    "#6e6a86"))

  (custom-theme-set-faces
   'duskfox
   `(default ((,class (:background ,bg :foreground ,fg))))
   `(cursor ((,class (:background ,cursor))))
   `(fringe ((,class (:background ,bg :foreground ,grey))))
   `(region ((,class (:background ,black))))
   `(mode-line ((,class (:background ,bg-alt :foreground ,white :box nil))))
   `(mode-line-inactive ((,class (:background ,bg :foreground ,grey :box nil))))

   ;; Składnia (Font-lock)
   `(font-lock-builtin-face ((,class (:foreground ,red))))
   `(font-lock-comment-face ((,class (:foreground ,grey :italic t))))
   `(font-lock-constant-face ((,class (:foreground ,magenta))))
   `(font-lock-function-name-face ((,class (:foreground ,blue))))
   `(font-lock-keyword-face ((,class (:foreground ,magenta :bold t))))
   `(font-lock-string-face ((,class (:foreground ,green))))
   `(font-lock-type-face ((,class (:foreground ,cyan))))
   `(font-lock-variable-name-face ((,class (:foreground ,fg))))
   `(font-lock-warning-face ((,class (:foreground ,yellow :bold t))))))

(provide-theme 'duskfox)
