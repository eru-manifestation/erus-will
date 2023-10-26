(deffunction MAIN::announce (?player $?message)
	(bind ?*announce* (str-cat ?*announce* "-->\\t" ?player ": " (implode$ ?message) "\\n" crlf))
)

(deffunction MAIN::debug ($?message)
	(bind ?*debug* (str-cat ?*debug* "DEBUG MESSAGE_________________________________\\n"))
	(bind ?*debug* (str-cat ?*debug* "-->\\tTRACE FROM:\\t" (implode$ (get-focus-stack)) "\\n"))
	(bind ?*debug* (str-cat ?*debug* "-->\\tDEBUG:\\t" (implode$ ?message) "\\n"))
	(bind ?*debug* (str-cat ?*debug* "----------------------------------------------\\n\\n"))
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
	(bind ?*obtain* (str-cat ?*obtain* "<--\\t" ?player "\\n"))
	(halt)
	;(read-number)
)