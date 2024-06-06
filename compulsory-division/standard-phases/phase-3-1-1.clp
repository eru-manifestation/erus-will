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
		(object (is-a EP-turn) (state EXEC) (player ?p) (move $? ?fell ?to $?))
		(object (is-a FELLOWSHIP) (name ?fell))
		(not (object (is-a EVENT) (target ?fell) (new ?to) (reason P-3-1-1::a-fell-move)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Move fellowship " ?fell " to " ?to))
		(identifier ?fell)
		(data ?fell position ?to)
		(reason P-3-1-1::a-fell-move)
		(blocking TRUE)
	))
)

; ACCIÓN: Ejecutar permanencia en el lugar
(defrule a-fell-remain (declare (salience ?*a-population*))
	(logical
		(object (is-a EP-turn) (state EXEC) (player ?p) (remain $? ?fell $?))
		(not (object (is-a EP-fell-move) (fellowship ?fell) (reason P-3-1-1::a-fell-remain)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def fell-move)
		(description (sym-cat "Execute remain of " ?fell))
		(identifier ?fell)
		(data "(fellowship [" ?fell "])")
		(reason P-3-1-1::a-fell-remain)
		(blocking TRUE)
	))
)