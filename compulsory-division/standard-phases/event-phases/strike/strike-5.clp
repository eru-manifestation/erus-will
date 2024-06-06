(defmodule strike-5 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule roll-dices
	=>
	(E-roll-dices strike-roll strike-5::roll-dices)
)


(defrule execute-strike
	?e <- (object (is-a EP-strike) (active TRUE) (attackable ?at) (target ?char))
	(object (is-a EP-strike-roll) (position ?e) (state DONE) (name ?dices))
	=>
	(bind ?d (send ?dices get-res))
	(bind ?prowess (send ?char get-prowess))
	(bind ?at-prowess (send ?at get-prowess))
	(bind ?at-body (send ?at get-body))

	(if (< ?at-prowess (+ ?d ?prowess)) then
		(if (neq ?at-body (slot-default-value ATTACKABLE body)) then
			(make-instance (gen-name EP-resistance-check) of EP-resistance-check
				(reason strike-5::execute-strike#enemy-res-check)
				(attacker ?char)
				(target ?at))
			else
			(complete DEFEATED)
		)
		else
		(if (> ?at-prowess (+ ?d ?prowess)) then
			(make-instance (gen-name EP-resistance-check) of EP-resistance-check
				(reason strike-5::execute-strike#defender-res-check)
				(attacker ?at)
				(target ?char))
			else
			(complete PARTIALLY-UNDEFEATED)
		)
	)
)

(defrule enemy-res
	?e <- (object (is-a EP-strike) (active TRUE))
	?res <- (object (is-a EP-resistance-check) (position ?e) (reason strike-5::execute-strike#enemy-res-check) (state DONE | DEFUSED))
	=>
	(complete (switch (send ?res get-res)
		(case PASSED then DEFEATED)
		(default PARTIALLY-UNDEFEATED)
	))
)

(defrule defender-res
	?e <- (object (is-a EP-strike) (active TRUE))
	?res <- (object (is-a EP-resistance-check) (position ?e) (reason strike-5::execute-strike#defender-res-check) (state DONE | DEFUSED))
	=>
	(complete (switch (send ?res get-res)
		(case PASSED then PARTIALLY-UNDEFEATED)
		(default UNDEFEATED)
	))
)