;/////////////////// STRIKE 3 1: LANZAR LOS DADOS ////////////////////////
(defmodule strike-3-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Roll dices))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule roll-dices
	(object (is-a EP-strike) (name ?ep) (type ONGOING))
	=>
	(send ?ep put-dices (+ (random 1 6) (random 1 6)))
)