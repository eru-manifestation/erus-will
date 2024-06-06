;////////////////// Fase 2 1 1: EJECUCION DESCARTAR RECURSOS SUCESOS DURADEROS ////////////////////////
(defmodule P-2-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

; EVENTO: DESCARTAR RECURSOS DE SUCESO DURADERO
(defrule long-event-discard
    (player ?p)
	; Dado un rec suceso duradero tuyo
	(object (is-a R-LONG-EVENT) (name ?le) (player ?p) 
		(position ?pos))
	(not (object (is-a STACK) (name ?pos)))
	=>
	(E-discard ?le P-2-1-1::long-event-discard)
)