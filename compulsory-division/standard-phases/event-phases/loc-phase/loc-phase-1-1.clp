;/////////////////// LOCATION PHASE 1 1: EJECUCION ATAQUE AUTOMATICO FASE LUGARES ////////////////////////
(defmodule loc-phase-1-1 (import MAIN ?ALL) (export ?ALL))


;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule face-automatic-attacks
	(data (phase loc-phase) (data fellowship ?fell))
	(object (is-a LOCATION) (name ?loc&:(eq ?loc (send ?fell get-position))) 
		(automatic-attacks $? ?attack $?))
	=>
	(make-instance (gen-name E-phase) of E-phase 
		(reason attack loc-phase-1-1::face-automatic-attacks)
		(data fellowhsip ?fell / attackable ?attack))
)