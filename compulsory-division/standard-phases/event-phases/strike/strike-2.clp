(defmodule strike-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule a-spare-strike
	(logical
		(object (is-a EP-strike) (state EXEC) (target ?t) (attackable ?at) (spare-strike FALSE) (name ?strike))
		(object (is-a ATTACKABLE) (name ?at) (strikes ?n&:(< 0 ?n)))
	)
	=>
	(assert (action 
		(player (enemy (send ?t get-player)))
		(event-def modify)
		(description (sym-cat "Utilizar golpe sobrante como modificador en " ?t))
		(identifier ?t)
		(data ?strike spare-strike TRUE)
		(reason strike-2::a-spare-strike)
	))
)