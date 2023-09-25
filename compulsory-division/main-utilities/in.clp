(deftemplate MAIN::in
	; Representa que un elemento de juego esté bajo otro
	(slot over (type INSTANCE-NAME) (default ?NONE))
	(slot under (type INSTANCE-NAME) (default ?NONE))
	(slot transitive (type SYMBOL) (default FALSE) 
		(allowed-symbols TRUE FALSE))
)


(defrule MAIN::in-transitive (declare (salience ?*universal-rules-salience*) (auto-focus TRUE))
	(logical (in (transitive FALSE) (over ?a) (under ?b)))
	(logical (in (over ?b) (under ?c)))
	=>
	(assert (in (over ?a) (under ?c) (transitive TRUE)))
)

(deffunction MAIN::in-move (?element ?to)
	; Elimina el primer elemento in no transitivo que defina lo que tenga arriba ?c
	; (solo debería haber uno)
	(do-for-fact ((?rm in)) (and (eq ?rm:transitive FALSE) (eq ?element ?rm:under))
		(retract ?rm)
	)
	(assert (in (over ?to) (under ?element)))
)