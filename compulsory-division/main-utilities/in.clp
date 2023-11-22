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

(deffunction MAIN::in-unchain (?element)
	; Desencadena el elemento de cualquier elemento superior
	; Elimina el primer elemento in no transitivo que defina lo que tenga arriba ?c
	; (solo debería haber uno)
	(do-for-fact ((?rm in)) (and (eq ?rm:transitive FALSE) (eq ?element ?rm:under))
		(retract ?rm)
	)
)

(deffunction MAIN::in-move (?element ?to)
	(in-unchain ?element)
	(assert (in (over ?to) (under ?element)))
)


(defrule MAIN::in-exit-game1 (declare (salience ?*universal-rules-salience*) (auto-focus TRUE))
	(object (is-a STATABLE) (state HAND | DRAW | DISCARD | MP) (name ?exit))
	?in <- (in (transitive FALSE) (over ?exit))
	=>
	(retract ?in)
)

(defrule MAIN::in-exit-game2 (declare (salience ?*universal-rules-salience*) (auto-focus TRUE))
	(object (is-a STATABLE) (state HAND | DRAW | DISCARD | MP) (name ?exit))
	?in <- (in (transitive FALSE) (under ?exit))
	=>
	(retract ?in)
)


;///////////////////////// DEFMESSAGE-HANDLER

(defmessage-handler LOCATION init after ()
	(foreach ?attackable ?self:automatic-attacks
		(in-move ?attackable (instance-name ?self))
	)
)

(defmessage-handler USER delete before()
	(do-for-all-facts ((?in in)) (or (eq ?in:over (instance-name ?self)) (eq ?in:under (instance-name ?self)))
		(retract ?in)
	)
)