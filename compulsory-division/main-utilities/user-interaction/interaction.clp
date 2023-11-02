(deffunction MAIN::print-content (?multifield)
	(foreach ?field ?multifield
		(printout t ?field)
	)
	(println)
)

(deffunction MAIN::get-content (?multifield)
	(if (neq 0 (length$ ?multifield)) then
		(str-cat (expand$ ?multifield))
		else
		""
	)
)

(deffunction MAIN::announce (?player $?message)
	(switch ?player
		(case (symbol-to-instance-name player1) then 
			(bind ?*announce-p1* (insert$ ?*announce-p1* (+ 1 (length$ ?*announce-p1*)) "--> " ?player ": " (implode$ ?message) crlf))
			(return TRUE)
		)
		(case (symbol-to-instance-name player2) then 
			(bind ?*announce-p2* (insert$ ?*announce-p2* (+ 1 (length$ ?*announce-p2*)) "--> " ?player ": " (implode$ ?message) crlf))
			(return TRUE)
		)
		(default FALSE)
	)
)

(deffunction MAIN::choose (?player $?message)
	(switch ?player
		(case (symbol-to-instance-name player1) then 
			(bind ?*choose-p1* (insert$ ?*choose-p1* (+ 1 (length$ ?*choose-p1*)) "--> " ?player ": " (implode$ ?message) crlf))
			(return TRUE)
		)
		(case (symbol-to-instance-name player2) then 
			(bind ?*choose-p2* (insert$ ?*choose-p2* (+ 1 (length$ ?*choose-p2*)) "--> " ?player ": " (implode$ ?message) crlf))
			(return TRUE)
		)
		(default FALSE)
	)
)

(deffunction MAIN::debug ($?message)
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "DEBUG MESSAGE_________________________________" crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "--> TRACE FROM: " (implode$ (get-focus-stack)) crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "--> DEBUG: " (implode$ ?message) crlf))
	(bind ?*debug* (insert$ ?*debug* (+ 1 (length$ ?*debug*)) "----------------------------------------------" crlf crlf))
)