;//////////////////// Fase 3 1 1: EJECUCIÓN MOVER COMPAÑÍAS ///////////////////////
(defmodule P-3-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Eleccion de la ejecucion del movimiento))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))

; EVENT HANDLER: FELLOWSHIP-gen-move (es un salto)
(defrule E-fell-decl-move (declare (salience ?*event-handler-salience*))
	?e <- (object (is-a E-fell-decl-move) (type IN)
		(fell ?fell) (from ?from) (to ?to))
	=>
	; TODO: encontrar forma de llevar los datos (dejar vivo el evento??)
	(send ?e complete)
	(jump EP-1)

	(debug Declaring movement of ?fell from ?from to ?to)
)