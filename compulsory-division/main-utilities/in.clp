(deftemplate MAIN::in
	; Representa que un elemento de juego esté bajo otro
	(slot over (type INSTANCE-NAME) (default ?NONE))
	(slot under (type INSTANCE-NAME) (default ?NONE))
)

(defrule MAIN::in (declare (salience ?*universal-rules*) (auto-focus TRUE))
	(logical
		(object (is-a BASIC) (name ?under) (position ?over))
		(object (is-a BASIC) (name ?over))
	)
	=>
	(assert (in (over ?over) (under ?under)))
)

(defrule MAIN::in-transitive (declare (salience ?*universal-rules*) (auto-focus TRUE))
	(logical 
		(in (over ?a) (under ?b))
		(in (over ?b) (under ?c))
	)
	=>
	(assert (in (over ?a) (under ?c)))
)

;TODO: CAMBIAR EL NOMBRE PARA IGUALARLO A LAS DEMAS CARACTERÍSTICAS
(defmessage-handler BASIC put-position after (?to)
	(announce all { "operation" : "move" , "id" : (JSONformat (instance-name ?self)) , "to" : (JSONformat ?to) })
)


;TODO: regla para que las cartas que estén en un STACK no puedan tener relación de localización entre sí mismas???

;///////////////////////// DEFMESSAGE-HANDLER

(defmessage-handler LOCATION init after ()
	; TODO: hacer que el attackable tenga al definirlo el position de su localizacion, y que position se rellene automaticamente con un data item que detecte que su slot es multislot y añada y quite en vez de decrementar e incrementar
	(foreach ?attackable ?self:automatic-attacks
		(send ?attackable put-position (instance-name ?self))
	)
)