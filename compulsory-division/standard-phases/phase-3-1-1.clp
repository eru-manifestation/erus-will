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
	(send ?e complete)
	(jump EP-1)

	(debug Declaring movement of ?fell from ?from to ?to)
)


; ACCIÓN: 
; 
(defrule action-fell-move (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-3-1-1))
		(object (is-a E-fell-decl-move) (type IN)
			(fell ?fell) (from ?from) (to ?to) (name ?name))
	)
	=>
	(assert (action 
		(player ?*player*)
		(event-def fell-move)
		(description (sym-cat "Move fellowship " ?fell " from " ?from " to " ?to))
		(data (create$ 
		"( decl-name [" ?name "])"
		"( fell [" ?fell "])"
		"( from [" ?from "])"
		"( to [" ?to "])"))
	)); TODO: Completar e evento fell-declare-move lo antes posible en la fase fell-move
)