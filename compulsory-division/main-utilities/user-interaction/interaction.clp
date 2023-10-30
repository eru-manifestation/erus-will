(deffunction MAIN::print-content (?multifield)
	(foreach ?field ?multifield
		(printout t ?field)
	)
	(println)
)

(deffunction MAIN::announce (?player $?message)
	(bind ?*announce* (insert$ ?*announce* (+ 1 (length$ ?*announce*)) "--> " ?player ": " (implode$ ?message) crlf))
)

(deffunction MAIN::debug ($?message)
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "DEBUG MESSAGE_________________________________" crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "--> TRACE FROM: " (implode$ (get-focus-stack)) crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "--> DEBUG: " (implode$ ?message) crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "----------------------------------------------" crlf crlf))
)

; (deffunction MAIN::obtain (?player $?message)
; 	(if (< 0 (length$ ?message))
; 		then
; 		(announce ?player $?message)
; 	)
; 	(printout t "<--" tab ?player ": ")
; 	(readline)
; )

(deffunction MAIN::obtain-number (?player $?message)
	(if (< 0 (length$ ?message))
		then
		(announce ?player $?message)
	)
	(bind ?*obtain* (str-cat ?*obtain* "<--" ?player crlf))
	(halt)
	;(read-number)
)