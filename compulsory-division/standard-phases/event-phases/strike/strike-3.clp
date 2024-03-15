(defmodule strike-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule a-face-strike-hindered
	(logical
		(data (phase strike) (data target ?t))
		(data (phase strike) (data attackable ?at))
		(object (name ?t) (state UNTAPPED))
		(object (is-a E-phase) (state EXEC))
	)
	=>
	(assert (action 
		(player (send ?t get-player))
		(event-def variable)
		(description (sym-cat "Face strike from " ?at " to " ?t " hindered"))
		(identifier ?t)
		(data (create$ hindered))
	))
)