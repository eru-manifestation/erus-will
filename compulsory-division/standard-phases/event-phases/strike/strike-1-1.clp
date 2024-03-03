;/////////////////// STRIKE 1 1: ELEGIR SI HACER FRENTE AL ATAQUE CON -3 ////////////////////////
(defmodule strike-1-1 (import MAIN ?ALL) (export ?ALL))


;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule action-face-strike-hindered
	(logical
		(object (is-a E-phase) (state EXEC))
		
		(data (phase strike) (data target ?t))
		(data (phase strike) (data attackable ?at))
		(object (name ?t) (state UNTAPPED))
	)
	=>
	(assert (action 
		(player (send ?t get-player))
		(event-def variable)
		(description (sym-cat "Face strike from " ?at " to " ?t " hindered"))
		(identifier ?t)
		(data (create$ unpunished-hindered))
	))
)