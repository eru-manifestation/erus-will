(defglobal MAIN
    ?*announce-p1* = (create$)
    ?*announce-p2* = (create$)
    ?*message* = (create$)
    ?*choose-p1* = (create$)
    ?*choose-p2* = (create$)

    ?*state-p1* = (create$)
    ?*state-p2* = (create$)
)


(deffunction MAIN::print-content (?multifield)
	(foreach ?field ?multifield
		(printout t ?field)
	)
	(println)
)

(deffunction MAIN::get-debug ()
	(if (neq 0 (length$ ?*message*)) then
		(bind ?res (str-cat (expand$ ?*message*)))
		(bind ?*message* (create$))
		?res
		else
		""
	)
)

(deffunction MAIN::get-announce-p1 ()
	(bind ?res (str-cat "[ " (expand$ ?*announce-p1*) " null ]"))
	(bind ?*announce-p1* (create$))
	?res
)

(deffunction MAIN::get-announce-p2 ()
	(bind ?res (str-cat "[ " (expand$ ?*announce-p2*) " null ]"))
	(bind ?*announce-p2* (create$))
	?res
)

(deffunction MAIN::get-choose-p1 ()
	(bind ?res (str-cat "[ " (expand$ ?*choose-p1*) " null ]"))
	(bind ?*choose-p1* (create$))
	?res
)

(deffunction MAIN::get-choose-p2 ()
	(bind ?res (str-cat "[ " (expand$ ?*choose-p2*) " null ]"))
	(bind ?*choose-p2* (create$))
	?res
)

(deffunction MAIN::announce (?player $?message)
	(switch ?player
		(case (symbol-to-instance-name player1) then 
			(bind ?*announce-p1* (insert$ ?*announce-p1* (+ 1 (length$ ?*announce-p1*)) (implode$ ?message) , crlf))
			(return TRUE)
		)
		(case (symbol-to-instance-name player2) then 
			(bind ?*announce-p2* (insert$ ?*announce-p2* (+ 1 (length$ ?*announce-p2*)) (implode$ ?message) , crlf))
			(return TRUE)
		)
		(case all then
			(bind ?*announce-p1* (insert$ ?*announce-p1* (+ 1 (length$ ?*announce-p1*)) (implode$ ?message) , crlf))
			(bind ?*announce-p2* (insert$ ?*announce-p2* (+ 1 (length$ ?*announce-p2*)) (implode$ ?message) , crlf))
			(return TRUE)
		)
		(default FALSE)
	)
)

(deffunction MAIN::choose (?player $?message)
	(switch ?player
		(case (symbol-to-instance-name player1) then 
			(bind ?*choose-p1* (insert$ ?*choose-p1* (+ 1 (length$ ?*choose-p1*)) (implode$ ?message) , crlf))
			(return TRUE)
		)
		(case (symbol-to-instance-name player2) then 
			(bind ?*choose-p2* (insert$ ?*choose-p2* (+ 1 (length$ ?*choose-p2*)) (implode$ ?message) , crlf))
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

(deffunction MAIN::message ($?message)
	(bind ?insert (create$ crlf
		"DEBUG MESSAGE_________________________________" crlf
		"--> TRACE FROM: " (implode$ (get-focus-stack)) crlf
		"--> DEBUG: " (implode$ ?message) crlf
		"----------------------------------------------" crlf crlf
	))
	(if ?*print-message* then (print-content ?insert))
	(bind ?*message* (insert$ ?*message* (+ 1 (length$ ?*message*)) ?insert))
	TRUE
)