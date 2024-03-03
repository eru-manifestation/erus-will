;/////////////////// STRIKE 3 2: EJECUTAR GOLPE ////////////////////////
(defmodule strike-3-2 (import MAIN ?ALL) (import strike-3-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule execute-strike
	(data (phase strike) (data target ?char))
	(data (phase strike) (data attackable ?at))
	(data (phase strike) (data dices ?d))
	=>
	(bind ?prowess (send ?char get-prowess))
	(bind ?at-prowess (send ?at get-prowess))
	(bind ?at-body (send ?at get-body))

	(if (< ?at-prowess (+ ?d ?prowess)) then
		(if (neq ?at-body (slot-default-value ATTACKABLE body)) then
			(make-instance (gen-name E-phase) of E-phase
				(reason resistance-check strike-3-2::execute-strike#enemy-res-check)
				(data attacker ?char / assaulted ?at))
			else
			(complete DEFEATED)
		)
		else
		(if (> ?at-prowess (+ ?d ?prowess)) then
			(make-instance (gen-name E-phase) of E-phase
				(reason resistance-check strike-3-2::execute-strike#defender-res-check)
				(data attacker ?at / assaulted ?char))
			else
			(complete PARTIALLY-UNDEFEATED)
		)
	)
)


(defrule undefeat-attacker
	?e <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-phase) (reason $? strike-3-2::execute-strike#enemy-res-check)
		(position ?e) (state DONE) (res NOT-PASSED)
	)
	=>
	(complete PARTIALLY-UNDEFEATED)
)


(defrule defeat-attacker
	?e <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-phase) (reason $? strike-3-2::execute-strike#enemy-res-check)
		(position ?e) (state DONE) (res PASSED)
	)
	=>
	(complete DEFEATED)
)


(defrule undefeated-strike
	?e <- (object (is-a E-phase) (state EXEC))
	(not (object (is-a E-phase) (reason $? strike-3-2::execute-strike#defender-res-check)
		(position ?e)))
	=>
	(complete UNDEFEATED)
)


(defrule tap-unhindered
	(data (phase strike) (data target ?char))
	(not (data (phase strike) (data hindered)))
	(test (eq UNTAPPED (send ?char get-state)))
	=>
	(E-modify ?char state TAPPED
		TAP strike-3-2::tap-unhindered)
)