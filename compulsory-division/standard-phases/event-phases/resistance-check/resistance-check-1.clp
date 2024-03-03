;/////////////////// RESISTANCE CHECK 1: LANZAR DADOS ////////////////////////
(defmodule resistance-check-1 (import MAIN ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices
	=>
	(assert (data (phase resistance-check) (data dices (+ (random 1 6) (random 1 6)))))
)

(defrule punish-wounded
	?f1 <- (data (phase resistance-check) (data dices ?n))
	(data (phase resistance-check) (data target ?char))
	(not (data (phase resistance-check) (data punish-wounded)))
	(test (eq WOUNDED (send ?char get-state))) 
	=>
	(retract ?f1)
	(assert (data (phase resistance-check) (data dices (+ ?n 1)))
		(data (phase resistance-check) (data punish-wounded)))
	(message "La tirada de dados aumenta en 1 porque el personaje estaba herido antes")
)

