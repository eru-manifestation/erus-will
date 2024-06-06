;////////////////// Fase 2 2 1: EJECUCION JUGAR RECURSOS SUCESOS DURADEROS ////////////////////////
(defmodule P-2-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

; ACCIÓN: JUGAR RECURSOS DE SUCESOS DURADEROS
(defrule a-long-event-play (declare (salience ?*a-population*))
	(logical
		(object (is-a EP-turn) (state EXEC) (player ?p))
		; Dado un suceso duradero en la mano del jugador
		(object (is-a R-LONG-EVENT) (name ?rle) (player ?p)
			(position ?pos&:(eq ?pos (handsymbol ?p))))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def play)
		(description (sym-cat "Play long event resource " ?rle))
		(identifier ?rle)
		(data ?rle (slot-default-value BASIC position))
		(reason P-2-2-1::a-long-event-play)
	))
)
