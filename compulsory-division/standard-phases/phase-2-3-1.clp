;////////////////// Fase 2 3 1: EJECUCION DESCARTAR ADVERSIDADES SUCESOS DURADEROS ////////////////////////
(defmodule P-2-3-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Descartar adversidades suceso duradero))

; EVENTO: DESCARTAR ADVERSIDADES DE SUCESO DURADERO
(defrule long-event-adversity-discard
	; Dado una adversidad suceso duradero del contrincante
	(object (is-a A-LONG-EVENT) (name ?le) (player [player2])
		(state TAPPED | UNTAPPED))
	=>
	(make-instance (gen-name E-a-long-event-discard) of E-a-long-event-discard
		(a-long-event ?le))
)