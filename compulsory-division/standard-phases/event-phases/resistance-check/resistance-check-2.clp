;/////////////////// RESISTANCE CHECK 2: EJECUTAR CHEQUEO RESISTENCIA ////////////////////////
(defmodule resistance-check-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Execute resistance check))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))


(defrule execute-resistance-check
	(object (is-a EP-resistance-check) (name ?ep) (type ONGOING) (assaulted ?assaulted))
	=>
	(if (<  (send ?ep get-dices) (send ?assaulted get-body)) then
		(send ?ep put-result NOT-PASSED)
		else
		(send ?ep put-result PASSED)
	)
)

