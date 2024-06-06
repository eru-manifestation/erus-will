;/////////////////////// FASE 5 4: CONVOCAR EL CONCILIO LIBRE ///////////////////////
(defmodule P-5-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule mandatory-council
	(player ?player)
	(enemy ?enemy)
	(not (object (is-a CARD) 
		(position ?pos&:(or (eq ?pos (drawsymbol ?player)) (eq ?pos (drawsymbol ?enemy)))))
	)
	=>
	(make-instance (gen-name EP-free-council) of EP-free-council (reason P-5-4::mandatory-council))
	(message "El Concilio de los Pueblos Libres se ejecuta por falta de cartas que robar")
)


(defrule arrange-council#mp (declare (salience ?*a-population*))
	(logical 
		(object (is-a EP-turn) (state EXEC) (player ?p) (council FALSE) (name ?turn))
		(object (is-a PLAYER) (name ?p) (mp ?mp&:(<= 20 ?mp)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Convoque council"))
		(identifier [COUNCIL])
		(data ?turn council TRUE)
		(reason P-5-4::arrange-council#mp)
	))
)


(defrule arrange-council#empty-deck (declare (salience ?*a-population*))
	(logical 
		(object (is-a EP-turn) (state EXEC) (player ?p) (council FALSE) (name ?turn))
		(not (exists 
			(object (is-a CARD) (position ?pos&:(eq ?pos (drawsymbol ?p))))
		))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Convoque council"))
		(identifier [COUNCIL])
		(data ?turn council TRUE)
		(reason P-5-4::arrange-council#empty-deck)
	))
)