;; astma-mode.el --- a mode for AsTMa= topic map files 
;; $Id: astma-mode.el,v 1.3 2008/02/26 03:52:00 az Exp $

;; this mode provides only syntax highlighting so far
;; the font lock fonts are, well, randomly chosen
;; details of the format: http://astma.topicmaps.bond.edu.au/

;; copyright (c) 2008 Alexander Zangerl <az@snafu.priv.at>

;;   This program is free software; you can redistribute it and/or modify
;;   it under the terms of the GNU General Public License as published by
;;   the Free Software Foundation; either version 2 of the License, or
;;   (at your option) any later version.

;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU General Public License for more details.

;;   You should have received a copy of the GNU General Public License with
;;   the Debian GNU/Linux distribution in file /usr/share/common-licenses/GPL;
;;   if not, write to the Free Software Foundation, Inc., 
;;         51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.


(require 'generic)

(define-generic-mode 'astma-mode
  ;; comment char
  (list "#")
  ;; keywords
  (list "reifies" "is-reified-by"  )
  ;; additional font-locking, see font-lock-keywords documentation
  (list 
   ;; simple keywords
   "^\\(sin\\|oc\\|in\\|bn\\)\\s-*:"
   ;; typed topics
   '("^\\s-*[a-zA-Z0-9_-]+\\s-*\\(([a-zA-Z0-9_ -]+)\\)" 1 font-lock-type-face )
   ;; assocs
   '("^\\s-*(.+)\\s-*$" . font-lock-function-name-face)
   ;; chars if typed and/or scoped, refined further
   '( "^\\s-*\\(\\(in\\|oc\\|bn\\)\\s-*\\(@\\s-*[a-zA-Z0-9_-]+\\s-*\\)?\\s-*\\((.*)\\)?\\s-*:\\)" 1 font-lock-keyword-face t)
   ;; scopes
   '( "^\\s-*\\(in\\|oc\\|bn\\)\\s-*\\(@\\s-*[a-zA-Z0-9_-]+\\s-*\\)\\s-*\\((.*)\\)?\\s-*:" 2 font-lock-constant-face t)
   ;; and the types
   '( "^\\s-*\\(in\\|oc\\|bn\\)\\s-*\\(@\\s-*[a-zA-Z0-9_-]+\\s-*\\)?\\s-*\\((.*)\\)\\s-*:" 3 font-lock-function-name-face t)
   ;; finally, one for assoc roles
   '( "^\\s-*\\([a-zA-Z0-9_-]+\\s-*:\\)" 1 font-lock-variable-name-face ) 

   )
  ;; auto-mode
  (list "\\.atm$")
  ;; additional setup
  nil
  ;; description
  "Mode for AsTMa= documents."
  )
