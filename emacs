;; -*- mode: emacs-lisp -*-
;; .emacs
;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)
;; Time-stamp:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	 编程相关的配置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; wrap to some feature don't really block the boot.
(defmacro safe-wrap (fn &rest clean-up)
  `(unwind-protect
       (let (retval)
	 (condition-case ex
	     (setq retval (progn ,fn))
	   ('error
	    (message (format "Caught exception: [%s]" ex))
	    (setq retval (cons 'exception (list ex)))))
	 retval)
     ,@clean-up))

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(add-to-list 'load-path "~/.emacs.d/site-lisp/multiple-cursors/")

(setq exec-path (append exec-path '("/usr/local/bin" "/opt/local/bin")))

(setq load-path
      (remove (concat "/usr/share/emacs/"
		      (substring emacs-version 0 -2) "/lisp/cedet")
	      load-path))

(setq stack-trace-on-error nil)

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
			   ))

)

;当前窗口和非当前窗口时透明度 
(setq alpha-list '((95 89) (100 100))) 
(defun loop-alpha () 
(interactive) 
(let ((h (car alpha-list))) 
((lambda (a ab) 
(set-frame-parameter (selected-frame) 'alpha (list a ab)) 
(add-to-list 'default-frame-alist (cons 'alpha (list a ab)))) 
(car h) (car (cdr h))) 
(setq alpha-list (cdr (append alpha-list (list h)))))) 
;启动窗口时时自动开启窗口半透明效果 
(loop-alpha)



;(defun multi-cursors-init()
;  (require 'multiple-cursors)
;  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(defun flex-bison-init()
  (autoload 'flex-mode "flex-mode" nil t)
  (autoload 'bison-mode "bison-mode" nil t)
  (setq auto-mode-alist
	(cons '("\\.flex" . flex-mode) auto-mode-alist))
  (setq auto-mode-alist
	(cons '("\\.y" . bison-mode) auto-mode-alist)))

(defun complete-func-init()
(add-to-list 'load-path "~/.emacs.d/site-lisp/auto-complete/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/auto-complete/ac-dict")
(ac-config-default))

;;  (safe-wrap (complete-func-init)) ;; disbale auto complete for better input speed.

(defun ergoemacs-setup()
  (setq ergoemacs-theme "lvl1")
  (setq ergoemacs-keyboard-layout "us")
  ;; (require 'ergoemacs-mode)
  
  ;(ergoemacs-mode 0)
  ;(cua-mode nil)
  )

(defun yas-setup()
(require 'yasnippet)
(yas/global-mode 1)
(setq yas/window-system-popup-function 'yas/x-popup-menu-for-template)
(yas/load-directory  "~/.emacs.d/site-lisp/rails-snippets/"))

(defun elscreen-setup()
;;; The tabbar.
  (load "elscreen" "ElScreen" t)
  (elscreen-start)
  (global-set-key (kbd "C-c t a b e") 'elscreen-create)
  (global-set-key (kbd "C-c t a b d") 'elscreen-kill)

  (global-set-key (kbd "C-M-_") 'elscreen-previous)
  (global-set-key (kbd "C-M-+") 'elscreen-next))

(defun fic-mode-setup()
;;; highlight TODO, etc mode.
  (require 'fic-mode)
  (add-hook 'c++-mode-hook 'turn-on-fic-mode)
  (add-hook 'c-mode-hook 'turn-on-fic-mode)
  (add-hook 'python-mode-hook 'turn-on-fic-mode)
  (add-hook 'js2-mode-hook 'turn-on-fic-mode)
  (add-hook 'java-mode-hook 'turn-on-fic-mode)
  (add-hook 'objc-mode-hook 'turn-on-fic-mode)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-fic-mode)
)

(defun dash-setup ()
  (autoload 'dash-at-point "dash-at-point"
    "Search the word at point with Dash." t nil)
  (global-set-key "\C-cd" 'dash-at-point)
  (global-set-key [f1] 'dash-at-point)
  (global-set-key "\C-ce" 'dash-at-point-with-docset))

(defun git-setup ()
 (featurep 'git)
    nil
    ((lambda ()
    (require 'git)
    (require 'git-blame)
    (autoload 'git-blame-mode "git-blame" "Minor mode for incremental blame for Git." t)
    (require 'magit)
    )))

(defun generic-programming-realted-config ()

; diable doxymacs for conflict of cedet.
;; (safe-wrap ((lambda ()
;;              (require 'doxymacs)
;;	     (doxymacs-font-lock)
;;	     )))
;; Auto enable whitespace mode in diff mode
(add-hook 'diff-mode-hook
	  (lambda ()
	    (whitespace-mode t)))
;; Remeber artist-mode can draw picutre !!!
; (define-key c-mode-base-map [(return)] 'newline-and-indent)
;(c-set-offset 'inextern-lang '0)
(setq comment-multi-line t)	 ;; 大段注释的时候， 每行的开头都是*
(c-toggle-hungry-state t)	 ;; hungry delete

(require 'flyspell)
(flyspell-prog-mode)             ;; 会对程序中的注释做拼写检查
                                        ;(hightlight-change-mode)	 ;; 会对做的修改做Hight light
(which-func-mode t)	 ;; 在状态栏显示当前函数
;; (set-variable 'show-trailing-whitespace 1) ;;有多余空格的时候高亮
;; (add-hook 'before-save-hook 'whitespace-cleanup) ;;在保存之前清除空字符

;; FFAP, find the related file.
;; (ffap-bindings)
;; 设定搜索的路径 ffap-c-path
;; (setq ffap-c-path
;;     '("/usr/include" "/usr/local/include"))
;; 如果是新文件要确认
;; (setq ffap-newfile-prompt t)
;; ffap-kpathsea-expand-path 展开路径的深度
;; (setq ffap-kpathsea-depth 5)

;; Hide & Show minor mode, usually good when looking big source file.
;(hs-minor-mode)
;;  (safe-wrap (flex-bison-init)) ; cause editor hang, remove it.

                                        ;(electric-layout-mode) ;; good control of space line.


(defconst my-speedbar-buffer-name "SPEEDBAR")


)
;; end generic programming config.

(defun color-init()
;  (load-theme 'wombat)
  )

(defun term-init()
  (require 'multi-term)
  (setq multi-term-program "/bin/bash"))

;; Auto disable theme setup before...
(defadvice load-theme
  (before theme-dont-propagate activate)
  (mapcar #'disable-theme custom-enabled-themes))

(defun toggle-night-color-theme()
  (interactive)
  (if (eq (car custom-enabled-themes) 'wombat)
      (disable-theme 'wombat) ;; after diable theme, will use default theme.
    (load-theme 'wombat)
    ))

(defun config-in-tty-mode ()
;; don't load color in tty mode.
;(color-init)
)

(defun load-python-env()
  (require 'python-mode)
  (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
 (setq interpreter-mode-alist (cons '("python" . python-mode) interpreter-mode-alist))
 (autoload 'python-mode "python-mode" "Python editing mode." t)

  (add-hook 'python-mode-hook (function cscope:hook))
  (add-hook 'python-mode-hook
            (lambda()
              (setq dash-at-point-docset "django")
          ;; JEDI document: http://tkf.github.io/emacs-jedi/latest/#jedi:key-complete
              (when (not (is-aquamacs)) (jedi:setup))
              ;; jedi have a bug will not running in acquamcs.
          (setq jedi:complete-on-dot t)
          (highlight-indentation-current-column-mode)
          ;; also can complete by C-TAB
	       (setq-default indent-tabs-mode nil)    ; use only spaces and no tabs
	       (setq default-tab-width 4)))
  (add-to-list 'load-path "~/.emacs.d/site-lisp/python/")
  (setq py-install-directory "~/.emacs.d/site-lisp/python/")
  (add-to-list 'auto-mode-alist '("\\.py?$" . python-mode))
)

(defun load-ruby-env()
;;  (autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)

;;   (add-to-list 'auto-mode-alist
;;               '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . enh-ruby-mode))
;;  (add-to-list 'auto-mode-alist
  ;;               '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . enh-ruby-mode))

   (add-to-list 'auto-mode-alist
               '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
y  (add-to-list 'auto-mode-alist
               '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))
  
;; optional
;;  (setq enh-ruby-program "(path-to-ruby1.9)/bin/ruby") ; so that still works if ruby points to ruby1.8

;; Enhanced Ruby Mode defines its own specific faces with the hook erm-define-faces. If your theme is already defining those faces, to not overwrite them, just remove the hook with:
  (remove-hook 'enh-ruby-mode-hook 'erm-define-faces)
(add-hook 'ruby-mode-hook
	  (lambda () (highlight-indentation-current-column-mode)))
(add-hook 'enh-ruby-mode-hook
          (lambda () (highlight-indentation-current-column-mode)))
(add-hook 'ruby-mode-hook 'projectile-on)
(add-hook 'coffee-mode-hook
           (lambda () (highlight-indentation-current-column-mode)))
(rvm-use-default)
(add-hook 'coffee-mode-hook
          (lambda () (highlight-indentation-current-column-mode)))
					;(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(remove-hook 'enh-ruby-mode-hook 'erm-define-faces)

(require 'rinari)
(global-rinari-mode)

(add-hook 'ruby-mode-hook(lambda() (setq dash-at-point-docset "rails")))

(add-hook 'ruby-mode-hook
	  (lambda () (flymake-ruby-load))
	  )
;(add-hook 'enh-ruby-mode-hook
;          (lambda () (flyspell-prog-mode)))

(setq enh-ruby-check-syntax nil)

(setq ruby-use-encoding-map nil)
(add-hook 'ruby-mode-hook
               (lambda ()
                 (define-key ruby-mode-map "\C-c#" 'comment-or-uncomment-region)
                 ))
(define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Gemfile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
(add-hook 'ruby-mode-hook 'hs-minor-mode)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(enh-ruby-op-face ((t (:foreground "#d9045a")))))

(add-hook 'speedbar-mode-hook
          (lambda()
            (speedbar-add-supported-extension "\\.rb")
            (speedbar-add-supported-extension "\\.ru")
            (speedbar-add-supported-extension "\\.erb")
            (speedbar-add-supported-extension "\\.rjs")
            (speedbar-add-supported-extension "\\.rhtml")
            (speedbar-add-supported-extension "\\.rake")))


)

(defun android-setup()

  ;; android create project Notes:
  ;; 1. if no build.xml, create it by
  ;; $ android update project --name $(NAME) --target $(TARGET) --path ~/development/PowerShark/
  ;; 2. The target parameter can find by 
  ;; $ android list targets
  ;; 3. then you can use android mode
  (require 'android-mode))
  

(defun load-web-env()
  (autoload 'js2-mode "js2-mode" nil t)

  (eval-after-load 'js2-mode
  '(progn
     (define-key js2-mode-map (kbd "TAB") (lambda()
                                            (interactive)
                                            (let ((yas/fallback-behavior 'return-nil))
                                              (unless (yas/expand)
                                                (indent-for-tab-command)
                                                (if (looking-back "^\s*")
                                                    (back-to-indentation))))))))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.json\\'" . js2-mode))
  (add-hook 'js2-mode-hook (lambda()
				     (custom-set-variables
				      '(js2-basic-offset 2)
				      '(js2-bounce-indent-p nil)
				      )))
  ;; Css mode indent
  (add-hook 'css-mode-hook (lambda() 
	(setq cssm-indent-function #'cssm-c-style-indenter)
	(setq cssm-indent-level 2)))

;  (require 'hl-tags-mode)
  
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(add-hook 'web-mode-hook
          (lambda () (flyspell-prog-mode)))
)

(defun load-java-relate-lib ()
(generic-programming-realted-config)
(add-hook 'java-mode-hook (function cscope:hook))
(cscope-minor-mode)
(message "load java")
(setq c-comment-start-regexp "(@|/(/|[*][*]?))")
(modify-syntax-entry ?@ "< b" java-mode-syntax-table)
(setq c-basic-offset 4
      tab-width 4
      indent-tabs-mode nil)
;;(glasses-mode nil) ;; ThisIsAVarInJava
(android-setup)
)

(defun load-c-relate-lib ()
(generic-programming-realted-config)
(cscope-minor-mode)
)

(defun if-in-tty()
(if (equal (frame-parameter nil 'font) "tty")
t
nil))

(defun config-not-in-tty-mode ()
(if (not (eq system-type 'darwin))
    ((lambda ()
;; use monaco fonts default, want to switch to Lucida, change this to nil
      (if t
	  (if (>= (x-display-pixel-height) 1080)
;       (set-default-font "Ubuntu mono-12")
;	    (set-default-font "Lucida Console-11")
	    (set-default-font "Monaco-11")
	    (set-default-font "Inconsolata-13") 
	    )
        ) nil)))
(global-visual-line-mode t)        ;; Auto truncate line  
(mouse-avoidance-mode 'animate)	;; 光标靠近鼠标的时候，　鼠标自己就跑了
(setq x-select-enable-clipboard t)	;;让X的剪切板和EMACS联系起来
(tool-bar-mode -1) ;; 不要工具按钮
(scroll-bar-mode -1) ;; 不要缩放条
(color-init))

(defun toggle-fullscreen (&optional f)
      (interactive)
      (let ((current-value (frame-parameter nil 'fullscreen)))
	(set-frame-parameter nil 'fullscreen
			     (if (equal 'fullboth current-value)
				 (if (boundp 'old-fullscreen) old-fullscreen nil)
			       (progn (setq old-fullscreen current-value)
				      'fullboth)))))
(defun cscope-setup ()
;  (print "cscope setup")
  (require 'xcscope)
  (setq cscope-do-not-update-database t)
)

(defun hightlight-80+-setup()
  (require 'highlight-80+))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; start configure work here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "/usr/share/emacs/site-lisp")
;;; if no cscope installed, ignore it.


;; Config for Mac
(if (eq system-type 'darwin)
((lambda ()
;; 为.h文件选择合适的Mode， 根据.h文件的内容来选择是什么mode
;; need find-file to do this
(add-to-list 'load-path "/opt/local/share/emacs/site-lisp")
(setq mac-option-key-is-meta t)
;(setq mac-right-option-modifier nil)
(setq exec-path (append exec-path '("/opt/local/bin")) )
(setenv "LC_CTYPE" "UTF-8")

;(set-face-attribute 'default nil
;		:family "Inconsolata" :height 165 :weight 'normal)

;(set-face-attribute 'default nil
;		:family "Ubuntu mono" :height 160 :weight 'normal)
(set-face-attribute 'default nil
		:family "Monaco" :height 145 :weight 'normal)

;; Change control and meta key under mac, make less pain...
(setq mac-command-modifier 'meta)
(setq mac-control-modifier 'control)
t
)) nil)

(defun toggle-control-position ()
  "toggle the control position bewteen alt or contorl under mac."
  (if (eq mac-command-modifier 'meta) ((lambda()
					 (setq mac-command-modifier 'control)
					 (setq mac-control-modifier 'meta)
					 (setq mac-option-modifier 'control)
					 (setq mac-option-key-is-meta t)))
    ((lambda()
       (setq mac-command-modifier 'meta)
       (setq mac-control-modifier 'control)
       (setq mac-option-key-is-meta t))))
)

(require 'find-file) ;; for the "cc-other-file-alist" variable
(nconc (cadr (assoc "\\.h\\'" cc-other-file-alist)) '(".m" ".mm"))
(defadvice ff-get-file-name (around ff-get-file-name-framework
				    (search-dirs 
				     fname-stub 
				     &optional suffix-list))
  "Search for Mac framework headers as well as POSIX headers."
   (or
    (if (string-match "\\(.*?\\)/\\(.*\\)" fname-stub)
	(let* ((framework (match-string 1 fname-stub))
	       (header (match-string 2 fname-stub))
	       (fname-stub (concat framework ".framework/Headers/" header)))
	  ad-do-it))
      ad-do-it))
(ad-enable-advice 'ff-get-file-name 'around 'ff-get-file-name-framework)
(ad-activate 'ff-get-file-name)
(setq cc-search-directories '("." "../include" "/usr/include" "/usr/local/include/*"
			      "/System/Library/Frameworks" "/Library/Frameworks"))

;; Objective C settings.
(add-to-list 'auto-mode-alist '("\\.m?$" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.mm?$" . objc-mode))
;(add-to-list 'auto-mode-alist '("\\.h$" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))



(safe-wrap (yas-setup))

(safe-wrap (ergoemacs-setup))
(safe-wrap (dash-setup))
(safe-wrap (term-init))
(safe-wrap (cscope-setup))
(safe-wrap (hightlight-80+-setup))
(safe-wrap (git-setup))
(safe-wrap (load-python-env))
(safe-wrap (load-ruby-env))
(safe-wrap (load-web-env))
;;(safe-wrap (elscreen-setup))
(safe-wrap (fic-mode-setup))
(setq Man-notify-method 'pushy)
(setq-default kill-whole-line t)	;; 在行首 C-k 时，同时删除该行。
(defalias 'qrr 'query-replace-regexp)   ;; regexp query.


;; (global-set-key [kp-insert] 'overwrite-mode) ; [Ins]
(global-set-key [f2] 'git-grep)	 ;; Git grep.
;; F3 start micro
;; F4 reply micro
(global-set-key [f5] 'revert-buffer)
(global-set-key [f6] 'ff-find-related-file) ;; Find header file.
(global-set-key [f7] 'grep-find)
(global-set-key [f8] 'compile)
(global-set-key [f9] 'gdb)
(global-set-key [f10] 'sr-speedbar-toggle)
(global-set-key [\M-f10] 'sr-speedbar-toggle)
(global-set-key [f12] 'org-todo-list)
(global-set-key [\M-f12] 'org-todo-list) ;; mac use

(global-set-key[\M-f9] 'toggle-night-color-theme)

(global-set-key [\M-f11] 'toggle-control-position)

(global-set-key (kbd "C-z")  'undo)  ;; undo by C-z
(global-set-key (kbd "M-z")  'undo)  ;; undo by C-z
(global-set-key (kbd "M-s")  'occur)
(global-set-key (kbd "C-9")  'other-window)
(global-set-key (kbd "C-0")  'delete-window)
(global-set-key (kbd "C--")  'split-window-below)
(global-set-key (kbd "C-=")  'split-window-right)

(global-set-key (kbd "C-h") 'forward-char)
(global-set-key (kbd "C-j") 'previous-line)
;(global-set-key (kbd "C-k") 'next-line)
;(global-set-key (kbd "C-l") 'backward-char)
;(global-set-key (kbd "C-l") 'forward-char)
;(global-set-key (kbd "C-k") 'previous-line)
(global-set-key (kbd "C-j") 'next-line)
(global-set-key (kbd "C-h") 'backward-char)
(global-set-key (kbd "M-SPC") 'set-mark-command)
(global-set-key (kbd "C-`") 'other-window)
(global-set-key (kbd "M-`") 'other-window)


;(global-set-key (kbd "c-c c-j")  [?\c-x ?b return]) ;; Switch back to pervious windows.
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
 
;(global-set-key "\C-xl" 'goto-line)	;; used to goto line

(put 'upcase-region 'disabled nil)	;; 打开C－x c－u把区域变成大写的功能
;; 自动补全的尝试列表
;; (global-set-key [(meta ?/)] 'hippie-expand)
;(autoload 'senator-try-expand-sematic "senator")
(setq hippie-expand-try-functions-list
'(
senator-try-expand-sematic
;; try-expand-line
;; try-expand-line-all-buffers
try-expand-list
try-expand-list-all-buffers
try-expand-dabbrev
try-expand-dabbrev-visible
try-expand-dabbrev-all-buffers
try-expand-dabbrev-from-kill
try-complete-file-name
try-complete-file-name-partially
try-complete-lisp-symbol
try-complete-lisp-symbol-partially
;;	try-expand-whole-kill
))

(setq speedbar-use-images nil)  ;; don't use image in  speedbar.
(make-face 'speedbar-face)
(set-face-font 'speedbar-face "Inconsolata-15")
(setq speedbar-mode-hook '(lambda () (buffer-face-set 'speedbar-face)))

(require 'smartparens-config)
(require 'smartparens-ruby)
(smartparens-global-mode)
(show-smartparens-global-mode)
(sp-with-modes '(rhtml-mode)
  (sp-local-pair "<" ">")
  (sp-local-pair "<%" "%>"))

;; for object-c.
(add-hook 'objc-mode-hook
          (lambda ()
;;          (message "objc modeb hook start")
            (setq cscope-do-not-update-database nil)
            (load-c-relate-lib)
            (when (not (is-aquamacs)) (turn-on-auto-revert-mode))
            (setq indent-tabs-mode nil)
;;          (flymode-init)
            (c-set-style "cc-mode")
            (setq c-basic-offset 4
                  tab-width 4
                  indent-tabs-mode nil)

;;	    (highlight-80+-mode)
;;	    (setq highlight-80+-columns 200) ;; hight light 100+ colums
            (cscope-minor-mode)))


;; For linux kernel
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
            (message "c common hook")
	    ;; Add kernel style
	    (c-set-offset 'inextern-lang 0)
	    ;; This cc style disable the name space indent.
	    (defconst my-cc-style
	      '("cc-mode"
		(c-offsets-alist . ((innamespace . [0])))
		(c-electric-pound-behavior     . 'alignleft)
		;; Some more cc mode's cleanup settings.
		(c-cleanup-list . (brace-else-brace
				   brace-elseif-brace
				   brace-catch-brace
				   empty-defun-braces
				   defun-close-semi
				   list-close-comma
				   scope-operator))))
            (c-add-style "my-cc-style" my-cc-style)

	    (c-add-style
	     "linux-tabs-only"
	     '("linux" (c-offsets-alist
			(arglist-cont-nonempty
			 c-lineup-gcc-asm-reg
			 c-lineup-arglist-tabs-only))
               (setq-default indent-tabs-mode t)))
))

(add-hook 'c-mode-hook
	  (lambda ()
             (load-c-relate-lib)
             (setq c-basic-offset 4
                   tab-width 4
                   indent-tabs-mode nil)
             (let ((filename (buffer-file-name)))
               ;; Enable kernel mode for the appropriate files
               (when (and filename
                          (or (string-match "linux" filename)
                              (string-match "kernel" filename)))
                 ;; or like this: (string-match (expand-file-name "~/src/linux-trees")
                 (c-set-style "linux-tabs-only")
                 ;; for kernel, hightlight 80 chars more line.
                 (highlight-80+-mode)
                 ))))

(add-hook 'c++-mode-hook
(lambda ()
(load-c-relate-lib)
(c-set-style "my-cc-style")
(setq c-basic-offset 4
      tab-width 4
      indent-tabs-mode nil)
))

(add-hook 'java-mode-hook
(lambda ()
;   (message "with java mode hook")
   (when (not (is-aquamacs)) (turn-on-auto-revert-mode)) ; Auto reload file, if want to enable this global, use (global-auto-revert-mode 1)
   (load-java-relate-lib)))

(remove-hook 'find-file-hooks 'vc-find-file-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	 日常的配置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq mail-signature "Jiejing")

(setq org-log-done 'time)
;(setq org-log-done 'note)

(require 'cl)
;; filter not exist files, otherwise agenda mode will report error
(require 'cl)
(setq org-agenda-files (remove-if 'nil (mapcar (lambda (x)
	  (if (file-exists-p x)
	      x
	    nil))
   (list "~/org/app.org"
   "~/Google 云端硬盘/Nvidia Notes/nvidia_notes.org"
   "~/org/todo.org"
   "~/SyncDrive/Nvidia Notes/nvidia_notes.org"))))

(global-set-key "\C-ca" 'org-agenda)
(prefer-coding-system 'utf-8)
;; Navigate between windows using Alt-1, Alt-2, Shift-left, shift-up, shift-right
(windmove-default-keybindings)

;; http://www.emacswiki.org/emacs/MultiTerm

(projectile-global-mode t)   ;; project mode, https://github.com/bbatsov/projectile
;; 
(setq projectile-enable-caching nil)
(setq projectile-completion-system 'grizzl)
(setq projectile-completion-system 'grizzl)
 ;; Press Command-p for fuzzy find in project
(global-set-key (kbd "s-p") 'projectile-find-file)
 ;; Press Command-b for fuzzy switch buffer
(global-set-key (kbd "s-b") 'projectile-switch-to-buffer)

(require 'ido)
(require 'ibuffer)
;(setq ido-auto-merge-work-directories-length -1)
(ido-mode)                             ;Ido mode really good.


(setq-default truncate-lines nil) ;; 自动折行
(auto-compression-mode 1) ;; 打开压缩文件时自动解压缩
(auto-image-file-mode)	 ;; 自动打开图片模式
(column-number-mode 1) ;; 显示列号
(blink-cursor-mode -1) ;; 光标不要闪烁
(show-paren-mode 1) ;; 高亮显示匹配的括号
(icomplete-mode t)	 ;; 给出用 M-x foo-bar-COMMAND 输入命令的提示。
(defalias 'list-buffers 'ibuffer)
;; (menu-bar-mode -1)	 ;; 不要 menu-bar。
;;(autoload 'big5togb-region "big5togb" "Big5 to GB2312" t)
;;【big5togb.el】ZSH 写的将 big5 文本转为 gb2312 的包。

(setq transient-mark-mode nil)	 ;; 两次按C－space以后高亮显示区域
(setq inhibit-startup-message t)	;; 不显示 Emacs 的开始画面
(setq default-major-mode 'text-mode)	;; 任意的打开一个新文件时，缺省使用 text-mode。
(setq visiable-bell t)	 ;; 把嘟的声音去掉
(setq ring-bell-function 'ignore)	;; 不要让那个DIDI的响
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-interval 10)	 ;; 在 mode-line 上显示时间。
(display-time)
(setq require-final-newline t)
(setq track-eol t)
(setq suggest-key-bindings 1)	 ;; 当使用 M-x COMMAND 后，过 1 秒钟显示该 COMMAND 绑定的键。
(setq line-number-display-limit 100000000);; 当行数超过一定数值，不再显示行号。
(setq kill-ring-max 200)	 ;; kill-ring 最多的记录个数。
(setq bookmark-save-flag 1)
;; 每当设置书签的时候都保存书签文件，否则只在你退出 Emacs 时保存。
; (setq bookmark-default-file "~/.emacs.d/.emacs.bmk")
;; 缺省书签文件的路径及文件名。
(setq version-control t)
(setq kept-old-versions 2)
(setq kept-new-versions 5)
(setq delete-old-versions t)
(setq backup-directory-alist '(("." . "~/emacs.bak")))
(setq backup-by-copying t)
;; Emacs 中，改变文件时，默认都会产生备份文件(以 ~ 结尾的文件)。可以完全去掉
;; (并不可取)，也可以制定备份的方式。这里采用的是，把所有的文件备份都放在一
;; 个固定的地方("~/var/tmp")。对于每个备份文件，保留最原始的两个版本和最新的
;; 五个版本。并且备份的时候，备份文件是复本，而不是原件。
(ansi-color-for-comint-mode-on)	 ;; 消除shell中的乱码
(fset 'yes-or-no-p 'y-or-n-p)	 ;; 把Yes或者用y代替
;; (cua-mode t)	 ;; something like CTRL-V is copy
(set-keyboard-coding-system 'chinese-iso-8bit) ;; 键盘输入，用于输入法。
(set-terminal-coding-system 'chinese-iso-8bit) ;; 终端显示的编码方式。
(set-clipboard-coding-system 'chinese-iso-8bit) ;; 剪切板，用于和其他程序之间复制内容
(set-clipboard-coding-system 'ctext) ;;解决firefox有时候复制文件有乱马

(if (eq system-type 'darwin)
    (setq ispell-dictionary "english")
  (setq ispell-dictionary "american"))
(add-hook 'comint-output-filter-functions
'comint-watch-for-password-prompt) ;; 密码的相关的提示密码

;; Full screen settings.
;; Needs Mac configure of full screen
(global-set-key (kbd "C-M-RET")		'toggle-fullscreen)
(global-set-key (kbd "C-M-<return>")	'toggle-fullscreen)

;; Set a visible bell function...
;(setq visible-bell nil)
;(setq ring-bell-function `(lambda ()
;                            (set-face-background 'default "DodgerBlue")
;                            (set-face-background 'default "black")))

;; remove the startup message.
(setq inhibit-splash-screen t)

;;(load "desktop")
;;(desktop-load-default)
;;(desktop-read)

(setq search_highlight t)

;; Ask question when C-x, C-c.
(setq kill-emacs-query-functions
(lambda() (y-or-n-p "Do you really want to quit?")))

;; For daemon mode
(add-hook 'after-make-frame-functions
(lambda (frame)
(with-selected-frame frame
(when window-system
(config-not-in-tty-mode)
(config-in-tty-mode)))))

;; Non-deamon mode config
;(if (equal (daemonp) nil)
(if (equal (if-in-tty) nil)
(config-not-in-tty-mode)
(config-in-tty-mode))
;)

;; tramp is a remote file access mode, default enable.
(require 'tramp)
(setq tramp-chunksize 500) ;;; maybe help on large trunk..
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))
(defun sudo-edit-current-file ()
  (interactive)
  (let ((position (point)))
    (find-alternate-file
     (if (file-remote-p (buffer-file-name))
         (let ((vec (tramp-dissect-file-name (buffer-file-name))))
           (tramp-make-tramp-file-name
            "sudo"
            (tramp-file-name-user vec)
            (tramp-file-name-host vec)
            (tramp-file-name-localname vec)))
       (concat "/sudo:root@localhost:" (buffer-file-name))))
    (goto-char position)))

;; copy from :https://gist.github.com/offby1/1240799
;; There's something similar (but fancier) in vc-git.el: vc-git-grep
;; -I means don't search through binary files
;; --no-color, oddly enough, is required to allow emacs to colorize the output

(defcustom git-grep-switches "--extended-regexp -I -n --ignore-case --no-color"
  "Switches to pass to `git grep'."
  :type 'string)

(defcustom git-grep-default-work-tree (expand-file-name "~/work/adtrack")
  "Top of your favorite git working tree.  \\[git-grep] will search from here if it cannot figure out where else to look."
  :type 'directory
  )

(when (require 'vc-git nil t)

  ;; Uncomment this to try out the built-in-to-Emacs function.
  ;;(defalias 'git-grep 'vc-git-grep)

  (defun git-grep (command-args)
    (interactive
     (let ((root (vc-git-root default-directory)))
       (when (not root)
         (setq root git-grep-default-work-tree)
         (message "git-grep: %s doesn't look like a git working tree; searching from %s instead" default-directory root))
       (list (read-shell-command "Run git-grep (like this): "
                                 (format (concat
                                          "cd %s && "
                                          "git --no-pager grep %s -e %s")
                                         root
                                         git-grep-switches
                                         (let ((thing (and

                                        ; don't snarf stuff from the
                                        ; buffer if we're not looking
                                        ; at a file.  Perhaps we
                                        ; should also check to see if
                                        ; the file is part of a git
                                        ; repo.
                                                       buffer-file-name
                                                       (thing-at-point 'symbol))))
                                           (or (and thing (progn
                                                            (set-text-properties 0 (length thing) nil thing)
                                                            (shell-qeuote-argument (regexp-quote thing))))
                                               "")))
                                 'git-grep-history))))
    (let ((grep-use-null-device nil))
      (grep command-args))))

;; Kill warnning..
(when (and (>= emacs-major-version 24)
(>= emacs-minor-version 2))
(eval-after-load "mumamo"
'(setq mumamo-per-buffer-local-vars
(delq 'buffer-file-name mumamo-per-buffer-local-vars))))

(defun is-aquamacs()
(if (boundp 'aquamacs-version)
    t
  nil))

(when (boundp 'aquamacs-version)
 (global-set-key [M-left] 'tabbar-backward-tab)
 (global-set-key [M-right] 'tabbar-forward-tab)
 (one-buffer-one-frame-mode 0)
 (tabbar-mode 0)
(add-hook 'after-init-hook (lambda () (set-cursor-color "#aa88dd")) 'append)
(smartparens-global-mode 0) ;; aquamacs some how have issue with this mode, will not able to type Cap char.
(setq-default cursor-type 'box)
; (aquamacs-autoface-mode nil)
(set-face-attribute 'default nil :height 145)
;; scale the font, default scale is too large.
)


;; 开启服务器模式
;(Server-force-delete)
;(server-start)
;; 用Daemon替代


;; Start useful functions.

(defun dpi  (xres yres inch)
  "return  screen dpi from resolution and inch of screen."
   (/ (sqrt (+ (expt (float xres) 2)
	       (expt (float yres) 2)))
      (float inch)))



(defun long-edge (a b)
  (sqrt (+ (* a a) (* b b))))

(defun average-ration(x y)
  (/ (abs (- y x))  (/ (+ x y) 2)))

(defun page2mb (page-number)
  "Define a function conv page number to MB"
 (/ (* page-number 4) 1024))
(put 'set-goal-column 'disabled nil)


;;;  Tips Section ;;; 

;;; M-^  -->   delete-indention: make current line connect with last line,
;;; very usuful when change multi line to one line, which I often did.

;;; M-m  -->   jump to first char in this line 's indent.

;;; hightlight-change-mode: it will height light the changes you make in whole process.

;;; M-x re-builder   --> this function can test the regex in live.

;;; M-\             --> will delete all space around

;;; save-buffers-kill-emacs’  --> without process-killing query, save all buffers and quit emacs directly.


;;; use tramp to transpsete access a file in remote.
;;; access file like this:
;;; 
;;; C-x C-f /remotehost:filename  RET (or /method:user@remotehost:filename)
;;;
;;; if you want sudo open some file, 
;;; C-x C-f /sudo::/etc/host  RET
;;;
;;; will auto download the file, and save the file...
;;; Wiki for full tricks: http://www.emacswiki.org/emacs/TrampMode

;;; Q: emacs init too slow ?
;;; A: use this command to profile:
;;;    emacs -Q -l ~/myconfigure/profile-dotemacs.el -f profile-dotemacs

(defun package-install-refrash-package()
  (require 'package)
  (interactive)
  (package-refresh-contents)
  (package-install 'dash-at-point)
  (package-install 'rinari)
  (package-install 'yasnippet)
  (package-install 'yasnippet-bundle)
  (package-install 'web-mode)
  (package-install 'js2-mode)
  (package-install 'multi-term)
;  (package-install 'python-mode)
  (package-install 'jedi)
  (package-install '2048-game)
  (jedi:install-server)
  (package-install 'highlight-indentation)
  (package-install 'rvm)
  (package-install 'grizzl)
  (package-install 'projectile)
  (package-install 'smartparens)
  (package-install 'yaml-mode)
  (package-install 'ag)
  (package-install 'magit)
;  (package-install 'enh-ruby-mode) ; this package will disable yasnnipe, no need.
  (package-install 'rinari)
  (package-install 'flymake-ruby)
  (package-install 'sr-speedbar)
;  (package-install 'ergoemacs-mode)
  )

;; fix sr-speedbar 24.4 function miss error
(defun ad-advised-definition-p (definition) 
"Return non-nil if DEFINITION was generated from advice information." 
(if (or (ad-lambda-p definition) 
        (macrop definition) (ad-compiled-p definition)) 
    (let ((docstring (ad-docstring definition)))
      (and (stringp docstring)
           (get-text-property 0 ‘dynamic-docstring-function docstring)))))
