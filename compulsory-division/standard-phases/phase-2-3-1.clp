;////////////////// Fase 2 3 1: EJECUCION DESCARTAR ADVERSIDADES SUCESOS DURADEROS ////////////////////////
(defmodule P-2-3-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Descartar adversidades suceso duradero))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))

; EVENTO: DESCARTAR ADVERSIDADES DE SUCESO DURADERO
(defrule long-event-adversity-discard
	; Dado una adversidad suceso duradero del contrincante
	(object (is-a A-LONG-EVENT) (name ?le) (player ?p&:(eq ?p ?*enemy*))
		(state TAPPED | UNTAPPED))
	=>
	(make-instance (gen-name E-a-long-event-discard) of E-a-long-event-discard
		(a-long-event ?le))
)