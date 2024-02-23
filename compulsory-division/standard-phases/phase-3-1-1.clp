;//////////////////// Fase 3 1 1: EJECUCIÓN MOVER COMPAÑÍAS ///////////////////////
(defmodule P-3-1-1 (import MAIN ?ALL) (import P-2-3-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(message Eleccion de la ejecucion del movimiento))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCIÓN: Ejecutar movimiento declarado por el propio evento
(defrule action-fell-move (declare (salience ?*action-population*))
	(logical
		; (only-actions (phase P-3-1-1))
    	(player ?p)
		(object (is-a E-phase) (state EXEC) (reason turno $?))
		(data (data move ?fell ?to))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Move fellowship " ?fell " from to " ?to))
		(identifier ?fell)
		(data (create$ ?fell position ?to P311::action-fell-move))
		(blocking TRUE)
	))
)

; ACCIÓN: Ejecutar permanencia en el lugar
(defrule action-fell-remain (declare (salience ?*action-population*))
	(logical
		; (only-actions (phase P-3-1-1))
    	(player ?p)
		(object (is-a E-phase) (state EXEC) (reason turno $?))
		(data (data remain ?fell))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def phase)
		(description (sym-cat "Execute remain of " ?fell))
		(identifier ?fell)
		(data (create$ "fell-move P311::action-fell-remain"
			(str-cat "fellowship [" ?fell "]")
		))
		(blocking TRUE)
	))
)