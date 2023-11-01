;/////////////////// ORGANIZATION 1: FIN FASE ORGANIZACION ////////////////////////
(defmodule loc-organize-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Fin fase organizacion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule fin-organization
	?ep <- (object (is-a EP-loc-organize) (type ONGOING) (loc ?loc) (player ?p))
	=>
	(send ?ep complete)

	(debug Finaliza la organizacion de ?p en ?loc)
)