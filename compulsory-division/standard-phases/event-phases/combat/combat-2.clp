(defmodule combat-2 (import MAIN ?ALL))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule resolve-combat#defeated
	?e <- (object (is-a EP-combat) (active TRUE) (attackables))
	(not (object (is-a EP-attack) (position ?e) (res ~DEFEATED)))
	=>
	(message "El ataque ha sido derrotado")
	(complete DEFEATED)
)

(defrule resolve-combat#undefeated
	?e <- (object (is-a EP-combat) (active TRUE) (attackables))
	(exists (object (is-a EP-attack) (position ?e) (res ~DEFEATED)))
	=>
	(message "El ataque no ha sido derrotado")
	(complete UNDEFEATED)
)