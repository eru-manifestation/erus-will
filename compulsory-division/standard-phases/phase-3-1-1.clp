;//////////////////// Fase 3 1 1: EJECUCIÓN MOVER COMPAÑÍAS ///////////////////////
(defmodule P-3-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Eleccion de la ejecucion del movimiento))

; EVENT HANDLER: FELLOWSHIP-gen-move (es un salto)
(defrule E-fell-decl-move (declare (salience ?*event-handler-salience*))
	?e <- (object (is-a E-fell-decl-move) (type IN)
		(fell ?fell) (from ?from) (to ?to))
	=>
	; TODO: encontrar forma de llevar los datos (dejar vivo el evento??)
	;(jump 3 1 1 move-fellowship (send ?e get-data fell) (send ?e get-data from) 0)
	(send ?e complete)
	(jump EP-1)

	(debug Declaring movement of ?fell from ?from to ?to)
)