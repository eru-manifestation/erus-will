;//////////////////// Fase 3 1 1: EJECUCIÓN MOVER COMPAÑÍAS ///////////////////////
(defmodule P-3-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Eleccion de la ejecucion del movimiento))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCIÓN: Ejecutar movimiento declarado por el propio evento
(defrule action-fell-move (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-3-1-1))
    	(player ?p)
		(object (is-a E-fell-decl-move) (type IN)
			(fell ?fell) (from ?from) (to ?to) (name ?event))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def fell-move)
		(description (sym-cat "Move fellowship " ?fell " from " ?from " to " ?to))
		(identifier ?fell)
		(data (create$ 
		"( decl-event [" ?event "])"
		"( fell [" ?fell "])"
		"( from [" ?from "])"
		"( to [" ?to "])"))
		(blocking TRUE)
	))
)

; ACCIÓN: Ejecutar permanencia en el lugar
(defrule action-fell-remain (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-3-1-1))
    	(player ?p)
		(object (is-a E-fell-decl-remain) (type IN)
			(loc ?loc) (fell ?fell) (name ?event))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def fell-move)
		(description (sym-cat "Execute remain of " ?fell " in " ?loc))
		(identifier ?fell)
		(data (create$ 
		"( decl-event [" ?event "])"
		"( fell [" ?fell "])"
		"( from [" ?loc "])"
		"( to [" ?loc "])"))
		(blocking TRUE)
	))
)