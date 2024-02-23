;/////////////////////// FASE 5 2 1: AMBOS ROBAN ANTES DEL FINAL DEL TURNO ///////////////////////
(defmodule P-5-2-1 (import MAIN ?ALL) (import P-5-1-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(message Ambos roban antes del final del turno))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule standarize-hand
	(object (is-a PLAYER) (name ?p))
	=>
	(make-instance (gen-name E-phase) of E-phase 
		(reason standarize-hand P521::standarize-hand)
		(data (str-cat "target [" ?p "]")))
)
