;/////////////////////// FASE 5 2 1: AMBOS ROBAN ANTES DEL FINAL DEL TURNO ///////////////////////
(defmodule P-5-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Ambos roban antes del final del turno))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule both-players-draw
	=>
	(make-instance (gen-name EP-both-players-draw) of EP-both-players-draw)
)
