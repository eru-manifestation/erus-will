(deffunction MAIN::print-content (?multifield)
	(foreach ?field ?multifield
		(printout t ?field)
	)
	(println)
)

(deffunction MAIN::get-debug ()
	(if (neq 0 (length$ ?*debug*)) then
		(bind ?res (str-cat (expand$ ?*debug*)))
		(bind ?*debug* (create$))
		?res
		else
		""
	)
)

(deffunction MAIN::get-state-p1 ()
	(if (neq 0 (length$ ?*state-p1*)) then
		(bind ?res (str-cat (expand$ ?*state-p1*)))
		(bind ?*state-p1* (create$))
		?res
		else
		""
	)
)

(deffunction MAIN::get-state-p2 ()
	(if (neq 0 (length$ ?*state-p2*)) then
		(bind ?res (str-cat (expand$ ?*state-p2*)))
		(bind ?*state-p2* (create$))
		?res
		else
		""
	)
)

(deffunction MAIN::get-announce-p1 ()
	(if (neq 0 (length$ ?*announce-p1*)) then
		(bind ?res (str-cat (expand$ ?*announce-p1*)))
		(bind ?*announce-p1* (create$))
		?res
		else
		""
	)
)

(deffunction MAIN::get-announce-p2 ()
	(if (neq 0 (length$ ?*announce-p2*)) then
		(bind ?res (str-cat (expand$ ?*announce-p2*)))
		(bind ?*announce-p2* (create$))
		?res
		else
		""
	)
)

(deffunction MAIN::get-choose-p1 ()
	(if (neq 0 (length$ ?*choose-p1*)) then
		(bind ?res (str-cat (expand$ ?*choose-p1*)))
		(bind ?*choose-p1* (create$))
		?res
		else
		""
	)
)

(deffunction MAIN::get-choose-p2 ()
	(if (neq 0 (length$ ?*choose-p2*)) then
		(bind ?res (str-cat (expand$ ?*choose-p2*)))
		(bind ?*choose-p2* (create$))
		?res
		else
		""
	)
)

(deffunction MAIN::announce (?player $?message)
	(switch ?player
		(case (symbol-to-instance-name player1) then 
			(bind ?*announce-p1* (insert$ ?*announce-p1* (+ 1 (length$ ?*announce-p1*)) (implode$ ?message) crlf))
			(return TRUE)
		)
		(case (symbol-to-instance-name player2) then 
			(bind ?*announce-p2* (insert$ ?*announce-p2* (+ 1 (length$ ?*announce-p2*)) (implode$ ?message) crlf))
			(return TRUE)
		)
		(case all then
			(bind ?*announce-p1* (insert$ ?*announce-p1* (+ 1 (length$ ?*announce-p1*)) (implode$ ?message) crlf))
			(bind ?*announce-p2* (insert$ ?*announce-p2* (+ 1 (length$ ?*announce-p2*)) (implode$ ?message) crlf))
			(return TRUE)
		)
		(default FALSE)
	)
)

(deffunction MAIN::choose (?player $?message)
	(switch ?player
		(case (symbol-to-instance-name player1) then 
			(bind ?*choose-p1* (insert$ ?*choose-p1* (+ 1 (length$ ?*choose-p1*)) (implode$ ?message) crlf))
			(return TRUE)
		)
		(case (symbol-to-instance-name player2) then 
			(bind ?*choose-p2* (insert$ ?*choose-p2* (+ 1 (length$ ?*choose-p2*)) (implode$ ?message) crlf))
			(return TRUE)
		)
		(default FALSE)
	)
)

(deffunction MAIN::state (?player $?message)
	(switch ?player
		(case (symbol-to-instance-name player1) then 
			(bind ?*state-p1* (insert$ ?*state-p1* (+ 1 (length$ ?*state-p1*)) $?message))
			(return TRUE)
		)
		(case (symbol-to-instance-name player2) then 
			(bind ?*state-p2* (insert$ ?*state-p2* (+ 1 (length$ ?*state-p2*)) $?message))
			(return TRUE)
		)
		(case all then
			(bind ?*state-p1* (insert$ ?*state-p1* (+ 1 (length$ ?*state-p1*)) $?message))
			(bind ?*state-p2* (insert$ ?*state-p2* (+ 1 (length$ ?*state-p2*)) $?message))
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