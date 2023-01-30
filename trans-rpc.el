;;; trans-rpc.el --- Translation zh and en  -*- lexical-binding:t; -*-
;; Copyright (C) 2023 xiliuya
;; Filename: trans-rpc.el
;; Description: Translation zh and en with openai.
;; Author: xiliuya
;; Maintainer: xiliuya <xiliuya@aliyun.com>
;; Created: Mon Jan 30 21:06:08 2023 (+0800)
;; Version: 0.0.1
;; Package-Requires: ((emacs "25.1"))
;; Last-Updated:
;;           By:
;;     Update #: 5
;; URL:  https://github.com/xiliuya/trans_rpc
;; Doc URL:
;; Keywords: extensions Trans
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;; trans fram python rpc with openai.
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;; 30-Jan-2023    xiliuya
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(defun trans-rpc-keep-output (process output)
  ;;(message output)
  (if (not (null output))
      (message (replace-regexp-in-string "[\n-]" "" output)))
  )

(defun trans-rpc-trans (lang-str trans-str)
  "Trans string.
LANG-STR: STRING
TRANS-STR: STRING"
  ;;(setq command-list (list "echo" "0" trans-str))

  (if (and (stringp trans-str)
           (not (get-process "trans-rpc"))
           )
      (progn
        (setq command-list (list "python" "/home/xiliuya/test/python/openai/trans_rpc/trans_rpc_client.py" "-l" lang-str "-s" trans-str))
        (make-process :name "trans-rpc"
                      :command command-list
                      :buffer "*Messages*"
                      :filter 'trans-rpc-keep-output
                      ))))
(defun trans-rpc-tts (tts-str trans-str)
  (if (and (stringp trans-str)
           (not (get-process "tts-rpc"))
           )
      (progn
        (setq command-list (list "python" "/home/xiliuya/test/python/openai/trans_rpc/trans_rpc_client.py" "-t" tts-str "-s" trans-str))
        (make-process :name "trans-rpc"
                      :command command-list
                      :buffer "*Messages*"
                      ;; :filter 'trans-rpc-keep-output
                      ))))

(defun trans-rpc-form-point-en ()
  (interactive)
  (setq trans-string  (thing-at-point 'sentence t))
  (if (null trans-string)
      (setq trans-string  (thing-at-point 'line t)))
  (if (not (null trans-string))
      (progn
        (trans-rpc-trans "en"
                         (replace-regexp-in-string "[\n-=]" "" trans-string))
        (trans-rpc-tts "en"
                       (replace-regexp-in-string "[\n-=]" "" trans-string))
        )
    (message "Null input")
    ))

(defun trans-rpc-form-point-zh ()
  (interactive)
  (setq trans-string  (thing-at-point 'sentence t))
  (if (null trans-string)
      (setq trans-string  (thing-at-point 'line t)))
  (if (not (null trans-string))
      (trans-rpc-trans "zh" trans-string)
    (message "Null input")
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'trans-rpc)
;;; trans-rpc.el ends here
