;/////////////////////// FASE 5 3: EJECUTAR CONCILIO LIBRE ANTERIORMENTE CONVOCADO ///////////////////////
(defmodule P-5-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Ir al concilio libre si ha sido convocado))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule start-free-council (declare (salience ?*event-handler-salience*))
	?ep <- (object (is-a E-convoque-council) (type IN))
	=>
	(make-instance (gen-name EP-free-council) of EP-free-council)
	(debug El Concilio de los Pueblos Libres esta a punto de comenzar)
)
