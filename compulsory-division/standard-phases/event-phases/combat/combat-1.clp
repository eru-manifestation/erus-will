(defmodule combat-1 (import MAIN ?ALL))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule attack
	(object (is-a EP-combat) (state EXEC) (target ?fell) (attackables ?at $?))
	=>
	(make-instance (gen-name EP-attack) of EP-attack 
		(reason combat-1::attack)
		(fellowship ?fell) 
		(attackable ?at))
)