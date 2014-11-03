;; source :: http://www.emacswiki.org/emacs/start.el

(provide 'start)
(require 'start) ;; Ensure this file is loaded before compile it.

;; end of source

(add-to-list 'load-path "~/.emacs.d")

(load-file "/str/development/projects/open-source/elisp/ef.el/ef.el")

(defmacro defhook (body)
  `(lambda ()
     (interactive)
     (,@body)))

(defun turn-on-mode (mode)
  (interactive)
  (funcall mode))

(require 'package)

(setq package-archives '(("org"          . "http://orgmode.org/elpa/")
                         ("gnu"          . "http://elpa.gnu.org/packages/")
             ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
                         ("melpa"        . "http://melpa.milkbox.net/packages/")
                         ("marmalade"    . "http://marmalade-repo.org/packages/")))

(package-initialize)


(add-to-list 'load-path "/str/development/projects/open-source/elisp/bisect.el/")
(require 'bisect)
(bisect-load)

(let ((sensitive-file "~/.emacs.d/sensitive.el"))
  (when (file-readable-p sensitive-file)
    (load-file sensitive-file)))

;; (require 'test-bisect)



(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'cl)

;; from https://gist.github.com/gnuvince/1869094
;; General settings
(setq user-full-name "Andrey Tykhonov"
      user-mail-address "atykhonov@gmail.com"
      inhibit-startup-message t
      major-mode 'fundamental-mode
      next-line-add-newlines nil
      scroll-step 1
      scroll-conservatively 1
                                        ; font-lock-maximum-decoration t
      require-final-newline t
      truncate-partial-width-windows nil
      shift-select-mode nil
      echo-keystrokes 0.1
      x-select-enable-clipboard t
      mouse-yank-at-point t
      custom-unlispify-tag-names nil
      ring-bell-function '(lambda ()))

(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; highlight current line
(global-hl-line-mode t) ;; To enable
(set-face-background 'hl-line "gray18") ;; change with the color that you like
;; for a list of colors: http://raebear.net/comp/emacscolors.html
(setq inhibit-splash-screen t)
(transient-mark-mode 1)
(global-font-lock-mode 1)
(setq jit-lock-defer-time 0.05)

;; (require 'demi-appearance)

(display-battery-mode)

;; (require 'demi-battery-mode)

;; Buffcycle - simple Buffer cycling for Emacs between file buffers

(load-file "~/.emacs.d/buffcycle.el")
(require 'buffcycle)

;; Development tool which may help to bump versions

(add-to-list 'load-path "/str/development/projects/open-source/elisp/emacs-bump-version/")
(require 'bump-version)

(global-set-key (kbd "C-c C-b p") 'bump-version-patch)
(global-set-key (kbd "C-c C-b i") 'bump-version-minor)
(global-set-key (kbd "C-c C-b m") 'bump-version-major)

;; Cedet

(semantic-mode 1)

(add-to-list 'load-path "/str/development/projects/open-source/elisp/cedet/contrib")

(require 'eassist)

(eval-after-load "eassist"
  '(global-set-key [f3] 'psw-switch-function))

;; Color Identifiers Mode

(add-to-list 'load-path "/str/development/projects/open-source/elisp/color-identifiers-mode/")

(require 'color-identifiers-mode)
(add-hook 'emacs-lisp-mode-hook 'color-identifiers-mode)

(setq global-color-identifiers-mode t)

;; ???

(add-hook 'comint-output-filter-functions
          'comint-watch-for-password-prompt)

;; cu - function which allows to quickly cd to the home directory of the given user

(defun system-users ()
  (split-string
   (shell-command-to-string "grep -o '^[^:]*' /etc/passwd | tr '\n' ' '") " "))

(defun cu (user)
  "cd to the USER's home directory."
  (interactive
   (list
    (completing-read "User: " (system-users))))
  (setq default-directory
        (replace-regexp-in-string "\n" "" (shell-command-to-string
                                           (format "grep %s /etc/passwd | cut -f 6 -d :" user))))
  (call-interactively 'ido-find-file))

;; cursor-chg - makes cursor much more interactive. Love this mode very much!

(require 'cursor-chg)  ; Load this library
(change-cursor-mode 1) ; On for overwrite/read-only/input mode
(toggle-cursor-type-when-idle 1) ; On when idle

(setq curchg-default-cursor-color "light blue")

;; dictem - Emacs interface to the dictem

(add-to-list 'load-path (expand-file-name "~/.emacs.d/dictem-1.0.4"))
(require 'dictem)

(setq dictem-server "localhost")
(dictem-initialize)
(define-key mode-specific-map [?s] 'dictem-run-search)
(global-set-key "\C-cs" 'dictem-run-search)
(global-set-key "\C-cm" 'dictem-run-match)

(define-key dictem-mode-map [tab] 'dictem-next-link)
(define-key dictem-mode-map [(backtab)] 'dictem-previous-link)

;; For creating hyperlinks on database names and found matches.
;; Click on them with `mouse-2'
(add-hook 'dictem-postprocess-match-hook
          'dictem-postprocess-match)

;; For highlighting the separator between the definitions found.
;; This also creates hyperlink on database names.
(add-hook 'dictem-postprocess-definition-hook
          'dictem-postprocess-definition-separator)

;; For creating hyperlinks in dictem buffer that contains definitions.
(add-hook 'dictem-postprocess-definition-hook
          'dictem-postprocess-definition-hyperlinks)

;; For creating hyperlinks in dictem buffer that contains information
;; about a database.
(add-hook 'dictem-postprocess-show-info-hook
          'dictem-postprocess-definition-hyperlinks)

;; Dired and Dired+ configuration

(setq dired-listing-switches "-alGh")

(defun demi/dired-load-hook ()
  (interactive)
  (load "dired-x"))

(add-hook 'dired-load-hook 'demi/dired-load-hook)

(require 'dired+)

;; dired-details configuration

;; (add-to-list 'load-path "~/.emacs.d/el-get/dired-details/")

(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "* ")

;; discover

(require 'discover)
(global-discover-mode 1)

;; edebug configuration

;; Did you know edebug has a trace function? I didn't. Thanks, agumonkey!
(setq edebug-trace t)

;; While edebugging, use T to view a trace buffer
;; (*edebug-trace*). Emacs will quickly execute the rest of your code,
;; printing out the arguments and return values for each expression it
;; evaluates.  Eldoc provides minibuffer hints when working with
;; Emacs Lisp.

;; detachable cursor - experimental package

(require 'demi-detachable-cursors)

;; Some key bindings for the text editing

(global-set-key (kbd "H-k") 'kill-line)
(global-set-key (kbd "H-s") 'save-buffer)
(global-set-key (kbd "<XF86Tools>") 'save-buffer)

(defun demi/end-of-line-return ()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))

(defun demi/end-of-line-insert ()
  (interactive)
  (end-of-sexp)
  (newline-and-indent)
  (yank))

(global-set-key (kbd "S-<return>") 'demi/end-of-line-return)
(define-key global-map (kbd "RET") 'newline-and-indent)

;; eshell configuration

(setq eshell-cmpl-cycle-completions nil
      eshell-save-history-on-exit t
      eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\)/\\'")

(setenv "PATH"
        (concat
         "/usr/local/bin:/usr/local/sbin:"
         (getenv "PATH")))

(setenv "PAGER" "cat")

(defalias 'e 'find-file)
(defalias 'emacs 'find-file)

(defalias 'ee 'find-file-other-window)

(defun eshell/gst (&rest args)
  (magit-status (pop args) nil))

(defun eshell/oo ()
  (cd "/str/development/projects/open-source/"))

(defun eshell/today ()
  (org-batch-agenda "a"))
  ;; (save-window-excursion (prog1 (org-batch-agenda "a") (message ""))))

(defun eshell/todo ()
  (save-window-excursion (prog1 (org-batch-agenda "t") (message ""))))

(defun gt (source-language target-language text)
  (let ((translated-text ""))
    (save-window-excursion
      (google-translate-translate source-language target-language text)
      (message "")
      (with-current-buffer "*Google Translate*"
        (buffer-substring-no-properties (point-min) (point-max))))))

(defun eshell/l (&rest args)
  (dired (pop args) nil))

(eval-after-load 'esh-opt
  '(progn
     (require 'em-cmpl)
     (require 'em-prompt)
     (require 'em-term)
     ;; TODO: for some reason requiring this here breaks it, but
     ;; requiring it after an eshell session is started works fine.
     ;; (require 'eshell-vc)
     (setenv "PAGER" "cat")
     ; (set-face-attribute 'eshell-prompt nil :foreground "turquoise1")
     (add-hook 'eshell-mode-hook ;; for some reason this needs to be a hook
               '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-bol)))
     (add-hook 'eshell-mode-hook
               '(lambda nil
                  (add-to-list 'eshell-visual-commands "ssh")
                  (add-to-list 'eshell-visual-commands "tail")))
     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
                  '("gunzip" "gz\\'"))
     (add-to-list 'eshell-command-completions-alist
                  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))
     ;; (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)
))

(defmacro with-face (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

(defun shk-eshell-prompt ()
  (let ((header-bg "#fff")
        (face 'bongo-unfilled-seek-bar))
    (concat
     ;; (with-face (concat (eshell/pwd) " ") face)
     ;; (with-face (format-time-string "(%Y-%m-%d %H:%M) " (current-time)) face)
     ;; (with-face
     ;;  (or (ignore-errors (format "(%s)" (vc-responsible-backend default-directory))) ""))
     ;; (with-face "\n" face)
     (with-face user-login-name 'clojure-test-failure-face)
     "@"
     (with-face "localhost" 'clojure-test-success-face)
     (if (= (user-uid) 0)
         (with-face " #" :foreground "red")
       " $")
     " ")))

(setq eshell-prompt-function 'shk-eshell-prompt)
(setq eshell-highlight-prompt nil)

;; expand-region configuration

(require 'expand-region)
(global-set-key (kbd "H-r") 'er/expand-region)
(global-set-key (kbd "<XF86Launch8>") 'er/expand-region)

;; ido configuration

(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

(setq ido-decorations                                                      ; Make ido-mode display vertically
      (quote
       ("\n-> "           ; Opening bracket around prospect list
        ""                ; Closing bracket around prospect list
        "\n   "           ; separator between prospects
        "\n   ..."        ; appears at end of truncated list of prospects
        "["               ; opening bracket around common match string
        "]"               ; closing bracket around common match string
        " [No match]"     ; displayed when there is no match
        " [Matched]"      ; displayed if there is a single match
        " [Not readable]" ; current diretory is not readable
        " [Too big]"      ; directory too big
        " [Confirm]")))   ; confirm creation of new file or buffer

(add-hook 'ido-setup-hook                                                  ; Navigate ido-mode vertically
          (lambda ()
            (define-key ido-completion-map [down] 'ido-next-match)
            (define-key ido-completion-map [up] 'ido-prev-match)
            (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
            (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
            (define-key ido-completion-map (kbd "H-h") 'ido-next-match)
            (define-key ido-completion-map (kbd "H-t") 'ido-prev-match)))

;; iedit configuration

(require 'iedit)

(defun iedit-dwim (arg)
  "Starts iedit but uses \\[narrow-to-defun] to limit its scope."
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (if iedit-mode
            (iedit-done)
          ;; `current-word' can of course be replaced by other
          ;; functions.
          (narrow-to-defun)
          (iedit-start (current-word) (point-min) (point-max)))))))

;; Pretify look and feel of scratch buffer on start up

(defvar initial-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c c") 'lisp-interaction-mode)
    (define-key map (kbd "C-c C-c") 'lisp-interaction-mode)
    map)
  "Keymap for `initial-mode'.")

(define-derived-mode initial-mode nil "Initial"
  "Major mode for start up buffer.
\\{initial-mode-map}"
  (setq-local text-mode-variant t)
  (setq-local indent-line-function 'indent-relative))

(setq initial-major-mode 'initial-mode
      initial-scratch-message "
;; ╔═╗┌┬┐┌─┐┌─┐┌─┐  ┬┌─┐  ┌─┐┬ ┬┌─┐┌─┐┌─┐┌┬┐┌─┐┬
;; ║╣ │││├─┤│  └─┐  │└─┐  ├─┤│││├┤ └─┐│ ││││├┤ │
;; ╚═╝┴ ┴┴ ┴└─┘└─┘  ┴└─┘  ┴ ┴└┴┘└─┘└─┘└─┘┴ ┴└─┘o
;;
;;                   __         _,******
;;               ,-----,        _  _,**
;;               | Mu! |          _   ____,****
;;               ;-----;        _
;;                    \\   ^__^
;;                     \\  (^^)\\_______
;;                       ^-(..)\\       )\\/\\/^_^
;;                             ||----w |
;;              __.-''*-,.,____||_____||___,_.-
;;                   ''     ''

")

;; jumpc configuration

(require 'jumpc)
(jumpc)
(jumpc-bind-vim-key)

;; js configuration

(setq js-indent-level 4)

;; config look and feel of fringes

(require 'git-gutter)
(global-git-gutter-mode +1)

(setq-default left-fringe-width 20)

(add-hook 'python-mode-hook 'git-gutter-mode)
(add-hook 'lisp-mode-hook 'git-gutter-mode)

(require 'fringe-helper)

(require 'git-gutter-fringe)
(global-git-gutter-mode +1)
(setq-default indicate-buffer-boundaries 'left)
(setq-default indicate-empty-lines +1)

;; google-translate

(add-to-list 'load-path "/str/development/projects/open-source/elisp/google-translate/")
(require 'google-translate)
(require 'google-translate-smooth-ui)

(global-set-key (kbd "\C-c g t") 'google-translate-smooth-translate)

(setq google-translate-show-phonetic t)
(setq google-translate-input-method-auto-toggling t)
(setq google-translate-preferable-input-methods-alist '((nil . ("en"))
                   (ukrainian-programmer-dvorak . ("ru" "uk"))))

(setq google-translate-translation-directions-alist
      '(("en" . "ru")
        ("ru" . "en")
        ("en" . "uk")
        ("uk" . "en")
        ("uk" . "ru")
        ("ru" . "uk")))

;; google-this mode

(require 'google-this)
(google-this-mode 1)

;; configure gpg-agent

;; prompt for the password in the Emacs minibuffer (instead of using a
;; graphical password prompt for gpg)
(setenv "GPG_AGENT_INFO" nil)

;; guide-key-mode

(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x r" "C-x 4"))
(guide-key-mode 1)  ; Enable guide-key-mode

(defun demi/guide-key-org-mode-hook ()
  (guide-key/add-local-guide-key-sequence "C-c")
  (guide-key/add-local-guide-key-sequence "C-c C-x")
  (guide-key/add-local-highlight-command-regexp "org-"))

(add-hook 'org-mode-hook 'demi/guide-key-org-mode-hook)

;; erc configuration

(setq erc-hide-list '("JOIN" "QUIT"))

(defun bitlbee ()
  "Connect to IM networks using bitlbee."
  (interactive)
  (erc :server "localhost" :port 6667 :nick "demi"))

(defmacro asf-erc-bouncer-connect (command server port nick ssl pass)
  "Create interactive command `command', for connecting to an IRC server. The
   command uses interactive mode if passed an argument."
  (fset command
        `(lambda (arg)
           (interactive "p")
           (if (not (= 1 arg))
               (call-interactively 'erc)
             (let ((erc-connect-function ',(if ssl
                                               'erc-open-ssl-stream
                                             'open-network-stream)))
               (erc :server ,server :port ,port :nick ,nick :password ,pass))))))

(asf-erc-bouncer-connect erc-freenode "irc.freenode.net" 6667 "andrik" nil nil)
(asf-erc-bouncer-connect erc-twice "rc.twice-irc.de" 6667 "andrik" nil nil)

;; fires up a new frame and opens your servers in there. You will need
;; to modify it to suit your needs.
(defun my-irc ()
  "Start to waste time on IRC with ERC."
  (interactive)
  (call-interactively 'erc-freenode)
  (sit-for 1)
  (call-interactively 'erc-open))


(setq erc-autojoin-channels-alist
      '(("freenode.net" "#emacs" "#org-mode"
         "#hacklabto" "##linux" "#wiki"
         "#nethack" "#gnustep" "#gentoo" "django-cms")
        ("oftc.net" "#bitlbee")
        ("rc.twice-irc.de" "#i3")))

(setq erc-keywords '("demi" "demi:"
                     "fsbot:"
                     "howdoi" "Google Translate"
                     "google-translate"))
(erc-match-mode)
(erc-track-mode t)

(add-hook 'erc-mode-hook
          '(lambda ()
             (flyspell-mode)
             (pcomplete-erc-setup)
             (erc-completion-mode 1)))

(erc-fill-mode t)
(setq erc-fill-column 70)
(setq scroll-conservatively 123) ;; any number higher then 100
(erc-ring-mode t)
(erc-netsplit-mode t)
(erc-timestamp-mode t)
(setq erc-timestamp-format "[%R-%m/%d]")
(erc-button-mode nil)

;; logging:
(setq erc-log-insert-log-on-open t)
(setq erc-log-channels t)
(setq erc-log-channels-directory "~/.irclogs/")
(setq erc-save-buffer-on-part t)
(setq erc-hide-timestamps nil)

(setq erc-max-buffer-size 20000)
(defvar erc-insert-post-hook)
(add-hook 'erc-insert-post-hook 'erc-truncate-buffer)
(setq erc-truncate-buffer-on-save t)

;; Clears out annoying erc-track-mode stuff for when we don't care.
;; Useful for when ChanServ restarts :P
(defun reset-erc-track-mode ()
  (interactive)
  (setq erc-modified-channels-alist nil)
  (erc-modified-channels-update))

(add-hook 'erc-after-connect
          '(lambda (SERVER NICK)
             (erc-message (format "PRIVMSG" "NickServ identify %s"
                                  demi/short-password))))

(defun browse-previous-link ()
  (interactive)
  (org-previous-link)
  (find-file-at-point))

(define-key erc-mode-map (kbd "H-p") 'browse-previous-link)

;; emacs-lisp-mode

(setq lispy-no-space t)

(defun demi/lisp-mode-hook ()
  (interactive)
  (lispy-mode 1))

(add-hook 'lisp-mode-hook 'demi/lisp-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'demi/lisp-mode-hook)

;; ezbl configuration

(add-to-list 'load-path "/str/development/projects/open-source/ezbl/")
(require 'ezbl)

;; fancy narrow
;; (require 'fancy-narrow)

;; fci

(setq fci-rule-width 12)

(defun fci-mode-with-rule-column (rule-column)
  (setq fci-rule-column rule-column)
  (fci-mode))

(defun fci-mode-72 ()
  (interactive)
  (fci-mode-with-rule-column 72))

(defun fci-mode-80 ()
  (interactive)
  (fci-mode-with-rule-column 80))

(defun fci-mode-100 ()
  (interactive)
  (fci-mode-with-rule-column 100))

(defun fci-mode-120 ()
  (interactive)
  (fci-mode-with-rule-column 120))

;; feature-mode

(add-to-list 'load-path "/str/development/projects/open-source/elisp/cucumber.el/")

(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;; fill-column

(defun set-fill-column-num (num)
  (set-fill-column num))

(defun set-fill-column-100 ()
  (interactive)
  (set-fill-column-num 100))

;; flycheck

(require 'flycheck)

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

;; flyspell configuration

(defun flyspell-mode-enable-hook ()
  (interactive)
  (flyspell-mode))

(dolist (hook '(text-mode-hook org-mode-hook magit-log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

;; (dolist (hook '(change-log-mode-hook log-edit-mode-hook org-agenda-mode-hook))
;;   (add-hook hook (lambda () (flyspell-mode -1))))

;; Add spell-checking in comments for all programming language modes
(if (fboundp 'prog-mode)
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (dolist (hook '(lisp-mode-hook
                  emacs-lisp-mode-hook
                  scheme-mode-hook
                  clojure-mode-hook
                  ruby-mode-hook
                  yaml-mode
                  python-mode-hook
                  shell-mode-hook
                  php-mode-hook
                  css-mode-hook
                  haskell-mode-hook
                  caml-mode-hook
                  nxml-mode-hook
                  crontab-mode-hook
                  perl-mode-hook
                  tcl-mode-hook
                  javascript-mode-hook))
    (add-hook hook 'flyspell-prog-mode)))

(eval-after-load 'flyspell
    '(add-to-list 'flyspell-prog-text-faces 'nxml-text-face))

;; i3

(require 'i3)
(require 'i3-integration)

;; helm configuration

(require 'helm-config)

;;; Google Suggestions
;;
;;
;; Internal
(defvar helm-ggs-max-length-real-flag 0)
(defvar helm-ggs-max-length-num-flag 0)

(defun helm-google-suggest-fetch (input)
  "Fetch suggestions for INPUT from XML buffer.
Return an alist with elements like (data . number_results)."
  (setq helm-ggs-max-length-real-flag 0
        helm-ggs-max-length-num-flag 0)
  (let ((request (concat helm-google-suggest-url
                         (url-hexify-string input)))
        (fetch #'(lambda ()
                   (cl-loop
                    with result-alist = (xml-get-children
                                         (car (xml-parse-region
                                               (point-min) (point-max)))
                                         'CompleteSuggestion)
                    for i in result-alist
                    for data = (cdr (cl-caadr (assoc 'suggestion i)))
                    for nqueries = (cdr (cl-caadr (assoc 'num_queries i)))
                    for lqueries = (length (helm-ggs-set-number-result
                                            nqueries))
                    for ldata = (length data)
                    do
                    (progn
                      (when (> ldata helm-ggs-max-length-real-flag)
                        (setq helm-ggs-max-length-real-flag ldata))
                      (when (> lqueries helm-ggs-max-length-num-flag)
                        (setq helm-ggs-max-length-num-flag lqueries)))
                    collect (cons data nqueries) into cont
                    finally return cont))))
    (if helm-google-suggest-use-curl-p
        (with-temp-buffer
          (call-process "curl" nil t nil request)
          (funcall fetch))
      (with-current-buffer
          (url-retrieve-synchronously request)
        (funcall fetch)))))

(defun helm-google-suggest-set-candidates (&optional request-prefix)
  "Set candidates with result and number of google results found."
  (let ((suggestions
         (cl-loop with suggested-results = (helm-google-suggest-fetch
                                            (or (and request-prefix
                                                     (concat request-prefix
                                                             " " helm-pattern))
                                                helm-pattern))
                  for (real . numresult) in suggested-results
                  ;; Prepare number of results with ","
                  for fnumresult = (helm-ggs-set-number-result numresult)
                  ;; Calculate number of spaces to add before fnumresult
                  ;; if it is smaller than longest result
                  ;; `helm-ggs-max-length-num-flag'.
                  ;; e.g 1,234,567
                  ;;       345,678
                  ;; To be sure it is aligned properly.
                  for nspaces = (if (< (length fnumresult)
                                       helm-ggs-max-length-num-flag)
                                    (- helm-ggs-max-length-num-flag
                                       (length fnumresult))
                                  0)
                  ;; Add now the spaces before fnumresult.
                  for align-fnumresult = (concat (make-string nspaces ? )
                                                 fnumresult)
                  for interval = (- helm-ggs-max-length-real-flag
                                    (length real))
                  for spaces   = (make-string (+ 2 interval) ? )
                  for display = (format "%s%s(%s results)"
                                        real spaces align-fnumresult)
                  collect (cons display real))))
    (if (cl-loop for (_disp . dat) in suggestions
                 thereis (equal dat helm-pattern))
        suggestions
      ;; if there is no suggestion exactly matching the input then
      ;; prepend a Search on Google item to the list
      (append
       suggestions
       (list (cons (concat "Search for " "'" helm-input "'" " on Google")
                   helm-input))))))

(defun helm-ggs-set-number-result (num)
  (if num
      (progn
        (and (numberp num) (setq num (number-to-string num)))
        (cl-loop for i in (reverse (split-string num "" t))
                 for count from 1
                 append (list i) into C
                 when (= count 3)
                 append (list ",") into C
                 and do (setq count 0)
                 finally return
                 (replace-regexp-in-string
                  "^," "" (mapconcat 'identity (reverse C) ""))))
    "?"))

(defun helm-google-suggest-action (candidate)
  "Default action to jump to a google suggested candidate."
  (let ((arg (concat helm-google-suggest-search-url
                     (url-hexify-string candidate))))
    (helm-aif helm-google-suggest-default-browser-function
              (funcall it arg)
              (helm-browse-url arg))))

(defvar helm-google-suggest-default-function
  'helm-google-suggest-set-candidates
  "Default function to use in helm google suggest.")

(defvar helm-source-google-suggest
  '((name . "Google Suggest")
    (candidates . (lambda ()
                    (funcall helm-google-suggest-default-function)))
    (action . (("Google Search" . helm-google-suggest-action)))
    (volatile)
    (requires-pattern . 3)))

;; (defun helm-google-suggest-emacs-lisp ()
;;   "Try to emacs lisp complete with google suggestions."
;;   (helm-google-suggest-set-candidates "emacs lisp"))

;; (setq helm-howdoi
;;       '((name . "howdoi google")
;;         (candidates . (lambda ()
;;                         (funcall helm-google-suggest-default-function)))
;;         (action . (("howdoi" . howdoi-query)))
;;         (volatile)
;;         (requires-pattern . 3)
;;         (delayed)))

;; ;; and then you can call howdoi via helm like this:
;; ;; (helm :sources 'helm-howdoi)

;; (defun helm-howdoi-with-google-suggest ()
;;   (interactive)
;;   (helm :sources 'helm-howdoi))

;; (global-set-key (kbd "C-c o g") 'helm-howdoi-with-google-suggest)

;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
;; (define-key helm-map (kbd "C-M-i") 'helm-select-action)

(setq helm-quick-update t
      helm-idle-delay 0.01
      helm-input-idle-delay 0.01)

;; helm-dash

(require 'helm-dash)

;; helm-github-stars

(require 'helm-github-stars)
(setq helm-github-stars-username "atykhonov")

;; howdoi configuration

(load-file "/str/development/projects/open-source/elisp/emacs-howdoi/howdoi.el")

(global-set-key (kbd "C-c o q") 'howdoi-query)

(setq helm-howdoi
      '((name . "howdoi google")
        (candidates . (lambda ()
                        (funcall helm-google-suggest-default-function)))
        (action . (("howdoi" . howdoi-query)))
        (volatile)
        (requires-pattern . 3)
        (delayed)))

;; and then you can call howdoi via helm like this:
;; (helm :sources 'helm-howdoi)

(defun helm-howdoi-with-google-suggest ()
  (interactive)
  (helm :sources 'helm-howdoi))

(global-set-key (kbd "C-c o g") 'helm-howdoi-with-google-suggest)

;; ibuffer configuration

(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-saved-filter-groups
      '(("default"
         ("version control" (or (mode . svn-status-mode)
                                (mode . svn-log-edit-mode)
                                (name . "^\\*svn-")
                                (name . "^\\*vc\\*$")
                                (name . "^\\*Annotate")
                                (name . "^\\*git-")
                                (name . "^\\*vc-")))
         ("emacs" (or (name . "^\\*scratch\\*$")
                      (name . "^\\*Messages\\*$")
                      (name . "^TAGS\\(<[0-9]+>\\)?$")
                      (name . "^\\*Help\\*$")
                      (name . "^\\*info\\*$")
                      (name . "^\\*Occur\\*$")
                      (name . "^\\*grep\\*$")
                      (name . "^\\*Compile-Log\\*$")
                      (name . "^\\*Backtrace\\*$")
                      (name . "^\\*Process List\\*$")
                      (name . "^\\*gud\\*$")
                      (name . "^\\*Man")
                      (name . "^\\*WoMan")
                      (name . "^\\*Kill Ring\\*$")
                      (name . "^\\*Completions\\*$")
                      (name . "^\\*tramp")
                      (name . "^\\*shell\\*$")
                      (name . "^\\*compilation\\*$")))
         ("emacs source" (or (mode . emacs-lisp-mode)
                             (filename . "/Applications/Emacs.app")
                             (filename . "/bin/emacs")))
         ("agenda" (or (name . "^\\*Calendar\\*$")
                       (name . "^diary$")
                       (name . "^\\*Agenda")
                       (name . "^\\*org-")
                       (name . "^\\*Org")
                       (mode . org-mode)
                       (mode . muse-mode)))
         ("latex" (or (mode . latex-mode)
                      (mode . LaTeX-mode)
                      (mode . bibtex-mode)
                      (mode . reftex-mode)))
         ("dired" (or (mode . dired-mode))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

;; Order the groups so the order is : [Default], [agenda], [emacs]
(defadvice ibuffer-generate-filter-groups (after reverse-ibuffer-groups ()
                                                 activate)
  (setq ad-return-value (nreverse ad-return-value)))

;; iregister configuration

(add-to-list 'load-path "/str/development/projects/open-source/elisp/iregisters.el/")
(require 'iregister)

(global-set-key (kbd "H-v") 'iregister-jump-to-next-marker)
(global-set-key (kbd "H-z") 'iregister-jump-to-previous-marker)

(global-set-key (kbd "M-l") 'iregister-latest-text)
(global-set-key (kbd "M-c") 'iregister-text)
(global-set-key (kbd "M-C") 'iregister-next-text)

(global-set-key (kbd "M-w") 'iregister-point-or-text-to-register-kill-ring-save)
(global-set-key (kbd "C-w") 'iregister-copy-to-register-kill)
(global-set-key (kbd "M-y") 'iregister-latest-text)

;; jabber configuration

(setq jabber-account-list '(
                            ("atykhonov@jabber.n-ix.com.ua"
                             (:network-server . "jabber.n-ix.com.ua")
                             (:port . 5222))))

(setq jabber-history-enabled t
      jabber-use-global-history nil
      jabber-backlog-number 40
      jabber-backlog-days 30
      jabber-roster-line-format " %c %-25n %u %-8s  %S")

;; kill-and-join-forward

(defun kill-and-join-forward (&optional arg)
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (progn (forward-char 1)
             (just-one-space 0)
             (backward-char 1)
             (kill-line arg))
    (kill-line arg)))

(global-set-key "\C-k" 'kill-and-join-forward)

;; kill-region

(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region, kill the
current line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; kill ring save

;; Change cutting behavior:
;; "Many times you'll do a kill-line command with the only intention of
;; getting the contents of the line into the killring. Here's an idea stolen
;; from Slickedit, if you press copy or cut when no region is active, you'll
;; copy or cut the current line."
;; <http://www.zafar.se/bkz/Articles/EmacsTips>
(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy the
current line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; lunar-mode

(add-to-list 'load-path "/str/development/projects/open-source/elisp/lunar-mode-line/")
(require 'lunar-mode-line)
(display-lunar-phase-mode)

;; lorem-ipsum

(defun lorem-ipsum ()
  (interactive)
  (insert "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."))

;; magit

(add-to-list 'load-path "/str/development/projects/open-source/elisp/git-modes/")
(add-to-list 'load-path "/str/development/projects/open-source/elisp/magit/")
(eval-after-load 'info
  '(progn (info-initialize)
          (add-to-list 'Info-directory-list "/str/development/projects/open-source/elisp/magit/")))
(require 'magit)

(add-hook 'magit-log-edit-mode-hook 'flyspell-mode)

(global-set-key (kbd "H-i") 'magit-status)

(setenv "SSH_AUTH_SOCK" "")
(setenv "SSH_AGENT_PID" "")

;; makefile-mode configuration

(defun makefile-indentation ()
  (interactive)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq indent-line-function 'insert-tab))

(add-hook 'makefile-mode-hook 'makefile-indentation)

;; markdown-mode configuration

(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

;; miscellaneous

(global-set-key (kbd "H-/") 'smex)
(global-set-key (kbd "H-g") 'keyboard-quit)

(global-set-key (kbd "~") #'endless/~-or-emacs.d)

(defun endless/~-or-emacs.d ()
  (interactive)
  (if (window-minibuffer-p)
      (if (looking-back "~/")
          (insert ".emacs.d/")
        (insert "~/"))
    (insert "~")))

;; muse

(require 'muse-mode)     ; load authoring mode
(require 'muse-html)     ; load publishing styles I use
(require 'muse-latex)
(require 'muse-texinfo)
(require 'muse-docbook)
(require 'muse-project)  ; publish files in projects

(add-to-list 'load-path "~/.emacs.d/muse-html-slidy/")
(require 'muse-html-slidy)

(setq muse-project-alist
      '(("Main" ("~/MainWiki" :default "index"))))

;; navi

(require 'navi-mode)

;; navigation within a buffer

(defvar demi-next-buffer "")

(defvar demi-prev-buffer "")

(defun demi/next-buffer ()
  (interactive)
  (setq demi-prev-buffer (buffer-name (current-buffer)))
  (next-buffer)
  (save-excursion
    (next-buffer)
    (setq demi-next-buffer (buffer-name (current-buffer)))))

(defun demi/prev-buffer ()
  (interactive)
  (setq demi-next-buffer (buffer-name (current-buffer)))
  (previous-buffer)
  (save-excursion
    (previous-buffer)
    (setq demi-prev-buffer (buffer-name (current-buffer)))))

(global-set-key (kbd "H-b") 'previous-buffer)
(global-set-key (kbd "H-l") 'next-buffer)

(global-set-key (kbd "H-O") 'switch-to-other-buffer)

(global-set-key (kbd "H--") 'newline)

(defun switch-to-other-buffer ()
  (interactive)
  (other-buffer 1))

(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; navigation within files

(recentf-mode 1) ; keep a list of recently opened files
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; goto last change configuration

(global-set-key [(control ?.)] 'goto-last-change)
(global-set-key [(control ?,)] 'goto-last-change-reverse)

;; navigation within a mark

(defun buffer-order-next-mark (arg)
  (interactive "p")
  (when (mark)
    (let* ((p (point))
           (m (mark))
           (n p)
           (count (if (null arg) 1 arg))
           (abscount (abs count))
           (rel
            (funcall
             (if (< 0 count) 'identity 'reverse)
             (sort (cons (cons 0 p)
                         (cons (cons (- m p) m)
                               (if mark-ring
                                   (mapcar (lambda (mrm)
                                             (cons (- mrm p) mrm))
                                           mark-ring)
                                 nil)))
                   (lambda (c d) (< (car c) (car d))))))
           (cur rel))
      (while (and (numberp (caar cur)) (/= (caar cur) 0))
        (setq cur (cdr cur)))
      (while (and (numberp (caadr cur)) (= (caadr cur) 0))
        (setq cur (cdr cur)))
      (while (< 0 abscount)
        (setq cur (cdr cur))
        (when (null cur) (setq cur rel))
        (setq abscount (- abscount 1)))
      (when (number-or-marker-p (cdar cur))
        (goto-char (cdar cur))))))

(defun buffer-order-prev-mark (arg)
  (interactive "p")
  (buffer-order-next-mark
   (if (null arg) -1 (- arg))))

(global-set-key [C-s-right] 'buffer-order-next-mark)
(global-set-key [C-s-left] 'buffer-order-prev-mark)

;; point navigation

;; (setq scroll-preserve-screen-position t)

;; (defun buffer-order-next-mark (arg)
;;   (interactive "p")
;;   (when (mark)
;;     (let* ((p (point))
;;            (m (mark))
;;            (n p)
;;            (count (if (null arg) 1 arg))
;;            (abscount (abs count))
;;            (rel
;;             (funcall
;;              (if (< 0 count) 'identity 'reverse)
;;              (sort (cons (cons 0 p)
;;                          (cons (cons (- m p) m)
;;                                (if mark-ring
;;                                    (mapcar (lambda (mrm)
;;                                              (cons (- mrm p) mrm))
;;                                            mark-ring)
;;                                  nil)))
;;                    (lambda (c d) (< (car c) (car d))))))
;;            (cur rel))
;;       (while (and (numberp (caar cur)) (/= (caar cur) 0))
;;         (setq cur (cdr cur)))
;;       (while (and (numberp (caadr cur)) (= (caadr cur) 0))
;;         (setq cur (cdr cur)))
;;       (while (< 0 abscount)
;;         (setq cur (cdr cur))
;;         (when (null cur) (setq cur rel))
;;         (setq abscount (- abscount 1)))
;;       (when (number-or-marker-p (cdar cur))
;;         (goto-char (cdar cur))))))

;; (defun buffer-order-prev-mark (arg)
;;   (interactive "p")
;;   (buffer-order-next-mark
;;    (if (null arg) -1 (- arg))))

;; (defun demi/end-of-line-return ()
;;   (interactive)
;;   (move-end-of-line 1)
;;   (newline))

;; (defun demi/end-of-previous-line-return ()
;;   (interactive)
;;   (move-end-of-line 0)
;;   (newline))

;; (defun ctrl-e-in-vi (n)
;;   (interactive "p")
;;   (scroll-up n))

;; (defun ctrl-y-in-vi (n)
;;   (interactive "p")
;;   (scroll-down n))

;; (global-set-key (kbd "C-<return>") 'demi/end-of-line-return)
;; (global-set-key (kbd "S-C-<return>") 'demi/end-of-previous-line-return)

;; (global-set-key [C-s-right] 'buffer-order-next-mark)
;; (global-set-key [C-s-left] 'buffer-order-prev-mark)

;; seems is unneeded, will see
(defun at/end-of-buffer ()
  (interactive)
  (end-of-buffer)
  (forward-line -1))

(defun demi/set-mark-command ()
  (interactive)
  (set-mark-command 4))

(global-set-key (kbd "H-d") 'backward-char)
(global-set-key (kbd "H-h") 'next-line)
(global-set-key (kbd "H-t") 'previous-line)
(global-set-key (kbd "H-n") 'forward-char)

(global-set-key (kbd "H-$") 'demi/set-mark-command)

(global-set-key (kbd "C-H-S-t") 'beginning-of-buffer)
(global-set-key (kbd "C-H-S-h") 'end-of-buffer)

(global-set-key (kbd "H-,") 'beginning-of-buffer)
(global-set-key (kbd "H-.") 'end-of-buffer)

(global-set-key (kbd "<XF86Launch6>") 'beginning-of-buffer)
(global-set-key (kbd "<XF86Launch7>") 'end-of-buffer)

(global-set-key (kbd "C-H-t") 'backward-paragraph)
(global-set-key (kbd "C-H-h") 'forward-paragraph)

;; (global-set-key (kbd "H-T") 'ctrl-y-in-vi)
;; (global-set-key (kbd "H-H") 'ctrl-e-in-vi)

(global-set-key (kbd "H-M") 'backward-sexp)
(global-set-key (kbd "H-W") 'forward-sexp)

(global-set-key (kbd "H-m") 'backward-word)
(global-set-key (kbd "H-w") 'forward-word)

(global-set-key (kbd "C-H-d") 'move-beginning-of-line)
(global-set-key (kbd "C-H-n") 'move-end-of-line)

(global-set-key (kbd "H-a") 'move-beginning-of-line)
(global-set-key (kbd "H-e") 'move-end-of-line)

;; (global-set-key (kbd "H-/") 'switch-to-previous-buffer)
;; (global-set-key (kbd "H-b") 'previous-buffer)
;; (global-set-key (kbd "H-l") 'next-buffer)
;; (global-set-key (kbd "H-k") 'kill-line)
;; (global-set-key (kbd "H-s") 'save-buffer)

;; source: http://www.emacswiki.org/emacs/RecenterLikeVi
(defun line-to-top-of-window ()
  "Shift current line to the top of the window-  i.e. zt in Vim"
  (interactive)
  (set-window-start (selected-window) (point)))

(defun line-to-bottom-of-window ()
  "Shift current line to the botom of the window- i.e. zb in Vim"
  (interactive)
  (line-to-top-of-window)
  (scroll-down (- (window-height) 3)))

(defun search-sexp-at-point ()
  "Search the s-expression at the point."
  (interactive)
  (let ((string (buffer-substring-no-properties
                 (point)
                 (save-excursion (forward-sexp) (point)))))
    (forward-sexp)
    (search-forward string)))

;; navigation by means of scrolling

(setq scroll-preserve-screen-position t)

(defun ctrl-e-in-vi (n)
  (interactive "p")
  (scroll-up n))

(defun ctrl-y-in-vi (n)
  (interactive "p")
  (scroll-down n))

(global-set-key (kbd "H-T") 'ctrl-y-in-vi)
(global-set-key (kbd "H-H") 'ctrl-e-in-vi)

(global-set-key (kbd "<S-prior>") 'ctrl-y-in-vi)
(global-set-key (kbd "<S-next>") 'ctrl-e-in-vi)

;; navigation within the windows

(global-set-key (kbd "M-]") 'delete-other-windows) ; expand current pane
(global-set-key (kbd "M-+") 'split-window-horizontally) ; split pane top/bottom
(global-set-key (kbd "M-)") 'delete-window) ; close current pane
(global-set-key (kbd "M-*") 'other-window) ; cursor to other pane

(global-set-key (kbd "H-o") 'switch-to-other-window)
(global-set-key (kbd "<XF86Launch5>") 'switch-to-other-window)

(defun switch-to-other-window ()
  (interactive)
  (other-window 1))

;; org-mode configuration

(require 'demi-org)

;; org-babel configuration

(setq org-src-fontify-natively t)

;; source: http://orgmode.org/manual/Languages.html#Languages
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((emacs-lisp . t)
;;    (python . t)
;;    (shell . t)
;;    (org . t)
;;    (ditaa . t)))

;; org-prettier-code-blocks

(defun prettier-org-code-blocks ()
  (interactive)
  (font-lock-add-keywords nil
                          '(("\\(\+begin_src\\)"
                             (0 (progn (compose-region (match-beginning 1) (match-end 1) ?¦)
                                       nil)))
                            ("\\(\+end_src\\)"
                             (0 (progn (compose-region (match-beginning 1) (match-end 1) ?¦)
                                       nil))))))

(add-hook 'org-mode-hook 'prettier-org-code-blocks)

;; paren-mode

(show-paren-mode t)
(setq show-paren-ring-bell-on-mismatch t)

;; popup-switcher

(require 'popup-switcher)

(global-set-key [f2] 'psw-switch-buffer)

;; popwin

(require 'popwin)

;; prodigy

(require 'demi-prodigy)

;; python

(require 'demi-python)
(require 'demi-python-flake8)
(require 'demi-emacs-for-python)

;; rainbow-delimiters

(require 'rainbow-delimiters)
(add-hook 'python-mode-hook 'rainbow-delimiters-mode)

;; readability

(require 'demi-readability)

;; rename-file-and-buffer

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; saveplace - save cursor position in files when buffer changes

(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/saveplace")

;; shell-mode directory tracking in the modeline

(defun add-mode-line-dirtrack ()
  (add-to-list 'mode-line-buffer-identification
               '(:propertize (" " default-directory " ") face dired-directory)
               ))

(add-hook 'shell-mode-hook 'add-mode-line-dirtrack)

;; sauron

(require 'demi-sauron)

;; smartparens

(smartparens-global-mode)

;; smart-mode-line

(require 'smart-mode-line)

(setq sml/vc-mode-show-backend t)
(sml/setup)
(sml/apply-theme 'dark)

;; smart-forward

(require 'smart-forward)

;; smart-return

(add-to-list 'load-path "/str/development/projects/open-source/elisp/emacs-smart-return/")

(require 'smart-return)
(global-set-key (kbd "H-<return>") 'smart-return)

;; smex

(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; Theme

(add-to-list 'custom-theme-load-path "~/emacs/packages/themes/")
(load-theme 'hc-zenburn t)

;; Toggles between russian and ukrainian input methods

(defun toggle-alternative-input-method ()
  "Toggles between russian and ukrainian input methods"
  (interactive)
  (cond
   ((or (null current-input-method)
        (string= current-input-method "ukrainian-computer"))
    (activate-input-method 'russian-computer))
   ((string= current-input-method "russian-computer")
    (activate-input-method 'ukrainian-computer))))

(global-set-key "\C-x\\" 'toggle-alternative-input-method)

;; Find file as root via the tramp

(require 'demi-tramp-find-file-root)

;; undo-tree

(require 'undo-tree)
(global-undo-tree-mode)
(defalias 'redo 'undo-tree-redo)

;; uniquify

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; visible-mark

(require 'visible-mark)

;; w3m

(require 'demi-w3m)

;; Swap two windows

;; swap 2 windows
(defun my-swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((not (= (count-windows) 2))
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1)))))

(global-set-key (kbd "C-c ~") 'my-swap-windows)

;; Toggle window split

(defun my-toggle-window-split ()
  "Vertical split shows more of each line, horizontal split shows
more lines. This code toggles between them. It only works for
frames with exactly two windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "C-c |") 'my-toggle-window-split)

;; workgroups configuration

(add-to-list 'load-path "/str/development/projects/open-source/elisp/workgroups.el/")
(require 'workgroups)
(setq wg-prefix-key (kbd "C-c z"))

;; xml tools

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      ;; (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

(defun cheeso-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    ;; split <foo><bar> or </foo><bar>, but not <foo></foo>
    (goto-char begin)
    (while (search-forward-regexp ">[ \t]*<[^/]" end t)
      (backward-char 2) (insert "\n") (incf end))
    ;; split <foo/></foo> and </foo></foo>
    (goto-char begin)
    (while (search-forward-regexp "<.*?/.*?>[ \t]*<" end t)
      (backward-char) (insert "\n") (incf end))
    ;; put xml namespace decls on newline
    (goto-char begin)
    (while (search-forward-regexp "\\(<\\([a-zA-Z][-:A-Za-z0-9]*\\)\\|['\"]\\) \\(xmlns[=:]\\)" end t)
      (goto-char (match-end 0))
      (backward-char 6) (insert "\n") (incf end))
    (indent-region begin end nil)
    (normal-mode))
  (message "All indented!"))

;; hippie expand

(global-set-key (kbd "M-/") 'hippie-expand)

(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

;; diff-hl

(require 'diff-hl)
(add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode)



(load "server")
(unless (server-running-p) (server-start))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; disable brackets autocomplete
(setq skeleton-pair nil)

(defalias 'list-buffers 'ibuffer)

(load-file "~/.emacs.d/annot.el")

(setq c-default-style "linux" c-basic-offset 4)
(add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))

(add-to-list 'load-path "/str/development/projects/open-source/elisp/ljupdate/")
(require 'ljupdate)

(load-file "~/.emacs.d/ezbl.el")
(require 'ezbl)

(autoload 'turn-on-eldoc-mode "eldoc" nil t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

; Don't show whitespace in diff, but show context
(setq vc-diff-switches '("-b" "-B" "-u"))

;; (load-file "/str/learning/elisp/ssh.el")
;; (setq tramp-default-method "ssh")

(setq c-basic-indent 2)
(setq tab-width 4)
(setq-default indent-tabs-mode nil)

(load-file "/str/development/projects/open-source/elisp/emacs-request/request.el")

(defun goto-project-root ()
  (interactive)
  (setq filename "/str/development/")
  (ido-set-current-directory filename)
  (setq ido-text "")
  (ido-set-current-directory (file-name-directory filename))
  (setq ido-exit 'refresh ido-text-init ido-text ido-rotate-temp t)
  (exit-minibuffer))

(define-key minibuffer-local-map (kbd "M-a") 'goto-project-root)

(defun online-syntax-highlight (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil nil)))
  (let* ((code (buffer-substring-no-properties beg end)))
    (request
     "http://markup.su/api/highlighter"
     :type "POST"
     :data `(("source" . ,code)
             ("language" . ,(read-from-minibuffer "Language: "))
             ("theme" . "iPlastic"))
     :parser 'buffer-string
     :success
     (function* (lambda (&key data &allow-other-keys)
                  (when data
                    (with-current-buffer (current-buffer)
                      (insert data)))))
     :error
     (function* (lambda (&key error-thrown &allow-other-keys&rest _)
                  (message "Got error: %S" error-thrown)))
     :complete (lambda (&rest _) (message "Finished!")))))

(require 'moz)

(setq js-indent-level 2)

(defun javascript-moz-setup ()
  (moz-minor-mode 1))

;; Do not use gpg agent when runing in terminal
(defadvice epg--start (around advice-epg-disable-agent activate)
  (let ((agent (getenv "GPG_AGENT_INFO")))
    (when (not (display-graphic-p))
      (setenv "GPG_AGENT_INFO" nil))
    ad-do-it
    (when (not (display-graphic-p))
      (setenv "GPG_AGENT_INFO" agent))))

(load-file "~/.emacs.d/def.el")

(load-file "/str/development/projects/open-source/elisp/god-mode/god-mode.el")

(load-file "/str/development/projects/open-source/elisp/ukrainian-programmer-dvorak/ukrainian-programmer-dvorak.el")

(setq default-input-method "ukrainian-programmer-dvorak")

(add-hook 'lisp-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

; lisp-interaction-mode-hook

(add-to-list 'load-path "/usr/share/emacs/site-lisp/tex-utils")
(require 'xdvi-search)

(setq org-cycle-emulate-tab 'white)

(load-file "/str/development/projects/open-source/elisp/popup-el/popup.el")

(require 'saveplace)
(setq-default save-place t)

(setq x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      save-place-file (concat user-emacs-directory "places")
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))

(defun @tail()
  (interactive)
  (let ((filepath
         (concat ido-current-directory
                 (ido-name (car ido-matches)))))
    (make-comint-in-buffer "Log" "*Log*" "tail" nil "-f" filepath))
  (pop-to-buffer "*Log*"))

(define-key minibuffer-local-map (kbd "M-t") '@cisco/tail)

(load-file "~/.emacs.d/presentation.el")

(add-to-list 'load-path "~/mh-e-8.5/")

(require 'gnus-dired)

;; make the `gnus-dired-mail-buffers' function also work on
;; message-mode derived modes, such as mu4e-compose-mode
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
        (set-buffer buffer)
        (when (and (derived-mode-p 'message-mode)
                   (null message-sent-message-via))
          (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

(defun nose-run-test ()
  (interactive)
  (save-buffer)
  (nosetests-module))

(defun @import (import)
  (interactive "sImport: ")
  (let ((pos (point)))
    (goto-char (point-min))
    (insert (format "%s\n" import))
    (goto-char pos)))

;; source: http://stackoverflow.com/questions/7937395/select-the-previously-selected-window-in-emacs/
(defun switch-to-previous-buffer-possibly-creating-new-window ()
  (interactive)
  (pop-to-buffer (other-buffer (current-buffer) t)))

;; source: http://stackoverflow.com/questions/7937395/select-the-previously-selected-window-in-emacs/
(defun switch-to-the-window-that-displays-the-most-recently-selected-buffer ()
  (interactive)
  (let* ((buflist (buffer-list (selected-frame)))      ; get buffer list in this frames ordered
         (buflist (delq (current-buffer) buflist))     ; if there are multiple windows showing same buffer.
         (winlist (mapcar 'get-buffer-window buflist)) ; buf->win
         (winlist (delq nil winlist))                  ; remove non displayed windows
         (winlist (delq (selected-window) winlist)))   ; remove current-window
    (if winlist
        (select-window (car winlist))
      (message "Couldn't find a suitable window to switch to"))))

(global-set-key (kbd "C-c m") 'message-mark-inserted-region)

(define-key minibuffer-local-completion-map (kbd "SPC") 'minibuffer-complete-and-exit)

(winner-mode 1)

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

(defun my-argument-fn (switch)
  (message "i was passed -my_argument"))

(add-to-list 'command-switch-alist '("-my_argument" . my-argument-fn))

(global-set-key (kbd "H-;") 'eshell)

(defun my-argument-fn (switch)
  (print "i was passed -myarg")
  (kill-emacs))

(add-to-list 'command-switch-alist '("-myarg" . my-argument-fn))
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)

(global-auto-revert-mode)
(put 'downcase-region 'disabled nil)

(setq max-mini-window-height 0.5)
(put 'upcase-region 'disabled nil)

(global-set-key (kbd "H-SPC") 'hippie-expand)

(add-to-list 'load-path "/str/development/projects/open-source/.ghq/code.google.com/p/emacs-soap-client/")
(require 'soap-client)
(setq jiralib-url "https://qbeats.atlassian.net/")

(load-file "~/.emacs.d/syntax-subword.el")

(add-to-list
 'directory-abbrev-alist
 '("^/gt" . "/str/development/projects/open-source/elisp/google-translate"))

(define-abbrev-table 'my-tramp-abbrev-table
  '(("gt" "/str/development/projects/open-source/elisp/google-translate")))

(add-hook
 'minibuffer-setup-hook
 (lambda ()
   (abbrev-mode 1)
   (setq local-abbrev-table my-tramp-abbrev-table)))

(defadvice minibuffer-complete
  (before my-minibuffer-complete activate)
  (expand-abbrev))

;; If you use partial-completion-mode
(defadvice PC-do-completion
  (before my-PC-do-completion activate)
  (expand-abbrev))

(global-aggressive-indent-mode)

(defun narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, org-src-block, org-subtree, or defun,
whichever applies first.
Narrowing to org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer is already
narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing command.
         ;; Remove this first conditional if you don't want it.
         (cond ((ignore-errors (org-edit-src-code))
                (delete-other-windows))
               ((org-at-block-p)
                (org-narrow-to-block))
               (t (org-narrow-to-subtree))))
        (t (narrow-to-defun))))

;; (define-key endless/toggle-map "n" #'narrow-or-widen-dwim)
;; This line actually replaces Emacs' entire narrowing keymap, that's
;; how much I like this command. Only copy it if that's what you want.
(define-key ctl-x-map "n" #'narrow-or-widen-dwim)