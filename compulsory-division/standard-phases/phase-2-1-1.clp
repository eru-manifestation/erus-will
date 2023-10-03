;////////////////// Fase 2 1 1: EJECUCION DESCARTAR RECURSOS SUCESOS DURADEROS ////////////////////////
(defmodule P-2-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INIT
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Descartar recursos de suceso duradero))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))

; EVENTO: DESCARTAR RECURSOS DE SUCESO DURADERO
(defrule long-event-discard
	; Dado un rec suceso duradero tuyo
	(object (is-a R-LONG-EVENT) (name ?le) 
		(state TAPPED | UNTAPPED) (player ?p&:(eq ?p ?*player*)))
	=>
	(make-instance (gen-name E-r-long-event-discard) of E-r-long-event-discard 
		(r-long-event ?le))
)