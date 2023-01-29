;;; trans-rpc.el --- Translation zh and en  -*- lexical-binding:t; -*-

;; Copyright (C) 2014 xiliuya

;; Author: xiliuya <xiliuya@aliyun.com>
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Package-Requires: ((emacs "27.1") (eldoc "1.3") )
;;; Commentary: trans fram python rpc https://xiliuya.github.i

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
  (if (not (null trans-string))
      (progn
        (trans-rpc-trans "en"
                         (replace-regexp-in-string "[\n-]" "" trans-string))
        (trans-rpc-tts "en"
                       (replace-regexp-in-string "[\n-]" "" trans-string))
        )
    (message "Null input")
    ))

(defun trans-rpc-form-point-zh ()
  (interactive)
  (setq trans-string  (thing-at-point 'sentence t))
  (if (not (null trans-string))
      (trans-rpc-trans "zh" trans-string)
    (message "Null input")
    ))

(provide 'trans-rpc)
;;; trans-rpc.el ends here
