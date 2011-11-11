;; Copyright (C) 2011 Rosario Raulin
;; 
;; This file is part of amicable.
;; 
;; amicable is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; 
;; amicable is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with amicable. If not, see <http://www.gnu.org/licenses/>.

(defpackage amicable-pairs
    (:use
     :common-lisp)
  (:export
   :amicable))

(in-package :amicable-pairs)

(defparameter *factor-sums* (make-hash-table))

(defun factor-sum (n)
  (or (gethash n *factor-sums*)
      (setf (gethash n *factor-sums*)
	    (loop with sum = 1
		  for x from 2 to (1+ (sqrt n))
		  ;; using loop keyword "sum" isn't possible here because it's
		  ;; not portable...
		  when (= (mod n x) 0)
		    do (incf sum (+ x (truncate n x)))
		  finally (return sum)))))

(defun amicable (n)
  (loop with n-pairs = 0
	while (/= n-pairs n)
	for x from 2
	for s1 = (factor-sum x)
	for s2 = (if (> s1 x)
		     (factor-sum s1)
		     0)
	when (= x s2)
	  collect (cons x s1)
	  and do (incf n-pairs)))
