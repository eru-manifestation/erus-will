(defmodule strike-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule a-face-strike-hindered
	(logical
		(object (is-a EP-strike) (state EXEC) (target ?t) (attackable ?at) (hindered FALSE) (name ?strike))
		(object (name ?t) (state UNTAPPED))
	)
	=>
	(assert (action 
		(player (send ?t get-player))
		(event-def modify)
		(description (sym-cat "Face strike from " ?at " to " ?t " hindered"))
		(identifier ?t)
		(data ?strike hindered TRUE)
		(reason strike-3::a-face-strike-hindered)
	))
)