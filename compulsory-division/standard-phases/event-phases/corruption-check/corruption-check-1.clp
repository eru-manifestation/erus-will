(defmodule corruption-check-1 (import MAIN ?ALL) )
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices
	=>
	(E-roll-dices CORRUPTION-ROLL corruption-check-1::roll-dices)
)

(defrule execute-corruption-check
	?e <- (object (is-a E-phase) (state EXEC))
	(data (phase corruption-check) (data target ?t))
	(object (is-a E-phase) (position ?e) (reason dices CORRUPTION-ROLL $?) (state DONE) (res ?d))
	=>
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