;/////////////////////// FASE 5 3: EJECUTAR CONCILIO LIBRE ANTERIORMENTE CONVOCADO ///////////////////////
(defmodule P-5-3 (import MAIN ?ALL) (import P-5-2-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(message Ir al concilio libre si ha sido convocado))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule start-free-council
	(council)
	=>
	(make-instance (gen-name E-phase) of E-phase (reason free-council P53::free-council))
	(message "El Concilio de los Pueblos Libres esta a punto de comenzar")
)
