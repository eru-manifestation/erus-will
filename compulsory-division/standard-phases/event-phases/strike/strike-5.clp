(defmodule strike-5 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule roll-dices
	=>
	(E-roll-dices STRIKE-ROLL strike-5::roll-dices)
)


(defrule execute-strike
	(data (phase strike) (data target ?char))
	(data (phase strike) (data attackable ?at))
	?e <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (res ?d))
	=>
	(bind ?prowess (send ?char get-prowess))
	(bind ?at-prowess (send ?at get-prowess))
	(bind ?at-body (send ?at get-body))

	(if (< ?at-prowess (+ ?d ?prowess)) then
		(if (neq ?at-body (slot-default-value ATTACKABLE body)) then
			(make-instance (gen-name E-phase) of E-phase
				(reason resistance-check strike-5::execute-strike#enemy-res-check)
				(data attacker ?char / assaulted ?at))
			else
			(complete DEFEATED)
		)
		else
		(if (> ?at-prowess (+ ?d ?prowess)) then
			(make-instance (gen-name E-phase) of E-phase
				(reason resistance-check strike-5::execute-strike#defender-res-check)
				(data attacker ?at / assaulted ?char))
			else
			(complete PARTIALLY-UNDEFEATED)
		)
	)
)

(defrule enemy-res
	?e <- (object (is-a E-phase) (state EXEC))
	?res <- (object (is-a E-phase) (position ?e) (reason resistance-check strike-5::execute-strike#enemy-res-check) (state DONE | DEFUSED))
	=>
	(complete (switch (send ?res get-res)
		(case PASSED then DEFEATED)
		(default PARTIALLY-UNDEFEATED)
	))
)

(defrule defender-res
	?e <- (object (is-a E-phase) (state EXEC))
	?res <- (object (is-a E-phase) (position ?e) (reason resistance-check strike-5::execute-strike#defender-res-check) (state DONE | DEFUSED))
	=>
	(complete (switch (send ?res get-res)
		(case PASSED then PARTIALLY-UNDEFEATED)
		(default UNDEFEATED)
	))
)