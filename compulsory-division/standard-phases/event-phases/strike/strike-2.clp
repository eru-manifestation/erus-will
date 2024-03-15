(defmodule strike-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule a-spare-strike
	(logical
		(object (is-a E-phase) (state EXEC))
		(data (phase strike) (data target ?t))
		?f <- (data (phase attack) (data unasigned-strike $?))
		(not (data (phase strike) (data spare-strike)))
	)
	=>
	(assert (action 
		(player (enemy (send ?t get-player)))
		(initiator ?f)
		(event-def variable)
		(description (sym-cat "Utilizar golpe sobrante como modificador en " ?t))
		(identifier ?t)
		(data (create$ spare-strike))
	))
)