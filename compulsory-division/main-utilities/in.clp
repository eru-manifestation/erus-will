(deftemplate MAIN::in
	; Representa que un elemento de juego esté bajo otro
	(slot over (type INSTANCE-NAME) (default ?NONE))
	(slot under (type INSTANCE-NAME) (default ?NONE))
	(slot transitive (type SYMBOL) (default FALSE) 
		(allowed-symbols TRUE FALSE))
)


(defrule MAIN::in-transitive (declare (salience ?*universal-rules*) (auto-focus TRUE))
	(logical 
		(in (transitive FALSE) (over ?a) (under ?b))
		(in (over ?b) (under ?c))
	)
	=>
	(assert (in (over ?a) (under ?c) (transitive TRUE)))
)

(deffunction MAIN::in-unchain (?element)
	; Llamar pasando el elemento para desacoplar ese elemento del arbol de posicionamiento
	(do-for-fact ((?rm in)) (and (eq ?rm:transitive FALSE) (eq ?element ?rm:under))
		(retract ?rm)
	)
)

;TODO: CAMBIAR EL NOMBRE PARA IGUALARLO A LAS DEMAS CARACTERÍSTICAS
(defmessage-handler BASIC put-position after (?to)
	(if (neq ?to (slot-default-value BASIC position)) then
		(bind ?element (instance-name ?self))
		(in-unchain ?element)
		(assert (in (over ?to) (under ?element)))
		(announce all { "operation" : "move" , "id" : (JSONformat ?element) , "to" : (JSONformat ?to) })
	)
)

; TODO: testear el arbol de posicion en cuanto a eliminar: subarboles eliminados flotantes, etc.
(defrule MAIN::in-exit-game (declare (salience ?*universal-rules*) (auto-focus TRUE))
	?in <- (in (transitive FALSE) (over ?over) (under ?under))
	(not (and (object (name ?over)) (object (name ?under))))
	=>
	(retract ?in)
)


;TODO: regla para que las cartas que estén en un STACK no puedan tener relación de localización entre sí mismas???

;///////////////////////// DEFMESSAGE-HANDLER

(defmessage-handler LOCATION init after ()
	; TODO: hacer que el attackable tenga al definirlo el position de su localizacion, y que position se rellene automaticamente con un data item que detecte que su slot es multislot y añada y quite en vez de decrementar e incrementar
	(foreach ?attackable ?self:automatic-attacks
		(send ?attackable put-position (instance-name ?self))
	)
)