;/////////////////////// FASE 4: FASE DE LUGARES ///////////////////////
(defmodule P-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Fase de lugares))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



; ACCIÓN: INICIAR FASE MOVIMIENTO
(defrule action-loc-phase (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-4))

		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p&:(eq ?p ?*player*)))
		(object (is-a LOCATION) (name ?loc))
		(in (transitive FALSE) (over ?loc) (under ?fell))
		(not (object (is-a E-loc-phase) (loc ?loc) (fell ?fell))) ;TODO ARREGLAR ESTO
	)
	=>
	(assert (action 
		(player ?p)
		(event-def loc-phase)
		(description (sym-cat "Begin location phase for " ?fell " in " ?loc))
		(data (create$ 
		"( fell [" ?fell "])"
		"( loc [" ?loc "])"))
	))
)
