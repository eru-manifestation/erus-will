;/////////////////////// CORRUPTION CHECK 1 1 1: EJECUCION LANZAR DADOS PARA EL CHEQUEO DE CORRUPCION ///////////////////////
(defmodule corruption-check-1-1-1 (import MAIN ?ALL) (export ?ALL))


;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices
	=>
	(assert (data (phase corruption-check) (data dices (+ (random 1 6) (random 1 6)))))
)