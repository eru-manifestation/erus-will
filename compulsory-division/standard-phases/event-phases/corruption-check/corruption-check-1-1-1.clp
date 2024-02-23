;/////////////////////// CORRUPTION CHECK 1 1 1: EJECUCION LANZAR DADOS PARA EL CHEQUEO DE CORRUPCION ///////////////////////
(defmodule corruption-check-1-1-1 (import MAIN ?ALL) (export ?ALL))
(deftemplate data (multislot data))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices
	=>
	(assert (data (data dices (+ (random 1 6) (random 1 6)))))
)