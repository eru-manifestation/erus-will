;/////////////////// RESISTANCE CHECK 2: EJECUTAR CHEQUEO RESISTENCIA ////////////////////////
(defmodule resistance-check-2 (import MAIN ?ALL) (import resistance-check-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule execute-resistance-check
	(data (phase resistance-check) (data assaulted ?as))
	(data (phase resistance-check) (data dices ?d))
	=>
	(if (< ?d (send ?as get-body)) then
		(message "Se ha pasado el chequeo de resistencia")
		(complete PASSED)
		else
		(message "No se ha pasado el chequeo de resistencia," ?as " abandona la partida")
		(complete NOT-PASSED)
	)
)

