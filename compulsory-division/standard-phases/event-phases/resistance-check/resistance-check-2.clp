;/////////////////// RESISTANCE CHECK 2: EJECUTAR CHEQUEO RESISTENCIA ////////////////////////
(defmodule resistance-check-2 (import MAIN ?ALL) (import resistance-check-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Execute resistance check))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule execute-resistance-check
	(object (is-a E-phase) (state EXEC) (name ?e))
	;(attacker ?at)
	(assaulted ?as)
	(dices ?d)
	=>
	;	TODO: faltan cosas por hacer
	(if (< ?d (send ?as get-body)) then
		;(send ?ep modify result NOT-PASSED)
		(E-cancel ?e resistance-check-2::execute-resistance-check)
		;else
		;(send ?ep modify result PASSED)
	)
)

