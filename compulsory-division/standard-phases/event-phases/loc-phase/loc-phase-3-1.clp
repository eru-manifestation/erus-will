;/////////////////// LOCATION PHASE 3 1: JUGAR OBJETO MENOR ADICIONAL ////////////////////////
(defmodule loc-phase-3-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule play-additional-minor-item (declare (salience ?*a-population*))
	(logical
		?e <- (object (is-a E-phase) (state EXEC))
    	(player ?p)
		(data (phase loc-phase) (data fellowship ?fell))
		(object (is-a MINOR-ITEM) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))

		(exists (object (is-a E-modify) (reason $? PLAY $?) (position ?e)))
		(not (object (is-a E-modify) (reason $? loc-phase-3-1::play-additional-minor-item) (state DONE)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play additional minor item " ?item " under " ?char))
		(identifier ?item ?char)
		(data (create$ ?item position ?char))
		(reason PLAY ITEM loc-phase-3-1::play-additional-minor-item)
	))
)