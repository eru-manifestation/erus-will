(defmodule combat-1 (import MAIN ?ALL))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule attack
	?f <- (data (phase combat) (data attack ?n ?fell ?attackable))
	(not (data (phase combat) (data attack ?n2&:(< ?n2 ?n) $?)))
	=>
	(retract ?f)
	(make-instance (gen-name E-phase) of E-phase (reason attack combat-1::attack)
		(data fellowship ?fell / attackable ?attackable))
)