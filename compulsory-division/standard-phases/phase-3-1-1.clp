;//////////////////// Fase 3 1 1: EJECUCIÓN MOVER COMPAÑÍAS ///////////////////////
(defmodule P-3-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Eleccion de la ejecucion del movimiento))

; EVENT HANDLER: FELLOWSHIP-gen-move (es un salto)
(defrule move-fellowship (declare (salience ?*jump-salience*))
	(object (is-a EVENT) (type IN) (event-definitor FELLOWSHIP-EP-move)
		(name ?e))
	=>
	;(jump 3 1 1 move-fellowship (send ?e get-data fell) (send ?e get-data from) 0)
	;(send ?e complete)
)