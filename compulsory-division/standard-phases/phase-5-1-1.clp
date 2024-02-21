;/////////////////////// FASE 5 1 1: EJECUCION ELEGIR SI DESCARTAR ///////////////////////
(defmodule P-5-1-1 (import MAIN ?ALL) (import P-4 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(message Ejecucion eleccion si descartar))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



; ACCIÓN: INICIAR FASE MOVIMIENTO
(defrule action-discard-one (declare (salience ?*action-population*))
	(logical
		(only-actions (phase P-5-1-1))
    	(object (is-a PLAYER) (name ?p))
		(object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
		(not (object (is-a E-modify) (reason $? P511::action-discard-one)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Discard card " ?c " from player " ?p "'s hand"))
		(identifier ?c (discardsymbol ?p))
		(data (create$ ?c position (discardsymbol ?p)
			DISCARD FROM-HAND P511::action-discard-one))
	))
)
