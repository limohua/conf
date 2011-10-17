;; file name: ~/.emacs
;; Copyright @ Jason Wang 2009
;; Copyright @ Amos Kong 2010
;; License GPLv3

;; ============================
;; Add the elisp path
;; ============================
(add-to-list 'load-path "~/elisp")
(add-to-list 'load-path "~/elisp/eshell-2.4.2")
(add-to-list 'load-path "~/elisp/pcomplete-1.1.7")
(add-to-list 'load-path "~/.emacs.d")

;;(add-to-list 'load-path "~/lisp/wubi/wubi")
;;(require 'wubi)
;;(register-input-method "chinese-wubi" "Chinese-GB" 'quail-use-package "wubi" "wubi")
;;(wubi-load-local-phrases)
;;(setq default-input-method "chinese-wubi")

;; ============================
;; Setup shell stuff
;; ============================
;; Commented out for now, not necessary?
;; (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; ============================
;; Setup syntax, background, and foreground coloring
;; ============================

(set-background-color "Black")
(set-foreground-color "White")
(set-cursor-color "LightSkyBlue")
(set-mouse-color "LightSkyBlue")
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; ============================
;; Key mappings
;; ============================

;; use F1 key to go to a man page
(global-set-key [f1] 'dired)
;; use F2 key to call grep
(global-set-key [f2] 'grep)
;; use F3 key to switch to other window
(global-set-key [f3] 'other-window)
;; use F4 key to switch to switch buffer
(global-set-key [f4] 'switch-to-buffer)
;; uss F5 key to switch do compile
(global-set-key [f5] 'compile)

;; goto line function C-c C-g
(global-set-key [ (control c) (control g) ] 'goto-line)

;; undo and redo functionality with special module
;; (require 'redo)
;; (global-set-key (kbd "C-x C-r") 'redo)
;; (global-set-key [ (control x) (r)] 'redo)
;; (global-set-key [ (control x) (control u)] 'undo)

;; easy commenting out of lines
(autoload 'comment-out-region "comment" nil t)
(global-set-key "\C-cq" 'comment-out-region)

;; ============================
;; Mouse Settings
;; ============================

;; mouse button one drags the scroll bar
(global-set-key [vertical-scroll-bar down-mouse-1] 'scroll-bar-drag)

;; setup scroll mouse settings
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)

(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

;; ============================
;; Display
;; ============================

;; disable startup message
(setq inhibit-startup-message t)

;; setup font
(set-frame-font
"-Misc-Fixed-Medium-R-Normal--15-140-75-75-C-90-ISO8859-1")

;; display the current time
(display-time)

;; Show column number at bottom of screen
(column-number-mode 1)

;; alias y to yes and n to no
(defalias 'yes-or-no-p 'y-or-n-p)

;; highlight matches from searches
(setq isearch-highlight t)
(setq search-highlight t)
(setq-default transient-mark-mode t)

(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode -1))

;; ===========================
;; Behaviour
;; ===========================

;; Pgup/dn will return exactly to the starting point.
(setq scroll-preserve-screen-position 1)

;; don't automatically add new lines when scrolling down at
;; the bottom of a buffer
(setq next-line-add-newlines nil)

;; scroll just one line when hitting the bottom of the window
(setq scroll-step 1)
(setq scroll-conservatively 1)

;; format the title-bar to always include the buffer name
(setq frame-title-format "emacs - %b")

;; show a menu only when running within X (save real estate when
;; in console)
(menu-bar-mode (if window-system 1 -1))

;; turn off the toolbar
(if (>= emacs-major-version 21)
    (tool-bar-mode -1))

;; turn on word wrapping in text mode
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;; replace highlighted text with what I type rather than just
;; inserting at a point
(delete-selection-mode t)

;; resize the mini-buffer when necessary
(setq resize-minibuffer-mode t)

;; highlight during searching
(setq query-replace-highlight t)

;; highlight incremental search
(setq search-highlight t)

;; ===========================
;; Buffer Navigation
;; ============================

;; Iswitchb is much nicer for inter-buffer navigation.
(cond ((fboundp 'iswitchb-mode)                ; GNU Emacs 21
       (iswitchb-mode 1))
      ((fboundp 'iswitchb-default-keybindings) ; Old-style activation
       (iswitchb-mode))
      (t nil))                                 ; Oh well.

;; keys for buffer creation and navigation
(global-set-key [(control x) (control b)] 'iswitchb-buffer)
(global-set-key [(control x) (f)] 'find-file)

;; ==========================
;; C/C++ indentation
;; ==========================
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "/home/devel")
                                       filename))
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))))

;; ============================
;; Set up which modes to use for which file extensions
;; ============================
(setq auto-mode-alist
      (append
       '(
     ("\\.h$"             . c++-mode)
     ("\\.dps$"           . pascal-mode)
     ("\\.py$"            . python-mode)
     ("\\.Xdefaults$"     . xrdb-mode)
     ("\\.Xenvironment$"  . xrdb-mode)
     ("\\.Xresources$"    . xrdb-mode)
     ("\\.tei$"           . xml-mode)
     ("\\.php$"           . php-mode)
     ) auto-mode-alist))

;; ===========================
;; Custom Functions
;; ===========================

;; insert functions
(global-unset-key "\C-t")
(global-set-key "\C-t\C-h" 'insert-function-header)

;; indent the entire buffer
(defun c-indent-buffer ()
  "Indent entire buffer of C source code."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (< (point) (point-max))
      (end-of-line)
      (forward-char 1))))

(defun insert-function-header () (interactive)
  (insert "  /**\n")
  (insert "   * \n")
  (insert "   * @param: \n")
  (insert "   * @return: \n")
  (insert "   */\n"))

(global-set-key "\C-t\C-g" 'insert-function-header)

(defun insert-file-header () (interactive)
  (insert "/*////////////////////////////////////*/\n")
  (insert "/**\n")
  (insert " * \n")
  (insert " * Author: Michael Wasilewski\n")
  (insert " */\n")
  (insert "/*////////////////////////////////////*/\n"))

;; set up the compiling options
(setq compile-command "make"
      compilation-ask-about-save nil
      compilation-window-height 10)
(global-set-key [f7] 'compile)

;; resize man page to take up whole screen
(setq Man-notify 'bully)

;; show trailing whitespace
(setq-default show-trailing-whitespace t)
(setq-default default-indicate-empty-lines t)
(setq-default indent-tabs-mode nil)

;; Enable auto-fill mode for all major modes
(setq-default auto-fill-function 'do-auto-fill)

;; Erc Configuration
(setq erc-default-coding-system '(utf-8 . utf-8))
(setq erc-nick "jasowang_erc"
      erc-user-full-name "Jason Wang")
(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist
      '(("irc.devel.redhat.com"
         "#section"
         "#eng-china")))

;; Enable flyspell mode
(setq text-mode-hook '(lambda()
                        (flyspell-mode t)
                        ))

;; Local configuration of cscope
(require 'xcscope)
(setq cscope-do-not-update-database t)

;; xcscope key bindings
(define-key global-map [(control f3)]  'cscope-set-initial-directory)
(define-key global-map [(control f4)]  'cscope-unset-initial-directory)
(define-key global-map [(control f5)]  'cscope-find-this-symbol)
(define-key global-map [(control f6)]  'cscope-find-global-definition)
(define-key global-map [(control f7)]
  'cscope-find-global-definition-no-prompting)
(define-key global-map [(control f8)]  'cscope-pop-mark)
(define-key global-map [(control f9)]  'cscope-next-symbol)
(define-key global-map [(control f10)] 'cscope-next-file)
(define-key global-map [(control f11)] 'cscope-prev-symbol)
(define-key global-map [(control f12)] 'cscope-prev-file)
(define-key global-map [(meta f9)]  'cscope-display-buffer)
(define-key global-map [(meta f10)] 'cscope-display-buffer-toggle)

;; my own setting of cscope key bindings
(define-key global-map [(control ?0)] 'cscope-find-this-symbol)
(define-key global-map [(control ?1)] 'cscope-find-global-definition)
(define-key global-map [(control ?2)]
  'cscope-find-global-definition-no-prompting)
(define-key global-map [(control ?3)] 'cscope-pop-mark)
(define-key global-map [M-up] 'cscope-prev-symbol)
(define-key global-map [M-down] 'cscope-next-symbol)
(define-key global-map [f12] 'c-down-conditional-with-else)
(define-key global-map [M-f12] 'c-up-conditional-with-else)