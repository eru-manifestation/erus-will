(defmodule corruption-check-1 (import MAIN ?ALL) )
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices
	=>
	(E-roll-dices corruption-roll corruption-check-1::roll-dices)
)

(defrule execute-corruption-check
	?e <- (object (is-a EP-corruption-check) (active TRUE) (target ?t))
	(object (is-a EP-corruption-roll) (position ?e) (state DONE) (name ?dices))
	=>
	(bind ?d (send ?dices get-res))
	(bind ?corr (send ?t get-corruption))
	(if (> ?d ?corr) then
		(message ?t " ha pasado el chequeo de corrupcion")
		(complete PASSED)
		else
		(if (or (= ?d ?corr) (= (+ 1 ?d) ?corr)) then
			(message ?t " no ha pasado el chequeo de corrupcion")
			(complete NOT-PASSED)
			else
			(message ?t " se ha corrompido")
			(complete CORRUPTED)
		)
	)
)