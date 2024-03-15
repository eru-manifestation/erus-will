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
	(E-roll-dices RESISTANCE-ROLL resistance-check-1::roll-dices)
)

(defrule execute-resistance-check
	(data (phase resistance-check) (data assaulted ?as))
	(object (is-a E-phase) (reason dices RESISTANCE-ROLL $?) (state DONE) (res ?d))
	=>
	(if (< ?d (send ?as get-body)) then
		(message "Se ha pasado el chequeo de resistencia")
		(complete PASSED)
		else
		(message "No se ha pasado el chequeo de resistencia")
		(complete NOT-PASSED)
	)
)