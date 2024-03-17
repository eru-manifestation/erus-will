;/////////////////////// FASE 4: FASE DE LUGARES ///////////////////////
(defmodule P-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



; ACCIÓN: INICIAR FASE LUGARES
(defrule a-loc-phase (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)

		(object (is-a FELLOWSHIP) (empty FALSE) (player ?p) (name ?fell))
		(not (object (is-a E-phase) (reason loc-phase $?) (data $? fellowship ?fell $?)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def phase)
		(description (sym-cat "Begin location phase for " ?fell))
		(identifier ?fell)
		(data (create$ fellowship ?fell))
		(reason loc-phase P4::a-loc-phase)
		(blocking TRUE)
	))
)
