;////////////////// Fase 2 1 1: EJECUCION DESCARTAR RECURSOS SUCESOS DURADEROS ////////////////////////
(defmodule P-2-1-1 (import MAIN ?ALL) (import P-1-1-2-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

; EVENTO: DESCARTAR RECURSOS DE SUCESO DURADERO
(defrule long-event-discard
    (player ?p)
	; Dado un rec suceso duradero tuyo
	(object (is-a R-LONG-EVENT) (name ?le) 
		(state TAPPED | UNTAPPED) (player ?p))
	=>
	(E-modify ?le position (discardsymbol ?p) DISCARD R-LONG-EVENT P211::long-event-discard)
)