(use posix)

(define (mplayer-command command)
  (process-wait (process-run (++ "echo \"" command "\" > ~/.mplayer-out"))))

(define (mplayer-load path)
  (let-values
      (((in out pid)
	(process (string-append "mplayer -slave -identify -noquiet -input file=~/.mplayer-out \"" path "\""))))
    (thread-start!
     (make-thread
      (lambda ()
	(port-for-each (lambda (v)
			 (if (string=? v "ID_EXIT=QUIT")
			     (process-wait pid)
			     #f))
		       (lambda ()
			 (read-line in))))))))

(define (mplayer-stop)
  (mplayer-command "quit"))
(define (mplayer-pause)
  (mplayer-command "pause"))