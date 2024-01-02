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
	; Llamar pasando el elemento para desacoplar ese elemento del arbol de posicionamiento
	(do-for-fact ((?rm in)) (and (eq ?rm:transitive FALSE) (eq ?element ?rm:under))
		(retract ?rm)
	)
)

(deffunction MAIN::in-move (?element ?to)
	(in-unchain ?element)
	(assert (in (over ?to) (under ?element)))
	(announce all { "operation" : "move" , "id" : (JSONformat ?element) , "to" : (JSONformat ?to) })
)

; TODO: testear el arbol de posicion en cuanto a eliminar: subarboles eliminados flotantes, etc.
(defrule MAIN::in-exit-game1 (declare (salience ?*universal-rules-salience*) (auto-focus TRUE))
	?in <- (in (transitive FALSE) (over ?exit))
	(or (not (object (name ?exit)))
		(object (name ?exit) (is-a STATABLE) (state HAND | DRAW | DISCARD | MP))
	)
	=>
	(retract ?in)
)

(defrule MAIN::in-exit-game2 (declare (salience ?*universal-rules-salience*) (auto-focus TRUE))
	?in <- (in (transitive FALSE) (under ?exit))
	(or (not (object (name ?exit)))
		(object (name ?exit) (is-a STATABLE) (state HAND | DRAW | DISCARD | MP))
	)
	=>
	(retract ?in)
)


;///////////////////////// DEFMESSAGE-HANDLER

(defmessage-handler LOCATION init after () ; TODO: actualizar cada vez que se modifique
	(foreach ?attackable ?self:automatic-attacks
		(in-move ?attackable (instance-name ?self))
	)
)