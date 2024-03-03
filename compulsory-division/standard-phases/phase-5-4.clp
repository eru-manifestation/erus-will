;/////////////////////// FASE 5 4: CONVOCAR EL CONCILIO LIBRE ///////////////////////
(defmodule P-5-4 (import MAIN ?ALL) (import P-5-3 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule mandatory-council
	(player ?player)
	(enemy ?enemy)
	(not (object (is-a CARD) 
		(position ?pos&:(or (eq ?pos (drawsymbol ?player)) (eq ?pos (drawsymbol ?enemy)))))
	)
	=>
	(make-instance (gen-name E-phase) of E-phase (reason free-council P54::mandatory-council))
	(message "El Concilio de los Pueblos Libres se ejecuta por falta de cartas que robar")
)


(defrule arrange-council#mp (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)
		(object (is-a PLAYER) (name ?p) (mp ?mp&:(<= 20 ?mp)))
	)
	=>
	;	TODO: pasar el hecho a MAIN, para que se pueda reintroducir en el sig turno
	(assert (action 
		(player ?p)
		(event-def variable)
		(description (sym-cat "Convoque council"))
		(identifier [COUNCIL])
		(data council)
	))
)


(defrule arrange-council#empty-deck (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)
		(not (exists 
			(object (is-a CARD) (position ?pos&:(eq ?pos (drawsymbol ?p))))
		))
	)
	=>
	;	TODO: pasar el hecho a MAIN, para que se pueda reintroducir en el sig turno
	(assert (action 
		(player ?p)
		(event-def variable)
		(description (sym-cat "Convoque council"))
		(identifier [COUNCIL])
		(data council)
	))
)