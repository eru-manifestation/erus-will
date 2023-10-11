;/////////////////////// FASE 5 1 1: EJECUCION ELEGIR SI DESCARTAR ///////////////////////
(defmodule P-5-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Ejecucion eleccion si descartar))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



; ACCIÓN: INICIAR FASE MOVIMIENTO
(defrule action-discard-one (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-5-1-1))
    	(player ?p)
		(object (is-a CARD) (player ?p) (state HAND) (name ?c))
		(not (object (is-a E-player-discard-from-hand)));TODO ES INESTABLE
	)
	=>
	(assert (action 
		(player ?p)
		(event-def player-discard-from-hand)
		(description (sym-cat "Discard card " ?c " from player " ?p "'s hand"))
		(data (create$ 
		"( card [" ?c "])" 
		"( player [" ?p "])"))
	))
)
