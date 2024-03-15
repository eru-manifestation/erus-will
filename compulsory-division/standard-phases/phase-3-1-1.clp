;//////////////////// Fase 3 1 1: EJECUCIÓN MOVER COMPAÑÍAS ///////////////////////
(defmodule P-3-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCIÓN: Ejecutar movimiento declarado por el propio evento
(defrule a-fell-move (declare (salience ?*a-population*))
	(logical
    	(player ?p)
		(object (is-a E-phase) (state EXEC) (reason turn $?))
		?f <- (data (phase turn) (data move ?fell ?to))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(initiator ?f)
		(description (sym-cat "Move fellowship " ?fell " to " ?to))
		(identifier ?fell)
		(data (create$ ?fell position ?to P311::a-fell-move))
		(blocking TRUE)
	))
)

; ACCIÓN: Ejecutar permanencia en el lugar
(defrule a-fell-remain (declare (salience ?*a-population*))
	(logical
    	(player ?p)
		(object (is-a E-phase) (state EXEC) (reason turn $?))
		?f <- (data (phase turn) (data remain ?fell))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def phase)
		(initiator ?f)
		(description (sym-cat "Execute remain of " ?fell))
		(identifier ?fell)
		(data (create$ "fell-move P311::a-fell-remain"
			fellowship ?fell)
		)
		(blocking TRUE)
	))
)