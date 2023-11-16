(deffunction MAIN::announce (?player $?message)
	(printout t "-->" tab ?player ": " (implode$ ?message) crlf)
)

(deffunction MAIN::debug ($?message)
	(printout ?*debug-info* crlf "DEBUG MESSAGE_________________________________" crlf)
	(printout ?*debug-traces* "-->" tab "TRACE FROM:" tab (get-focus-stack) crlf)
	(printout ?*debug-info* "-->" tab "DEBUG:" tab (implode$ ?message) crlf)
	(printout ?*debug-info* "----------------------------------------------" crlf crlf)
)

(deffunction MAIN::obtain (?player $?message)
	(if (< 0 (length$ ?message))
		then
		(announce ?player $?message)
	)
	(printout t "<--" tab ?player ": ")
	(readline)
)

(deffunction MAIN::obtain-number (?player $?message)
	(if (< 0 (length$ ?message))
		then
		(announce ?player $?message)
	)
	(printout t "<--" tab ?player ": ")
	(read-number)
)