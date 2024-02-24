;//////////////////// Fase 3 1 1: EJECUCIÓN MOVER COMPAÑÍAS ///////////////////////
(defmodule P-3-1-1 (import MAIN ?ALL) (import P-2-3-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCIÓN: Ejecutar movimiento declarado por el propio evento
(defrule action-fell-move (declare (salience ?*action-population*))
	(logical
    	(player ?p)
		(object (is-a E-phase) (state EXEC) (reason turn $?))
		?f <- (data (data move ?fell ?to))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(initiator ?f)
		(description (sym-cat "Move fellowship " ?fell " to " ?to))
		(identifier ?fell)
		(data (create$ ?fell position ?to P311::action-fell-move))
		(blocking TRUE)
	))
)

; ACCIÓN: Ejecutar permanencia en el lugar
(defrule action-fell-remain (declare (salience ?*action-population*))
	(logical
    	(player ?p)
		(object (is-a E-phase) (state EXEC) (reason turn $?))
		?f <- (data (data remain ?fell))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def phase)
		(initiator ?f)
		(description (sym-cat "Execute remain of " ?fell))
		(identifier ?fell)
		(data (create$ "fell-move P311::action-fell-remain"
			(str-cat "fellowship [" ?fell "]")
		))
		(blocking TRUE)
	))
)