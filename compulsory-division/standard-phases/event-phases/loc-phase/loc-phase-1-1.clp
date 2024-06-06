;/////////////////// LOCATION PHASE 1 1: EJECUCION ATAQUE AUTOMATICO FASE LUGARES ////////////////////////
(defmodule loc-phase-1-1 (import MAIN ?ALL))


;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule face-automatic-attacks
	(object (is-a EP-loc-phase) (active TRUE) (fellowship ?fell))
	(object (name ?fell) (position ?loc))
	(object (is-a LOCATION) (name ?loc) (automatic-attacks ?attack1 $?attacks))
	=>
	(make-instance (gen-name EP-combat) of EP-combat 
		(reason loc-phase-1-1::face-automatic-attacks)
		(target ?fell)
		(attackables ?attack1 $?attacks))
)