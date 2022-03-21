(defun replace-substring (in-string old new) 
  (let ((result ""))
    (do ((begin 0)
	 (end (search old in-string) 
	      (search old in-string :start2 begin)))
	((>= begin (length in-string)) 'done)
      (if end
	  (progn (setf result (concatenate 'string result 
					   (subseq in-string begin end)
					   new))
		 (setf begin (+ end (length old))))
	  (progn (setf result (concatenate 'string result 
					   (subseq in-string begin
						   (length in-string))))
		 (setf begin (length in-string)))))
    result))

(defun process-file (in-filename out-filename substitutions)
  (with-open-file (in in-filename :direction :input)
    (with-open-file (out out-filename :direction :output
			 :if-exists :supersede)
      (do ((line (read-line in nil 'eof)
		 (read-line in nil 'eof)))
	  ((eql line 'eof))
	(mapc #'(lambda (pair)
		  (setf line (replace-substring line 
						(first pair)
						(rest pair))))
	      substitutions)
	(format out "~a~%" line)))))

(defun read-with-default (prompt default)
  (format t "~a [~a]: " prompt default)
  (terpri)
  (let ((response (string-right-trim '(#\Return) (read-line))))
    (if (string= response "") default response)))


;;; This function (only) modified from CLOCC http://clocc.sourceforge.net
(defun default-directory-string ()
  (string-right-trim 
   "\\" (string-right-trim 
	 "/"
	 (namestring  
	  #+allegro (excl:current-directory)
	  #+clisp (#+lisp=cl ext:default-directory 
			     #-lisp=cl lisp:default-directory)
	  #+cmu (ext:default-directory)
	  #+scl (unix-namestring (ext:default-directory))
	  #+cormanlisp (ccl:get-current-directory)
	  #+lispworks (hcl:get-working-directory)
	  #+lucid (lcl:working-directory)
	  #-(or allegro clisp cmu scl cormanlisp lispworks lucid) 
	  (truename ".")))))
  
(defun get-version ()
  (with-open-file (in "configure.ac" :direction :input)
    (do ((line (read-line in nil 'eof)
               (read-line in nil 'eof))
         (version "")
         temp)
        ((eq line 'eof)
         (when (string= version "")
           (format t "Warning: No version information found.~%~%"))
         version)
      (when (search "AC_INIT([maxima]," line)
        (setq line (string-trim '(#\Return) line))
        (setq temp
              (replace-substring line "AC_INIT([maxima], [" ""))
        (setq version
              (replace-substring temp "])" ""))
        (when (or (string= temp line)
                  (string= temp version))
          ; Failed substitution
          (format t "Warning: Problem parsing version information. ")
          (format t "Found: \"~a\"~%~%" version))))))

(defvar *maxima-lispname* #+clisp "clisp"
	#+cmu "cmucl"
	#+scl "scl"
	#+sbcl "sbcl"
	#+gcl "gcl"
	#+allegro "acl"
	#+(and openmcl (not 64-bit-target)) "openmcl"
	#+(and openmcl 64-bit-target) "ccl64"
	#+abcl "abcl"
	#+ecl "ecl"
	#-(or clisp cmu scl sbcl gcl allegro ccl abcl ecl) "unknownlisp")

(defun configure (&key (interactive t) (verbose nil)
		  is-win32 
		  maxima-directory 
		  posix-shell
		  clisp-name
		  cmucl-name
		  scl-name
		  acl-name
		  openmcl-name
		  ccl64-name
		  sbcl-name
		  ecl-name
		  gcl-name)
  (let ((prefix (if maxima-directory 
		    maxima-directory
		    (default-directory-string)))
	(win32-string (if is-win32 "true" "false"))
	(shell (if posix-shell posix-shell "/bin/sh"))
	(clisp (if clisp-name clisp-name "clisp"))
	(cmucl (if cmucl-name cmucl-name "lisp"))
	(scl (if scl-name scl-name "lisp"))
	(acl (if acl-name acl-name "acl"))
	(openmcl (if openmcl-name openmcl-name "mcl"))
	(ccl64 (if ccl64-name ccl64-name "ccl64"))
	(sbcl (if sbcl-name sbcl-name "sbcl"))
	(ecl (if ecl-name ecl-name "ecl"))
	(gcl (if gcl-name gcl-name "gcl"))
	(files (list "maxima-local.in" "src/maxima.in" "src/maxima.bat.in"
		     "src/autoconf-variables.lisp.in"))
	(substitutions))
    (if interactive
	(progn
	  (setf prefix (read-with-default "Enter the Maxima directory" prefix))
	  (setf win32-string 
		(read-with-default "Is this a Windows system? (true/false)" 
				   win32-string))
	  (setf shell (read-with-default "Posix shell (optional)" shell))
	  (setf clisp 
		(read-with-default "Name of the Clisp executable (optional)"
				   clisp))
	  (setf cmucl 
		(read-with-default "Name of the CMUCL executable (optional)"
				   cmucl))
	  (setf scl 
		(read-with-default "Name of the SCL executable (optional)"
				   scl))
	  (setf acl 
		(read-with-default "Name of the Allegro executable (optional)"
				   acl))
	  (setf openmcl 
		(read-with-default "Name of the OpenMCL executable (optional)"
				   openmcl))
	  (setf ccl64 
		(read-with-default "Name of the OpenMCL (64-bit) executable (optional)"
				   ccl64))
	  (setf ecl 
		(read-with-default "Name of the ECL executable (optional)"
				   ecl))
	  (setf gcl
		(read-with-default "Name of the GCL executable (optional)"
				   gcl))
	  (setf sbcl 
		(read-with-default "Name of the SBCL executable (optional)"
				   sbcl))))
    (setf substitutions (list (cons "@prefix@" 
				    (replace-substring prefix "\\" "\\\\"))
			      (cons "@PACKAGE@" "maxima")
			      (cons "@VERSION@" (get-version))
			      (cons "@host@" "unknown")
			      (cons "@win32@" win32-string)
			      (cons "@default_layout_autotools@" "false")
			      (cons "@POSIX_SHELL@" shell)
			      (cons "@expanded_top_srcdir@" 
				    (replace-substring prefix "\\" "\\\\"))
			      (cons "@lisp_only_build@" "t")
			      (cons "@DEFAULTLISP@" *maxima-lispname*)
			      (cons "@CLISP_NAME@" clisp)
			      (cons "@CMUCL_NAME@" cmucl)
			      (cons "@SCL_NAME@" scl)
			      (cons "@ACL_NAME@" acl)
			      (cons "@OPENMCL_NAME@" openmcl)
			      (cons "@CCL64_NAME@" ccl64)
			      (cons "@ECL_NAME@" ecl)
			      (cons "@GCL_NAME@" gcl)
			      (cons "@SBCL_NAME@" sbcl)))
    (if verbose
	(mapc #'(lambda (pair) (format t "~a=~a~%" (first pair) (rest pair)))
	      substitutions))
    (mapc #'(lambda (filename)
	      (let ((out-filename (replace-substring filename ".in" "")))
		(process-file filename out-filename substitutions)
		(format t "Created ~a~%" out-filename)))
	  files)))
