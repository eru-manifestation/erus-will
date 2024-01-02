;/////////////////// ATTACK 4: DECLARAR RESULTADO DEL ATAQUE ////////////////////////
(defmodule attack-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Declare the result of the attack))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule declare-result#defeated
	?ep-at <- (object (is-a EP-attack) (type ONGOING))
	(not (object (is-a EP-strike) (state SUCCESSFUL | UNDEFEATED)))
	=>
	(send ?ep-at modify state DEFEATED)
	(debug Attack defeated)
)



(defrule declare-result#successful
	?ep-at <- (object (is-a EP-attack) (type ONGOING))
	(exists (object (is-a EP-strike) (state ?state&:(neq DEFEATED ?state))))
	=>
	(send ?ep-at modify state UNDEFEATED)
	(debug Attack undefeated)
)