(deffunction MAIN::announce (?player $?message)
	(printout t "-->" tab ?player ": " (implode$ ?message) crlf)
)

(deffunction MAIN::obtain (?player $?message)
	(if (< 0 (length$ ?message))
		then
		(announce ?player $?message)
	)
	(printout t "<--" tab ?player ": ")
	(readline)
)