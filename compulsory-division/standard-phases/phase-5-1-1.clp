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
		(object (is-a E-phase) (state EXEC) (reason turn $?))
    	(object (is-a PLAYER) (name ?p))
		(object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
		(not (object (is-a E-modify) (reason $? P511::a-discard-one)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Discard card " ?c " from player " ?p "'s hand"))
		(identifier ?c (discardsymbol ?p))
		(data (create$ ?c position (discardsymbol ?p)))
		(reason DISCARD FROM-HAND P511::a-discard-one)
	))
)
