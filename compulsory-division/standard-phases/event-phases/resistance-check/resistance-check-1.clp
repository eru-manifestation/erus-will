;/////////////////// RESISTANCE CHECK 1: LANZAR DADOS ////////////////////////
(defmodule resistance-check-1 (import MAIN ?ALL) (export ?ALL))
(deftemplate data (multislot data))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Roll dices))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices
	=>
	(assert (data (data dices (+ (random 1 6) (random 1 6)))))
)

