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
	;TODO: se debe comprobar que este suceso duradero esté en juego
	(object (is-a R-LONG-EVENT) (name ?le) (player ?p))
	=>
	;(gen-event R-LONG-EVENT-discard 
	;	target ?le)
)