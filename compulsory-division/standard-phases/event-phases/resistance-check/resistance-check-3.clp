;/////////////////// RESISTANCE CHECK 3: FIN CHEQUEO RESISTENCIA ////////////////////////
(defmodule resistance-check-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug End of resistance check))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule end-resistance-check
	(object (is-a EP-resistance-check) (name ?ep) (type ONGOING) (attacker ?attacker) (assaulted ?assaulted))
	=>
	(send ?ep complete)
	(debug The resistance check has been (send ?ep get-result) since (send ?ep get-dices) in the roll and ?assaulted has (send ?assaulted get-prowess) prowess and ?attacker has (send ?attacker get-prowess) prowess)
)

