;/////////////////// RESISTANCE CHECK 1: LANZAR DADOS ////////////////////////
(defmodule resistance-check-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices
	=>
	(E-roll-dices resistance-roll resistance-check-1::roll-dices)
)

(defrule execute-resistance-check
	(object (is-a EP-resistance-check) (active TRUE) (target ?as))
	(object (is-a EP-resistance-roll) (state DONE) (name ?dices))
	=>
	(bind ?d (send ?dices get-res))
	(if (< ?d (send ?as get-body)) then
		(message "Se ha pasado el chequeo de resistencia")
		(complete PASSED)
		else
		(message "No se ha pasado el chequeo de resistencia")
		(complete NOT-PASSED)
	)
)