;;; twinkle-fingers.el --- Write emacs lisp commands by pressing keybindings

;; Write emacs lisp commands just by pressing keybindings
;; Copyright (C) 2013 Eric Crosson
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; This code allows a user to write emacs lisp code by just pressing
;; the desired key bindings (and entering the manual arguments.) In
;; other words, pressing a command key will insert said command as
;; emacs lisp. The arguments will need to be filled in by the user at
;; this stage. As such, I highly recommend the usage of this package
;; with eldoc mode. It's a snap to set up, see the emacs wiki. This
;; package came from a desire for something better than stock keyboard
;; macros.
;;
;; To activate `twinkle-fingers', press C-c <f3>. Now you are ready This
;; package came from a desire for something better than stock keyboard macros.to
;; begin transcribing emacs lisp as quickly as you would work over text
;; in a regular buffer. For example, press any letter key. You will see
;; the following text inserted
;;
;; (self-insert-command |)
;;
;; This is because pressing a letter key runs the
;; `self-insert-command'. At this point, you have the option to add any
;; desired arguments to the command, which you will be able to edit
;; unmolested by `twinkle-fingers'. When you are ready to enter the
;; next command, press <return>, which will run
;; `tf/return'. This command will remove any junk whitespace before
;; the final closing paren and move point to the next line. When you
;; are ready to exit `twinkle-fingers', do so with C-c <f4>.

;; Tips and tricks:
;; Sometimes you may find you have entered the wrong command. From
;; this point:
;;
;; (self-insert-command |)
;;
;; pressing "C-<backspace>" will clear the entire line of text,
;; leaving you free to enter the desired command.


;; TODO add a way to input `tf/twinkle-fingers-quit'

;;; Version 0.9.0

;;; Code:

;;;; Variables
(defvar tf/keymap (make-sparse-keymap))

(define-minor-mode twinkle-fingers
  "A mode to easily input emacs-lisp."
  :lighter " twinkle"
  :keymap tf/keymap)

(add-hook 'twinkle-fingers-hook
	  (lambda()
	    (if (and (boundp 'twinkle-fingers) twinkle-fingers)
		(progn
		  ;; Run this code when entering twinkle-fingers
		  (message "Looping")
		  (tf/capture-command-loop))
	      ;; Run this code upon exit
	      (message "Twinkle-fingers mode exited"))))

;; invocation keybindings
(global-set-key (kbd "C-c <f3>") 'twinkle-fingers)
(global-set-key (kbd "C-c <f4>") 'tf/twinkle-fingers-quit)

;;;; twinkle-fingers keybindings
(define-key tf/keymap (kbd "C-j") 'tf/return)
(define-key tf/keymap (kbd "<return>") 'tf/return)
(define-key tf/keymap (kbd "C-<backspace>") 'tf/backspace)

;;;; Interactive defuns
(defun tf/newline()
  "RET for `twinkle-fingers'."
  (interactive)
  (replace-regexp "[[:space:]]*)" ")" nil
		  (line-beginning-position) (line-end-position))
  (end-of-line)
  (newline)
  (indent-according-to-mode))

(defun tf/twinkle-fingers-quit()
  "Quit `twinkle-fingers'."
  (interactive)
  (twinkle-fingers -1))

;;;; Non-interactive defuns
(defun tf/return()
  (interactive)
  (tf/newline)
  (tf/capture-command-loop))

(defun tf/backspace()
  (interactive)
  (end-of-line)
  (kill-line 0)
  (tf/capture-command-loop))

(defun tf/capture-command()
  "Return a nicely formatted string containing the last executed
command."
  (let ((cmd (car (last (split-string (describe-key-briefly
				       (read-key-sequence "")))))))
    (if (not (string-match "twinkle-fingers-quit" cmd))
	(concat "(" cmd " )")
      (tf/twinkle-fingers-quit))))

(defun tf/capture-command-loop()
  "Loop to capture and insert commands for `twinkle-fingers'."
  (interactive)
  (let ((command (tf/capture-command)))
    (when command
      (insert command)
      (backward-char))))

(provide 'twinkle-fingers)

;;; twinkle-fingers.el ends here
