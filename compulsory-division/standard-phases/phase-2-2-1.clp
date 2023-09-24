;////////////////// Fase 2 2 1: EJECUCION JUGAR RECURSOS SUCESOS DURADEROS ////////////////////////
(defmodule P-2-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Jugar recursos suceso duradero))

; ACCIÓN: JUGAR RECURSOS DE SUCESOS DURADEROS
(defrule action-long-event-play (declare (salience ?*action-population-salience*))
	(logical
		; Dado un suceso duradero en la mano del jugador
		(object (is-a R-LONG-EVENT) (name ?rle) (player [player1])
			(state HAND))
	)
	=>
	(gen-action [player1] r-long-event-play
		"(" r-long-event ?rle ")")
)
