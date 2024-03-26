;/////////////////////// FASE 5 1 1: EJECUCION ELEGIR SI DESCARTAR ///////////////////////
(defmodule P-5-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



; ACCIÓN: INICIAR FASE MOVIMIENTO
(defrule a-discard-one (declare (salience ?*a-population*))
	(logical
		(object (is-a EP-turn) (state EXEC))
    	(object (is-a PLAYER) (name ?p))
		(object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
		(not (object (is-a E-modify) (reason P-5-1-1::a-discard-one)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def discard)
		(description (sym-cat "Discard card " ?c " from player " ?p "'s hand"))
		(identifier ?c (discardsymbol ?p))
		(data ?c)
		(reason P-5-1-1::a-discard-one)
	))
)
