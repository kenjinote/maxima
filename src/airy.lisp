;;; Airy functions Ai(z) and Bi(z) - A&S 10.4
;;;
;;; airy_ai(z)   - Airy function Ai(z)
;;; airy_dai(z)  - Derivative of Airy function Ai(z)
;;; airy_bi(z)   - Airy function Bi(z)
;;; airy_dbi(z)  - Derivative of Airy function Bi(z)

;;;; Copyright (C) 2005 David Billinghurst

;;;; airy.lisp is free software; you can redistribute it
;;;; and/or modify it under the terms of the GNU General Public
;;;; License as published by the Free Software Foundation; either
;;;; version 2, or (at your option) any later version.

;;;; airy.lisp is distributed in the hope that it will be
;;;; useful, but WITHOUT ANY WARRANTY; without even the implied
;;;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;;;; See the GNU General Public License for more details.

;;;; You should have received a copy of the GNU General Public License
;;;; along with command-line.lisp; see the file COPYING.  If not,
;;;; write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

(in-package :maxima)

(declaim (special *flonum-op*))

;; Airy Ai function 
(defmfun $airy_ai (z)
  "Airy function Ai(z)"
  (simplify (list '(%airy_ai) (resimplify z))))

(defprop %airy_ai simplim%airy_ai simplim%function)
(defprop %airy_ai ((z) ((%airy_dai) z)) grad)

;; airy_ai distributes over lists, matrices, and equations
(defprop %airy_ai (mlist $matrix mequal) distribute_over)

;; airy_ai has mirror symmetry
(defprop %airy_ai t commutes-with-conjugate)

;; Integral of Ai(z)
;; http://functions.wolfram.com/03.05.21.0002.01
;; (z/(3^(2/3)*gamma(2/3)))*hypergeometric([1/3],[2/3,4/3],z^3/9)
;; - (3^(1/6)/(4*%pi))*z^2*gamma(2/3)*hypergeometric([2/3],[4/3,5/3],z^3/9);
(defprop %airy_ai
  ((z)
   ((mplus)
    ((mtimes) 
     ((mexpt) 3 ((rat) -2 3))
     ((mexpt) ((%gamma) ((rat) 2 3)) -1)
     (($hypergeometric) 
      ((mlist) ((rat) 1 3))
      ((mlist) ((rat) 2 3) ((rat) 4 3)) 
      ((mtimes) ((rat) 1 9) ((mexpt) z 3)))
     z)
   ((mtimes) 
    ((rat) -1 4) ((mexpt) 3 ((rat) 1 6)) ((mexpt) $%pi -1) ((%gamma) ((rat) 2 3))
    (($hypergeometric) 
     ((mlist) ((rat) 2 3)) 
     ((mlist) ((rat)  4 3) ((rat) 5 3))
     ((mtimes) ((rat) 1 9) ((mexpt) z 3)))
    ((mexpt) z 2))))
  integral)

(defun airy-ai (z)
  (cond ((floatp z) (airy-ai-real z))
	((complexp z) (airy-ai-complex z))))

(setf (gethash '%airy_ai *flonum-op*) #'airy-ai)

(defun simplim%airy_ai (expr var val)
  ; Look for the limit of the argument
  (let ((z (limit (cadr expr) var val 'think)))
    (cond ((or (eq z '$inf)   ; A&S 10.4.59
	       (eq z '$minf)) ; A&S 10.4.60
	   0)
	  (t
	   ; Handle other cases with the function simplifier
	   (simplify (list '(%airy_ai) z))))))

(def-simplifier airy_ai (z)
  (cond ((equal z 0)	     ; A&S 10.4.4: Ai(0) = 3^(-2/3)/gamma(2/3)
	 '((mtimes simp)
	   ((mexpt simp) 3 ((rat simp) -2 3))
	   ((mexpt simp) ((%gamma simp) ((rat simp) 2 3)) -1)))
	((flonum-eval (mop form) z))
	(t (give-up))))


;; Derivative dAi/dz of Airy function Ai(z)
(defmfun $airy_dai (z)
  "Derivative dAi/dz of Airy function Ai(z)"
  (simplify (list '(%airy_dai) (resimplify z))))

(defprop %airy_dai simplim%airy_dai simplim%function)
(defprop %airy_dai ((z) ((mtimes) z ((%airy_ai) z))) grad)
(defprop %airy_dai ((z) ((%airy_ai) z)) integral)

;; airy_dai distributes over lists, matrices, and equations
(defprop %airy_dai (mlist $matrix mequal) distribute_over)

;; airy_dai has mirror symmetry
(defprop %airy_dai t commutes-with-conjugate)

(defun airy-dai (z)
  (cond ((floatp z) (airy-dai-real z))
	((complexp z) (airy-dai-complex z))))

(setf (gethash '%airy_dai *flonum-op*) #'airy-dai)

(defun simplim%airy_dai (expr var val)
  ; Look for the limit of the argument
  (let ((z (limit (cadr expr) var val 'think)))
    (cond ((eq z '$inf) ; A&S 10.4.61
	   0)
	  ((eq z '$minf) ; A&S 10.4.62
	   '$und)
	  (t
	   ; Handle other cases with the function simplifier
	   (simplify (list '(%airy_dai) z))))))

(def-simplifier airy_dai (z)
  (cond ((equal z 0)	   ; A&S 10.4.5: Ai'(0) = -3^(-1/3)/gamma(1/3)
         '((mtimes simp) -1
	   ((mexpt simp) 3 ((rat simp) -1 3))
	   ((mexpt simp) ((%gamma simp) ((rat simp) 1 3)) -1)))
	((flonum-eval (mop form) z))
	(t (give-up))))

;; Airy Bi function 
(defmfun $airy_bi (z)
  "Airy function Bi(z)"
  (simplify (list '(%airy_bi) (resimplify z))))

(defprop %airy_bi simplim%airy_bi simplim%function)
(defprop %airy_bi ((z) ((%airy_dbi) z)) grad)

;; airy_bi distributes over lists, matrices, and equations
(defprop %airy_bi (mlist $matrix mequal) distribute_over)

;; airy_bi has mirror symmetry
(defprop %airy_bi t commutes-with-conjugate)

;; Integral of Bi(z)
;; http://functions.wolfram.com/03.06.21.0002.01
;; (z/(3^(1/6)*gamma(2/3)))*hypergeometric([1/3],[2/3,4/3],z^3/9)
;; + (3^(2/3)/(4*%pi))*z^2*gamma(2/3)*hypergeometric([2/3],[4/3,5/3],z^3/9);
(defprop %airy_bi
  ((z)
   ((mplus)
    ((mtimes) 
     ((mexpt) 3 ((rat) -1 6))
     ((mexpt) ((%gamma) ((rat) 2 3)) -1)
     (($hypergeometric) 
      ((mlist) ((rat) 1 3))
      ((mlist) ((rat) 2 3) ((rat) 4 3)) 
      ((mtimes) ((rat) 1 9) ((mexpt) z 3)))
     z)
   ((mtimes) 
    ((rat) 1 4) ((mexpt) 3 ((rat) 2 3)) ((mexpt) $%pi -1) ((%gamma) ((rat) 2 3))
    (($hypergeometric) 
     ((mlist) ((rat) 2 3)) 
     ((mlist) ((rat)  4 3) ((rat) 5 3))
     ((mtimes) ((rat) 1 9) ((mexpt) z 3)))
    ((mexpt) z 2))))
  integral)

(defun airy-bi (z)
  (cond ((floatp z) (airy-bi-real z))
	((complexp z) (airy-bi-complex z))))

(setf (gethash '%airy_bi *flonum-op*) #'airy-bi)

(defun simplim%airy_bi (expr var val)
  ; Look for the limit of the argument
  (let ((z (limit (cadr expr) var val 'think)))
    (cond ((eq z '$inf) ; A&S 10.4.63
	   '$inf)
	  ((eq z '$minf) ; A&S 10.4.64
	   0)
	  (t
	   ; Handle other cases with the function simplifier
	   (simplify (list '(%airy_bi) z))))))

(def-simplifier airy_bi (z)
  (cond ((equal z 0) ; A&S 10.4.4: Bi(0) = sqrt(3) 3^(-2/3)/gamma(2/3)
	 '((mtimes simp)
	   ((mexpt simp) 3 ((rat simp) -1 6))
	   ((mexpt simp) ((%gamma simp) ((rat simp) 2 3)) -1)))
	((flonum-eval (mop form) z))
	(t (give-up))))


;; Derivative dBi/dz of Airy function Bi(z)
(defmfun $airy_dbi (z)
  "Derivative dBi/dz of Airy function Bi(z)"
  (simplify (list '(%airy_dbi) (resimplify z))))

(defprop %airy_dbi simplim%airy_dbi simplim%function)
(defprop %airy_dbi ((z) ((mtimes) z ((%airy_bi) z))) grad)
(defprop %airy_dbi ((z) ((%airy_bi) z)) integral)

;; airy_dbi distributes over lists, matrices, and equations
(defprop %airy_dbi (mlist $matrix mequal) distribute_over)

;; airy_dbi has mirror symmetry
(defprop %airy_dbi t commutes-with-conjugate)

(defun airy-dbi (z)
  (cond ((floatp z) (airy-dbi-real z))
	((complexp z) (airy-dbi-complex z))))

(setf (gethash '%airy_dbi *flonum-op*) #'airy-dbi)

(defun simplim%airy_dbi (expr var val)
  ; Look for the limit of the argument
  (let ((z (limit (cadr expr) var val 'think)))
    (cond ((eq z '$inf) ; A&S 10.4.66
	   '$inf)
	  ((eq z '$minf) ; A&S 10.4.67
	   '$und)
	  (t
	   ; Handle other cases with the function simplifier
	   (simplify (list '(%airy_dbi) z))))))

(def-simplifier airy_dbi (z)
  (cond ((equal z 0) ; A&S 10.4.5: Bi'(0) = sqrt(3) 3^(-1/3)/gamma(1/3)
         '((mtimes simp) 
	   ((mexpt simp) 3 ((rat simp) 1 6))
	   ((mexpt simp) ((%gamma simp) ((rat simp) 1 3)) -1)))
	((flonum-eval (mop form) z))
	(t (give-up))))

;; Numerical routines using slatec functions

(defun airy-ai-real (z)
  " Airy function Ai(z) for real z"
  (declare (type flonum z))
  ;; slatec:dai issues underflow warning for z > zmax.  See dai.{f,lisp}
  ;; This value is correct for IEEE double precision
  (let ((zmax 92.5747007268))
    (declare (type flonum zmax))
    (if (< z zmax) (slatec:dai z) 0.0))) 

(defun airy-ai-complex (z)
  "Airy function Ai(z) for complex z"
  (declare (type (complex flonum) z))
  (multiple-value-bind (var-0 var-1 var-2 var-3 air aii nz ierr)
      (slatec:zairy (realpart z) (imagpart z) 0 1 0.0 0.0 0 0)
    (declare (type flonum air aii)
	     (type f2cl-lib:integer4 nz ierr)
	     (ignore var-0 var-1 var-2 var-3))
    ;; Check nz and ierr for errors
    (if (and (= nz 0) (= ierr 0)) (complex air aii) nil)))

(defun airy-dai-real (z)
  "Derivative dAi/dz of Airy function Ai(z) for real z"
  (declare (type flonum z))
  (let ((rz (sqrt (abs z)))
	(c (* 2/3 (expt (abs z) 3/2))))
    (declare (type flonum rz c))
    (multiple-value-bind (var-0 var-1 var-2 ai dai)
	(slatec:djairy z rz c 0.0 0.0)
      (declare (ignore var-0 var-1 var-2 ai))
      dai)))

(defun airy-dai-complex (z)
  "Derivative dAi/dz of Airy function Ai(z) for complex z"
  (declare (type (complex flonum) z))
  (multiple-value-bind (var-0 var-1 var-2 var-3 air aii nz ierr)
      (slatec:zairy (realpart z) (imagpart z) 1 1 0.0 0.0 0 0)
    (declare (type flonum air aii)
	     (type f2cl-lib:integer4 nz ierr)
	     (ignore var-0 var-1 var-2 var-3))
    ;; Check nz and ierr for errors
    (if (and (= nz 0) (= ierr 0)) (complex air aii) nil)))

(defun airy-bi-real (z)
  "Airy function Bi(z) for real z"
  (declare (type flonum z))
  ;; slatec:dbi issues overflows for z > zmax.  See dbi.{f,lisp}
  ;; This value is correct for IEEE double precision
  (let ((zmax 104.2179765192136))
    (declare (type flonum zmax))
    (if (< z zmax) (slatec:dbi z) nil)))

(defun airy-bi-complex (z)
  "Airy function Bi(z) for complex z"
  (declare (type (complex flonum) z))
  (multiple-value-bind (var-0 var-1 var-2 var-3 bir bii ierr)
      (slatec:zbiry (realpart z) (imagpart z) 0 1 0.0 0.0 0)
    (declare (type flonum bir bii)
	     (type f2cl-lib:integer4 ierr)
	     (ignore var-0 var-1 var-2 var-3))
    ;; Check ierr for errors
    (if (= ierr 0) (complex bir bii) nil)))

(defun airy-dbi-real (z)
  "Derivative dBi/dz of Airy function Bi(z) for real z"
  (declare (type flonum z))
  ;; Overflows for z > zmax.
  ;; This value is correct for IEEE double precision
  (let ((zmax 104.1525))
    (declare (type flonum zmax))
    (if (< z zmax)
	(let ((rz (sqrt (abs z)))
	      (c (* 2/3 (expt (abs z) 3/2))))
        (declare (type flonum rz c))
        (multiple-value-bind (var-0 var-1 var-2 bi dbi)
	    (slatec:dyairy z rz c 0.0 0.0)
	  (declare (type flonum bi dbi)
		   (ignore var-0 var-1 var-2 bi))
	  dbi))
      ;; Will overflow.  Return unevaluated.
      nil)))

(defun airy-dbi-complex (z)
  "Derivative dBi/dz of Airy function Bi(z) for complex z"
  (declare (type (complex flonum) z))
  (multiple-value-bind (var-0 var-1 var-2 var-3 bir bii ierr)
      (slatec:zbiry (realpart z) (imagpart z) 1 1 0.0 0.0 0)
    (declare (type flonum bir bii)
	     (type f2cl-lib:integer4 ierr)
	     (ignore var-0 var-1 var-2 var-3))
    ;; Check ierr for errors
    (if (= ierr 0) (complex bir bii) nil)))
