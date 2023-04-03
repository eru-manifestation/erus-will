(deftemplate in
	; Representa que un elemento de juego esté bajo otro
	(slot over (type INSTANCE-NAME) (default ?NONE))
	(slot under (type INSTANCE-NAME) (default ?NONE))
	(slot transitive (type SYMBOL) (default FALSE) 
		(allowed-symbols TRUE FALSE))
)


(defrule in-transitive (declare (salience ?*universal-rules-salience*))
	(logical (in (over ?a) (under ?b)))
	(logical (in (over ?b) (under ?c)))
	=>
	(assert (in (over ?a) (under ?c) (transitive TRUE)))
)