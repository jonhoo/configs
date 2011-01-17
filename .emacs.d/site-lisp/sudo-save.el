;;; sudo-save.el --- Allow saving files using sudo

;; Copyright (C) 2003 Free Software Foundation, Inc.

;; Author: Kevin A. Burton (burton@peerfear.org)
;; Maintainer: Kevin A. Burton (burton@peerfear.org)
;; Location: http://www.peerfear.org
;; Keywords: 
;; Version: 1.0

;; This file is [not yet] part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 2 of the License, or any later version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
;; Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Commentary:

;; Use `write-file-hooks' and `after-save-hook' to run "sudo chown ... " before
;; AND after file save.  This allows the Emacs process to grant ownership to the
;; user and then restore ownership just after save.

;; TODO:
;;
;; - Actually what we SHOULD do is actually do a chown this way and NOT a chmod.
;;
;; - Can sudo cache passwords?  I think it can.
;;
;; - Ability to chmod a+r a file JUST prior to reading it ... and then restoring
;;   permissions RIGHT after it.
;;
;; - Ability to s
;;

;;; History:
  
;;; Code:

(defvar sudo-save-file-uid nil "")

(defun sudo-save--after-save-hook()
  "If we've chown'd this file then we should restore it's ownership."

  (when sudo-save-file-uid

    ;;restore original file access.
    (sudo-save--chown (number-to-string sudo-save-file-uid) (buffer-file-name))
    
    (setq sudo-save-file-uid nil)

    (message "Wrote (with sudo) %s" (buffer-file-name))))

(defun sudo-save--chown(user file-name)

  (message "sudo chown %s %s" user file-name)

  (call-process "sudo" nil nil nil
                "chown"
                user
                file-name))
  
(defun sudo-save--write-file-hook()
  "Take ownership of this file and later restore it."

  ;;take a snapshow of the owner of the file.

  ;;call sudo to change the file's modes

  (when (not (file-writable-p (buffer-file-name)))

    ;;preserve uid of file
    (setq sudo-save-file-uid (nth 2 (file-attributes (buffer-file-name))))
    
    (sudo-save--chown user-login-name (buffer-file-name)))
  
  nil)

(defun sudo-save--find-file-hook()
  "Disable read-only support since this is no obsolete for this file."
  (setq buffer-read-only nil))
  
(add-hook 'write-file-hooks 'sudo-save--write-file-hook)
(add-hook 'after-save-hook 'sudo-save--after-save-hook)
(add-hook 'find-file-hooks 'sudo-save--find-file-hook)

(provide 'sudo-save)

;;; sudo-save.el ends here
