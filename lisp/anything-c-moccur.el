;;;  -*- coding: utf-8; mode: emacs-lisp; -*-
;;; anything-c-moccur.el

;; Author: Kenji.Imakado <ken.imakaado -at- gmail.com>
;; Version: 0.1
;; Keywords: occur
;; Prefix: anything-c-moccur-

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.


;;; Commentary:
;; Tested on Emacs 22

;; sample config
;; (require 'anything-c-moccur)
;; (global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur)
;; (global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur)
;; (add-hook 'dired-mode-hook
;;           '(lambda ()
;;              (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))

;;;code:

(require 'anything)
(require 'cl)
(require 'color-moccur)
(require 'rx)

(defgroup anything-c-moccur nil
  ""
  :group 'anything-c-moccur)


(defcustom anything-c-moccur-anything-idle-delay nil
  "anything-c-moccurが提供するコマンドでanythingが起動された際の`anything-idle-delay'の値
nilなら`anything-idle-delay'の値を使う"
  :type '(choice (integer)
                 (boolean))
  :group 'anything-c-moccur)

(defcustom anything-c-moccur-push-mark-flag nil
  "non-nilならコマンド起動時に現在のポイントにマークをセットする"
  :type 'boolean
  :group 'anything-c-moccur)

(defcustom anything-c-moccur-widen-when-goto-line-flag nil
  "non-nilなら必要に応じてナローイングを解除する"
  :type 'boolean
  :group 'anything-c-moccur)

(defcustom anything-c-moccur-show-all-when-goto-line-flag nil ;outline
  "non-nilなら必要に応じてoutlineの折畳み表示を解除する"
  :type 'boolean
  :group 'anything-c-moccur
  )

(defcustom anything-c-moccur-higligt-info-line-flag nil
  "non-nilならdmoccur, dired-do-moccurの候補を表示する際にバッファ名などの情報をハイライト表示する"
  :type 'boolean
  :group 'anything-c-moccur)

(defcustom anything-c-moccur-enable-auto-look-flag nil
  "non-nilなら選択中の候補を他のバッファにリアルタイムに表示する"
  :type 'boolean
  :group 'anything-c-moccur)

(defcustom anything-c-moccur-enable-initial-pattern nil
  "non-nilなら`anything-c-moccur-occur-by-moccur'を起動する際に、ポイントの位置の単語をpatternの初期値として起動する。"
  :type 'boolean
  :group 'anything-c-moccur)

(defcustom anything-c-moccur-use-moccur-anything-map-flag t
  "non-nilならanything-c-moccurのデフォルトのキーバインドを使用する
nilなら使用しない"
  :type 'boolean
  :group 'anything-c-moccur)

(defcustom anything-c-moccur-recenter-count 10
  "これは選択した候補の位置にポイントを移動した後に呼ばれる 関数`recenter'に引数として渡される値である"
  :type '(choice (integer)
                 (boolean))
  :group 'anything-c-moccur)


;;; variables
(defvar anything-c-moccur-anything-invoking-flag nil)
(defvar anything-c-moccur-anything-initial-pattern "")
(defvar anything-c-moccur-anything-current-buffer nil)
(defvar anything-c-moccur-saved-info nil)
(defvar anything-c-moccur-anything-map
  (let ((map (copy-keymap anything-map)))
    (when anything-c-moccur-use-moccur-anything-map-flag
      (define-key map (kbd "D")  'anything-c-moccur-wrap-symbol)
      (define-key map (kbd "W")  'anything-c-moccur-wrap-word)
      (define-key map (kbd "F")  'anything-c-moccur-match-only-function)
      (define-key map (kbd "C")  'anything-c-moccur-match-only-comment)
      (define-key map (kbd "S")  'anything-c-moccur-match-only-string)

      (define-key map (kbd "U")  'anything-c-moccur-start-symbol)
      (define-key map (kbd "I")  'anything-c-moccur-end-symbol)
      (define-key map (kbd "O")  'anything-c-moccur-start-word)
      (define-key map (kbd "P")  'anything-c-moccur-end-word)

      (define-key map (kbd "J")  'scroll-other-window)
      (define-key map (kbd "K")  'scroll-other-window-down)

      ;; anything
      (define-key map (kbd "C-n")  'anything-c-moccur-next-line)
      (define-key map (kbd "C-p")  'anything-c-moccur-previous-line)

      (define-key map (kbd "C-M-f")  'anything-c-moccur-anything-next-file-matches)
      (define-key map (kbd "C-M-b")  'anything-c-moccur-anything-previous-file-matches))
    map))

;;overlay
(defvar anything-c-moccur-current-line-overlay
  (make-overlay (point) (point)))

;;; utilities
(defun anything-c-moccur-widen-if-need ()
  (when anything-c-moccur-widen-when-goto-line-flag
    (widen))
  (when anything-c-moccur-show-all-when-goto-line-flag
    (require 'outline)
    (show-all)))

;; regexp from `moccur-get-info'
(defvar anything-c-moccur-info-line-re "^[-+ ]*Buffer:[ ]*\\([^\r\n]*\\) File\\([^:/\r\n]*\\):[ ]*\\([^\r\n]+\\)$")

(defun anything-c-moccur-anything-move-selection-if-info-line (direction)
  (unless (= (buffer-size (get-buffer anything-buffer)) 0)
    (with-current-buffer anything-buffer
      (let ((re anything-c-moccur-info-line-re))
        (when (save-excursion
                (beginning-of-line)
                (looking-at re))
          (case direction
            (next (anything-next-line))
            (previous (anything-previous-line)))))
      (anything-mark-current-line))))

(defun anything-c-moccur-next-line-if-info-line ()
  (anything-c-moccur-anything-move-selection-if-info-line 'next))

(defun anything-c-moccur-previous-line-if-info-line ()
  (anything-c-moccur-anything-move-selection-if-info-line 'previous))

(defun anything-c-moccur-get-info ()
  "return (values buffer file)"
  (cond
   (anything-c-moccur-saved-info
    anything-c-moccur-saved-info)
   (t
    (unless (or (= (buffer-size (get-buffer anything-buffer)) 0))
      (with-current-buffer anything-buffer
        (save-excursion
          (let ((re anything-c-moccur-info-line-re))
            (when (re-search-backward re nil t)
              (values (match-string-no-properties 1) ;buffer
                      (match-string-no-properties 3))))))))))

(defun anything-c-moccur-anything-move-selection (unit direction)
  (unless (or (= (buffer-size (get-buffer anything-buffer)) 0)
              (not (get-buffer-window anything-buffer 'visible)))
    (save-selected-window
      (select-window (get-buffer-window anything-buffer 'visible))

      (case unit
        (file (let ((search-fn (case direction
                                 (next 're-search-forward)
                                 (previous (prog1 're-search-backward
                                             (re-search-backward anything-c-moccur-info-line-re nil t)))
                                 (t (error "Invalid direction.")))))
                ;;(funcall search-fn (rx bol "Buffer:" (* not-newline) "File:") nil t)))
                (funcall search-fn anything-c-moccur-info-line-re nil t)))

        (t (error "Invalid unit.")))

      (while (anything-pos-header-line-p)
        (forward-line (if (and (eq direction 'previous)
                               (not (eq (line-beginning-position)
                                        (point-min))))
                          -1
                        1)))

      (if (eobp)
          (forward-line -1))
      (anything-mark-current-line)

      ;; top
      (recenter 0))))

(defun anything-c-moccur-anything-next-file-matches ()
  (interactive)
  (anything-c-moccur-anything-move-selection 'file 'next)
  (anything-c-moccur-next-line-if-info-line)
  (anything-c-moccur-anything-try-execute-persistent-action))

(defun anything-c-moccur-anything-previous-file-matches ()
  (interactive)
  (anything-c-moccur-anything-move-selection 'file 'previous)
  (anything-c-moccur-next-line-if-info-line)
  (anything-c-moccur-anything-try-execute-persistent-action))

;;; Advise and Hack
(defun anything-c-moccur-anything-execute-persistent-action ()
  "If a candidate was selected then perform the associated action without quitting anything."
  (interactive)
  (save-selected-window
    (select-window (get-buffer-window anything-buffer))
    (select-window (setq minibuffer-scroll-window
                         (if (one-window-p t) (split-window) (next-window (selected-window) 1))))
    (let* ((anything-window (get-buffer-window anything-buffer))
           ;;(same-window-regexps '("."))
           (selection (if anything-saved-sources
                          ;; the action list is shown
                          anything-saved-selection
                        (anything-get-selection)))
           (default-action (anything-get-action))
           (action (assoc-default 'persistent-action (anything-get-current-source))))
      (setq action (or action default-action))
      (if (and (listp action)
               (not (functionp action))) ; lambda
          ;; select the default action
          (setq action (cdar action)))
      (set-window-dedicated-p anything-window t)
      (unwind-protect
          (and action selection (funcall action selection))
        (set-window-dedicated-p anything-window nil)))))

(defun anything-c-moccur-initialize ()
  (setq anything-c-moccur-anything-invoking-flag t)
  (setq anything-c-moccur-anything-current-buffer (current-buffer))
  (setq anything-c-moccur-saved-info nil))

(defun anything-c-moccur-anything-try-execute-persistent-action ()
  (when (and (ignore-errors (anything-get-current-source))
             anything-c-moccur-enable-auto-look-flag)
    (anything-c-moccur-anything-execute-persistent-action)))

(defmacro anything-c-moccur-with-anything-env (sources &rest body)
  (declare (indent 1))
  `(let ((anything-sources ,sources)
         (anything-map anything-c-moccur-anything-map)
         (anything-idle-delay (cond
                               ((integerp anything-c-moccur-anything-idle-delay)
                                anything-c-moccur-anything-idle-delay)
                               (t anything-idle-delay))))
     (anything-c-moccur-initialize)
     (add-hook  'anything-c-moccur-anything-after-update-hook 'anything-c-moccur-anything-try-execute-persistent-action)
     (unwind-protect
         (progn
           ,@body)
       (remove-hook 'anything-c-moccur-anything-after-update-hook 'anything-c-moccur-anything-try-execute-persistent-action))))

(defun anything-c-moccur-anything-update-initial-pattern ()
  (let ((minibuffer-window (active-minibuffer-window)))
    (when (and minibuffer-window
               (stringp anything-c-moccur-anything-initial-pattern))
      (with-current-buffer (window-buffer minibuffer-window)
        (insert anything-c-moccur-anything-initial-pattern)
        (anything-check-minibuffer-input)))))

(defadvice anything (around anything-c-moccur-enable-initial-pattern activate)
  (cond ((and (boundp 'anything-c-moccur-anything-invoking-flag)
              anything-c-moccur-anything-invoking-flag
              (not (string-equal "" anything-c-moccur-anything-initial-pattern)))
         (add-hook  'minibuffer-setup-hook 'anything-c-moccur-anything-update-initial-pattern)
         (unwind-protect
             ad-do-it
           (remove-hook 'minibuffer-setup-hook 'anything-c-moccur-anything-update-initial-pattern)))
        (t
         ad-do-it)))

(defun anything-c-moccur-clean-up ()
  (setq anything-c-moccur-anything-invoking-flag nil)

  (when (overlayp anything-c-moccur-current-line-overlay)
    (delete-overlay anything-c-moccur-current-line-overlay)))

(defadvice anything-cleanup (after anything-c-moccur-clean-up activate protect)
  (ignore-errors
    (anything-c-moccur-clean-up)))

;; (anything-next-line) 後のanything-update-hook
;; persistent-actionを動作させるために実装
(defvar anything-c-moccur-anything-after-update-hook nil)
(defadvice anything-process-delayed-sources (after anything-c-moccur-anything-after-update-hook activate protect)
   (when (and (boundp 'anything-c-moccur-anything-invoking-flag)
              anything-c-moccur-anything-invoking-flag)
     (ignore-errors
       (run-hooks 'anything-c-moccur-anything-after-update-hook))))

(defadvice anything-select-action (before anything-c-moccur-saved-info activate)
  (when (and (boundp 'anything-c-moccur-anything-invoking-flag)
             anything-c-moccur-anything-invoking-flag)
    (ignore-errors
      (unless anything-c-moccur-saved-info
        (setq anything-c-moccur-saved-info (anything-c-moccur-get-info))))))

(defadvice moccur-search (around anything-c-moccur-no-window-change)
  (cond
   ((and (boundp 'anything-c-moccur-anything-invoking-flag)
         anything-c-moccur-anything-invoking-flag)
    (let ((regexp (ad-get-arg 0))
          (arg (ad-get-arg 1))
          (buffers (ad-get-arg 2)))
      (when (or (not regexp)
                (string= regexp ""))
        (error "No search word specified!"))
      ;; initialize
      (let ((lst (list regexp arg buffers)))
        (if (equal lst (car moccur-searched-list))
            ()
          (setq moccur-searched-list (cons (list regexp arg buffers) moccur-searched-list))))
      (setq moccur-special-word nil)
      (moccur-set-regexp)
      (moccur-set-regexp-for-color)
      ;; variable reset
      (setq dmoccur-project-name nil)
      (setq moccur-matches 0)
      (setq moccur-match-buffers nil)
      (setq moccur-regexp-input regexp)
      (if (string= (car regexp-history) moccur-regexp-input)
          ()
        (setq regexp-history (cons moccur-regexp-input regexp-history)))
      (save-excursion
        (setq moccur-mocur-buffer (generate-new-buffer "*Moccur*"))
        (set-buffer moccur-mocur-buffer)
        (insert "Lines matching " moccur-regexp-input "\n")
        (setq moccur-buffers buffers)
        ;; search all buffers
        (while buffers
          (if (and (car buffers)
                   (buffer-live-p (car buffers))
                   ;; if b:regexp exists,
                   (if (and moccur-file-name-regexp
                            moccur-split-word)
                       (string-match moccur-file-name-regexp (buffer-name (car buffers)))
                     t))
              (if (and (not arg)
                       (not (buffer-file-name (car buffers))))
                  (setq buffers (cdr buffers))
                (if (moccur-search-buffer (car moccur-regexp-list) (car buffers))
                    (setq moccur-match-buffers (cons (car buffers) moccur-match-buffers)))
                (setq buffers (cdr buffers)))
            ;; illegal buffer
            (setq buffers (cdr buffers)))))))
   (t
    ad-do-it)))

(defun anything-c-moccur-moccur-search (regexp arg buffers)
  (ignore-errors
    (unwind-protect
        (progn
          ;; active advice
          (ad-enable-advice 'moccur-search 'around 'anything-c-moccur-no-window-change)
          (ad-activate 'moccur-search)
          ;; 空白のみで呼ばれると固まることがあったので追加
          (when (or (string-match (rx bol (+ space) eol) anything-pattern)
                    (string-equal "" anything-pattern))
            (error ""))

          (save-window-excursion
            (moccur-setup)
            (moccur-search regexp arg buffers)))
      ;; disable advance
      (ad-disable-advice 'moccur-search 'around 'anything-c-moccur-no-window-change)
      (ad-activate 'moccur-search))))

(defun anything-c-moccur-occur-by-moccur-scraper ()
  (when (buffer-live-p moccur-mocur-buffer)
    (with-current-buffer moccur-mocur-buffer
      (let* ((buf (buffer-substring (point-min) (point-max)))
             (lines (delete "" (subseq (split-string buf "\n") 3))))
        lines))))

(defun anything-c-moccur-occur-by-moccur-get-candidates ()
  (anything-c-moccur-moccur-search anything-pattern t (list anything-c-moccur-anything-current-buffer))
  (anything-c-moccur-occur-by-moccur-scraper))

(defun anything-c-moccur-occur-by-moccur-persistent-action (candidate)
  (pop-to-buffer anything-c-moccur-anything-current-buffer)
  (anything-c-moccur-widen-if-need)
  (goto-line (string-to-number candidate))
  (recenter anything-c-moccur-recenter-count)
  (when (overlayp anything-c-moccur-current-line-overlay)
    (move-overlay anything-c-moccur-current-line-overlay
                  (line-beginning-position)
                  (line-end-position)
                  (current-buffer))
    (overlay-put anything-c-moccur-current-line-overlay 'face 'highlight)))

(defun anything-c-moccur-occur-by-moccur-goto-line (candidate)
  (anything-c-moccur-widen-if-need)     ;utility
  (goto-line (string-to-number candidate))
  (recenter anything-c-moccur-recenter-count))

(defvar anything-c-source-occur-by-moccur
  `((name . "Occur by Moccur")
    (candidates . anything-c-moccur-occur-by-moccur-get-candidates)
    (action . (("Goto line" . anything-c-moccur-occur-by-moccur-goto-line)))
    (persistent-action . anything-c-moccur-occur-by-moccur-persistent-action)
    (match . (identity))
    (requires-pattern . 3)
    (delayed)
    (volatile)))

(defun anything-c-moccur-occur-by-moccur ()
  (interactive)
  (anything-c-moccur-with-anything-env (list anything-c-source-occur-by-moccur)
    (let* ((initial-pattern (if anything-c-moccur-enable-initial-pattern
                                (or (thing-at-point 'symbol) "")
                              ""))
           (anything-c-moccur-anything-initial-pattern initial-pattern))
      (when anything-c-moccur-push-mark-flag
        (push-mark))
      (anything))))

(defun anything-c-moccur-occur-by-moccur-only-function ()
  (interactive)
  (anything-c-moccur-with-anything-env (list anything-c-source-occur-by-moccur)
    (let ((anything-c-moccur-anything-initial-pattern "! "))
      (when anything-c-moccur-push-mark-flag
        (push-mark))
      (anything))))

(defun anything-c-moccur-occur-by-moccur-only-comment ()
  (interactive)
  (anything-c-moccur-with-anything-env (list anything-c-source-occur-by-moccur)
    (let ((anything-c-moccur-anything-initial-pattern ";;; "))
      (when anything-c-moccur-push-mark-flag
        (push-mark))
      (anything))))

;;; dmoccur
(defvar anything-c-moccur-dmoccur-buffers nil)

(defun anything-c-moccur-dmoccur-higligt-info-line ()
  (let ((re anything-c-moccur-info-line-re))
    (loop initially (goto-char (point-min))
          while (re-search-forward re nil t)
          do (put-text-property (line-beginning-position)
                                (line-end-position)
                                'face
                                anything-header-face))))

(defun anything-c-moccur-dmoccur-scraper ()
  (when (buffer-live-p moccur-mocur-buffer)
    (with-current-buffer moccur-mocur-buffer
      (let ((lines nil)
            (re (rx bol (group (+ not-newline)) eol)))

        ;; put face [Buffer:...] line
        (when anything-c-moccur-higligt-info-line-flag
          (anything-c-moccur-dmoccur-higligt-info-line))
        
        (loop initially (progn (goto-char (point-min))
                               (forward-line 1))
              while (re-search-forward re nil t)
              do (push (match-string 0) lines))
        (nreverse lines)))))

(defun anything-c-moccur-dmoccur-get-candidates ()
  (anything-c-moccur-moccur-search anything-pattern nil anything-c-moccur-dmoccur-buffers)
  (anything-c-moccur-dmoccur-scraper))

(defun anything-c-moccur-dmoccur-persistent-action (candidate)
  (anything-c-moccur-next-line-if-info-line)

  (let ((real-candidate (if anything-saved-sources
                            ;; the action list is shown
                            anything-saved-selection
                          (anything-get-selection))))
  
    (multiple-value-bind (buffer file-path)
        (anything-c-moccur-get-info)    ;return (values buffer file)
      (when (and (stringp buffer)
                 (bufferp (get-buffer buffer))
                 (stringp file-path)
                 (file-readable-p file-path))
        (find-file-other-window file-path)
      
        (anything-c-moccur-widen-if-need)

        (let ((line-number (string-to-number real-candidate)))
          (when (and (numberp line-number)
                     (not (= line-number 0)))
            (goto-line line-number)
      
            (recenter anything-c-moccur-recenter-count)
            (when (overlayp anything-c-moccur-current-line-overlay)
              (move-overlay anything-c-moccur-current-line-overlay
                            (line-beginning-position)
                            (line-end-position)
                            (current-buffer))
              (overlay-put anything-c-moccur-current-line-overlay 'face 'highlight))))))))

(defun anything-c-moccur-dmoccur-goto-line (candidate)
  (multiple-value-bind (buffer file-path)
                       (anything-c-moccur-get-info)
    (let ((line-number (string-to-number candidate)))
      (when (and (stringp buffer)
                 (bufferp (get-buffer buffer))
                 (stringp file-path)
                 (file-readable-p file-path))
        (find-file file-path)
        (goto-line line-number)))))

(defvar anything-c-source-dmoccur
  '((name . "DMoccur")
    (candidates . anything-c-moccur-dmoccur-get-candidates)
    (action . (("Goto line" . anything-c-moccur-dmoccur-goto-line)))
    (persistent-action . anything-c-moccur-dmoccur-persistent-action)
    (match . (identity))
    (requires-pattern . 5)
    (delayed)
    (volatile)))

(defun anything-c-moccur-dmoccur (dir)
  (interactive (list (dmoccur-read-from-minibuf current-prefix-arg)))
  (let ((buffers (sort
                   (moccur-add-directory-to-search-list dir)
                   moccur-buffer-sort-method)))

  (setq anything-c-moccur-dmoccur-buffers buffers)

  (anything-c-moccur-with-anything-env (list anything-c-source-dmoccur)
    (anything))))

;;; dired-do-moccur
(defvar anything-c-moccur-dired-do-moccur-buffers nil)

(defun anything-c-moccur-dired-get-buffers ()
  (moccur-add-files-to-search-list
   (funcall (cond ((fboundp 'dired-get-marked-files) ; GNU Emacs
                   'dired-get-marked-files)
                  ((fboundp 'dired-mark-get-files) ; XEmacs
                   'dired-mark-get-files))
            t nil) default-directory t 'dired))

(defun anything-c-moccur-dired-do-moccur-by-moccur-get-candidates ()
  (anything-c-moccur-moccur-search anything-pattern nil anything-c-moccur-dired-do-moccur-buffers)
  (anything-c-moccur-dmoccur-scraper))

(defvar anything-c-source-dired-do-moccur
  '((name . "Dired do Moccur")
    (candidates . anything-c-moccur-dired-do-moccur-by-moccur-get-candidates)
    (action . (("Goto line" . anything-c-moccur-dmoccur-goto-line)))
    (persistent-action . anything-c-moccur-dmoccur-persistent-action)
    (match . (identity))
    (requires-pattern . 3)
    (delayed)
    (volatile)))

(defun anything-c-moccur-dired-do-moccur-by-moccur ()
  (interactive)
  (let ((buffers (anything-c-moccur-dired-get-buffers)))
    (setq anything-c-moccur-dired-do-moccur-buffers buffers)

    (anything-c-moccur-with-anything-env (list anything-c-source-dired-do-moccur)
      (anything))))

;;; Commands for `anything-c-moccur-anything-map'
(defun anything-c-moccur-next-line ()
  (interactive)
  (anything-next-line)
  (anything-c-moccur-next-line-if-info-line)
  (anything-c-moccur-anything-try-execute-persistent-action))

(defun anything-c-moccur-previous-line ()
  (interactive)
  (anything-previous-line)
  (anything-c-moccur-previous-line-if-info-line)
  (anything-c-moccur-anything-try-execute-persistent-action))

(defun anything-c-moccur-wrap-word-internal (s1 s2)
  (ignore-errors
    (save-excursion
      (backward-sexp)
      (insert s1))
    (insert s2)))

(defun anything-c-moccur-start-symbol ()
  (interactive)
  (anything-c-moccur-wrap-word-internal "\\_<" ""))

(defun anything-c-moccur-end-symbol ()
  (interactive)
  (anything-c-moccur-wrap-word-internal "" "\\_>"))

(defun anything-c-moccur-wrap-symbol ()
  (interactive)
  (anything-c-moccur-wrap-word-internal "\\_<" "\\_>"))

(defun anything-c-moccur-start-word ()
  (interactive)
  (anything-c-moccur-wrap-word-internal "\\<" ""))

(defun anything-c-moccur-end-word ()
  (interactive)
  (anything-c-moccur-wrap-word-internal "" "\\>"))

(defun anything-c-moccur-wrap-word ()
  (interactive)
  (anything-c-moccur-wrap-word-internal "\\<" "\\>"))



;; minibuf: hoge
;; => minibuf: ! hoge
(defun anything-c-moccur-delete-special-word ()
  (let ((re (rx (or "!" ";" "\"")
                (* space))))
    (ignore-errors
      (save-excursion
        (beginning-of-line)
        (when (looking-at re)
          (replace-match ""))))))

(defun anything-c-moccur-match-only-internal (str)
  (anything-c-moccur-delete-special-word)
  (save-excursion
    (beginning-of-line)
    (insert-before-markers str)))

(defun anything-c-moccur-match-only-function ()
  (interactive)
  (anything-c-moccur-match-only-internal "! "))

(defun anything-c-moccur-match-only-comment ()
  (interactive)
  (anything-c-moccur-match-only-internal "; "))

(defun anything-c-moccur-match-only-string ()
  (interactive)
  (anything-c-moccur-match-only-internal "\" "))

(provide 'anything-c-moccur)

;;; anything-c-moccur.el ends here