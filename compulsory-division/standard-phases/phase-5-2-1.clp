;/////////////////////// FASE 5 2 1: AMBOS ROBAN ANTES DEL FINAL DEL TURNO ///////////////////////
(defmodule P-5-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule standarize-hand
	(object (is-a PLAYER) (name ?p))
	=>
	(make-instance (gen-name EP-standarize-hand) of EP-standarize-hand 
		(reason P-5-2-1::standarize-hand)
		(target ?p))
)
