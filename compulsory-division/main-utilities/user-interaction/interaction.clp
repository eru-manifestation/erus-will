(deffunction MAIN::print-content (?multifield)
	(foreach ?field ?multifield
		(printout t ?field)
	)
	(println)
)

(deffunction MAIN::announce (?player $?message)
	(bind ?*announce* (insert$ ?*announce* (+ 1 (length$ ?*announce*)) "--> " ?player ": " (implode$ ?message) crlf))
)

(deffunction MAIN::choose (?player $?message)
	(bind ?*choose* (insert$ ?*choose* (+ 1 (length$ ?*choose*)) "--> " ?player ": " (implode$ ?message) crlf))
)

(deffunction MAIN::debug ($?message)
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "DEBUG MESSAGE_________________________________" crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "--> TRACE FROM: " (implode$ (get-focus-stack)) crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "--> DEBUG: " (implode$ ?message) crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "----------------------------------------------" crlf crlf))
)