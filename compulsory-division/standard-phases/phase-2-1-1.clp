;////////////////// Fase 2 1 1: EJECUCION DESCARTAR RECURSOS SUCESOS DURADEROS ////////////////////////
(defmodule P-2-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Descartar recursos de suceso duradero))

; EVENTO: DESCARTAR RECURSOS DE SUCESO DURADERO
(defrule long-event-discard
	; Dado un rec suceso duradero tuyo
	(object (is-a R-LONG-EVENT) (name ?le) 
		(state TAPPED | UNTAPPED) (player ?p))
	=>
	(make-instance (gen-name E-r-long-event-discard) of E-r-long-event-discard 
		(r-long-event ?le))
)