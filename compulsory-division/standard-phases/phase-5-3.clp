;/////////////////////// FASE 5 3: EJECUTAR CONCILIO LIBRE ANTERIORMENTE CONVOCADO ///////////////////////
(defmodule P-5-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule start-free-council
	(data (phase turn) (data council))
	=>
	(make-instance (gen-name E-phase) of E-phase (reason free-council P53::free-council))
	(message "El Concilio de los Pueblos Libres esta a punto de comenzar")
)
