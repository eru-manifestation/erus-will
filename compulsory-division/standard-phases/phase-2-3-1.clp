;////////////////// Fase 2 3 1: EJECUCION DESCARTAR ADVERSIDADES SUCESOS DURADEROS ////////////////////////
(defmodule P-2-3-1 (import MAIN ?ALL) (import P-2-2-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(message Descartar adversidades suceso duradero))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

; EVENTO: DESCARTAR ADVERSIDADES DE SUCESO DURADERO
(defrule long-event-adversity-discard
    (enemy ?p)
	; Dado una adversidad suceso duradero del contrincante
	(object (is-a A-LONG-EVENT) (name ?le) (player ?p)
		(state TAPPED | UNTAPPED))
	=>
	(E-modify ?le position (discardsymbol ?p) DISCARD A-LONG-EVENT P231::long-event-adversity-discard)
)