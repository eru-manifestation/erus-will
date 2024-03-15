;/////////////////// LOCATION PHASE 1 1: EJECUCION ATAQUE AUTOMATICO FASE LUGARES ////////////////////////
(defmodule loc-phase-1-1 (import MAIN ?ALL))


;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule face-automatic-attacks
	(data (phase loc-phase) (data fellowship ?fell))
	(object (name ?fell) (position ?loc))
	(object (is-a LOCATION) (name ?loc) (automatic-attacks ?attack1 $?attacks))
	=>
	(bind ?data (create$ attack 1 ?fell ?attack1))
	(bind ?i 2)
	(foreach ?attack ?attacks
		(bind ?data (create$ ?data / attack ?i ?fell ?attack))
		(bind ?i (+ 1 ?i))
	)
	(make-instance (gen-name E-phase) of E-phase 
		(reason combat loc-phase-1-1::face-automatic-attacks)
		(data ?data))
)