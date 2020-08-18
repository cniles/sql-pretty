;;; sql-pretty.el --- Prettify SQL with Python sqlparse module

;; Copyright (C) 2020 Craig Niles

;; Author: Craig Niles <niles.c@gmail.com>
;; Version: 0.1
;; Keywords: SQL pretty format
;; URL: https://github.com/cniles/sql-pretty

;; sql-Pretty is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; sql-Pretty is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with Sql-Pretty.  If not, see http://www.gnu.org/licenses.

;;; Commentary:

;; This package provides a simple command for pretty-printing a buffer
;; containing SQL.  A single interactive function lets you replace the
;; SQL text in the current buffer with a pretty-printed version.  Text
;; is formatted using the python sqlparse module.

;;; Need to install python sqlparse first:
;;;   python -m pip install sqlparse

;;; Code:

(defun sql-pretty (begin end)
  "Format text in buffer from BEGIN to END."
  (let ((temp-file (make-temp-file "sql-pretty")))
    (write-region begin end temp-file)
    (delete-region (region-beginning) (region-end))
    (call-process "python" temp-file t t
		  "-c" "import sqlparse; import fileinput; print(sqlparse.format(' '.join([line for line in fileinput.input()]), reindent=True, keyword_case='upper'))")))

;;;###autoload
(defun sql-pretty-print-buffer ()
  "SQL Prettify the current buffer."
  (interactive)
  (sql-pretty (point-min) (point-max)))

;;;###autoload
(defun sql-pretty-print-region ()
  "SQL Prettify the selected region."
  (interactive)
  (sql-pretty (region-beginning) (region-end)))

(provide 'sql-pretty)
;;; sql-pretty.el ends here
