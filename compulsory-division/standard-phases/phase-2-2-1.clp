;////////////////// Fase 2 2 1: EJECUCION JUGAR RECURSOS SUCESOS DURADEROS ////////////////////////
(defmodule P-2-2-1 (import MAIN ?ALL) (import P-2-1-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

; ACCIÓN: JUGAR RECURSOS DE SUCESOS DURADEROS
(defrule action-long-event-play (declare (salience ?*action-population*))
	(logical
		(object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)
		; Dado un suceso duradero en la mano del jugador
		(object (is-a R-LONG-EVENT) (name ?rle) (player ?p)
			(position ?pos&:(eq ?pos (handsymbol ?p))))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play long event resource " ?rle))
		(identifier ?rle)
		(data (create$ ?rle position (slot-default-value BASIC position)
			PLAY R-LONG-EVENT P221::action-long-event-play
		))
	))
)
