;;-------
;;init
;;-------

;; 初期のモードをorg-modeに
(setq initial-major-mode 'org-mode)

;;-------
;;dispaly
;;-------
;; themeを設定
(load-theme 'tango-dark t)

;; 対応する括弧を光らせる
(show-paren-mode t)

;; 選択部分のハイライト
(transient-mark-mode t)

;; 行間
(setq-default line-spacing 0)

;; 同じバッファ名の時 <2> とかではなく、ディレクトリ名で区別
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; フォントロックモード
(global-font-lock-mode t)

;; tool-bar使わない
(tool-bar-mode 0)

;; 画面端まで来たら折り返す
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; init-loaderが失敗した時のみエラーメッセージを表示
(custom-set-variables
 '(init-loader-show-log-after-init 'error-only))

;; キーストロークをエコーエリアに早く表示する
(setq echo-keystrokes 0.1)

;; 行番号・桁番号を表示
(line-number-mode 1)
(column-number-mode 1)

;; scroll-barをOFFに
(scroll-bar-mode -1)

;; 編集行を目立たせる（現在行をハイライト表示する）
(global-hl-line-mode)

;; フォント設定
(let ((ws window-system))
  (cond ((eq ws 'w32)
         (set-face-attribute 'default nil
                             :family "Consolas"
                             :height 100)
         (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Consolas")))
        ((eq ws 'mac)
         (set-face-attribute 'default nil
                             :family "Source Han Code JP"
                             :height 130)
         (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Source Han Code JP")))))

;; whitespace-modeの設定
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可化
			 trailing       ; 行末
			 tabs           ; タブ
			 spaces         ; スペース
			 space-mark     ; 表示のマッピング
			 tab-mark ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
	;; WARNING: the mapping below has a problem.
	;; When a TAB occupies exactly one column, it will display the
	;; character ?\xBB at that column followed by a TAB which goes to
	;; The next TAB column.
	;; If this is a problem for you, please, comment the line below.
	(tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

;; スペースは全角のみを可視化
(setq whitespace-space-regexp "\\(\u3000+\\)")

(global-whitespace-mode 1)

;;-------
;;keybindings
;;-------
(keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "C-h") nil)
(global-set-key (kbd "C-m") 'newline-and-indent) ; リターンで改行とインデント

;; 複数行移動
(global-set-key (kbd "M-n") (kbd "C-u 5 C-n"))
(global-set-key (kbd "M-p") (kbd "C-u 5 C-p"))

(global-set-key (kbd "C-x C-k") 'kill-buffer)

;; window-split
(global-set-key (kbd "C-0") 'delete-window)
(global-set-key (kbd "C-1") 'delete-other-windows)
(global-set-key (kbd "C-2") 'split-window-below)
(global-set-key (kbd "C-3") 'split-window-right)

;; reload buffer
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)

;; clonse-buffer
(defun close-and-kill-this-pane ()
      "If there are multiple windows, then close this pane and kill the buffer in it also."
      (interactive)
      (kill-this-buffer)
      (if (not (one-window-p))
          (delete-window)))

(global-set-key (kbd "C-x k") 'close-and-kill-this-pane)

;; recentf
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(global-set-key (kbd "C-x C-r") 'recentf-ido-find-file)

;; window-split
(defun split-window-vertically-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-vertically)
    (progn
      (split-window-vertically
       (- (window-height) (/ (window-height) num_wins)))
      (split-window-vertically-n (- num_wins 1)))))

(defun split-window-horizontally-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-horizontally)
    (progn
      (split-window-horizontally
       (- (window-width) (/ (window-width) num_wins)))
      (split-window-horizontally-n (- num_wins 1)))))

(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (if (>= (window-body-width) 270)
        (split-window-horizontally-n 3)
      (split-window-horizontally)))
  (other-window 1))

(global-set-key (kbd "C-t") 'other-window-or-split)

