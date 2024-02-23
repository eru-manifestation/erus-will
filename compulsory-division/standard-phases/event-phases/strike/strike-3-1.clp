;/////////////////// STRIKE 3 1: LANZAR LOS DADOS ////////////////////////
(defmodule strike-3-1 (import MAIN ?ALL) (import strike-2 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule roll-dices
	;(object (is-a EP-strike) (name ?ep) (type ONGOING))
	=>
	;(send ?ep modify dices (+ (random 1 6) (random 1 6)))
	(assert (dices (+ (random 1 6) (random 1 6))))
)

(defrule punish-hindered
	?f1 <- (dices ?n)
	?f2 <- (unpunished-hindered)
	=>
	(retract ?f1 ?f2)
	(assert (dices (- ?n 3)) (hindered))
)