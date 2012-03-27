(use posix)

(define (mplayer-load path)
  (let-values
      (((in out pid)
	(process (string-append "mplayer -slave -identify -noquiet -input file=cmds " path))))
    (port-for-each (lambda (v)
		     (if (string=? v "ID_EXIT=QUIT")
			 (process-wait pid)
			 #f))
		   (lambda ()
		     (read-line in)))))