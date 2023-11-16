;/////////////////// STRIKE 3 2: EJECUTAR GOLPE ////////////////////////
(defmodule strike-3-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug The strike is being executed))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule execute-strike
	(object (is-a EP-strike) (name ?ep) (type ONGOING) (char ?char) (attackable ?at))
	(object (is-a CHARACTER) (name ?char))
	(object (is-a ATTACKABLE) (name ?at))
	=>
	(bind ?prowess (send ?char get-prowess))
	(bind ?at-prowess (send ?at get-prowess))
	(bind ?at-body (send ?at get-body))

	(if (< ?at-prowess (+ (send ?ep get-dices) ?prowess)) then
		(if (eq ?at-body nil) then
			(send ?ep put-state DEFEATED)
			else
			(make-instance (gen-name EP-resistance-check) of EP-resistance-check (attacker ?char) (assaulted ?at))
		)
		else
		(if (= ?at-prowess (+ (send ?ep get-dices) ?prowess)) then
			(send ?ep put-state UNDEFEATED)
			else
			(make-instance (gen-name EP-resistance-check) of EP-resistance-check (attacker ?at) (assaulted ?char))
			(send ?ep put-state SUCCESSFUL)		
		)
	)
)

(defrule execute-strike#tap-unhindered
	(object (is-a EP-strike) (name ?ep) (type ONGOING) (char ?char) (hindered FALSE))
	(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
	=>
	(send ?char put-state TAPPED)
)


(defrule calculate-check-result
	(object (is-a EP-strike) (name ?ep) (type ONGOING) (char ?char) (attackable ?at))
	(object (is-a EP-resistance-check) (type OUT) (attacker ?char) (assaulted ?at) (result ?res))
	=>
	(if (eq ?res PASSED) then
		(send ?ep put-state UNDEFEATED)
		else
		(if (eq ?res NOT-PASSED) then
			(send ?ep put-state UNDEFEATED)
		)
	)
)