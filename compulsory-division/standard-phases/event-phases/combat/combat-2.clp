(defmodule combat-2 (import MAIN ?ALL))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule resolve-combat#defeated
	?e <- (object (is-a E-phase) (state EXEC))
	(not (data (phase combat) (data attack $?)))
	(not (object (is-a E-phase) (position ?e) 
		(reason attack $?) (res ~DEFEATED)))
	=>
	(message "El ataque ha sido derrotado")
	(complete DEFEATED)
)

(defrule resolve-combat#undefeated
	?e <- (object (is-a E-phase) (state EXEC))
	(not (data (phase combat) (data attack $?)))
	(exists (object (is-a E-phase) (position ?e) 
		(reason attack $?) (res ~DEFEATED)))
	=>
	(message "El ataque no ha sido derrotado")
	(complete UNDEFEATED)
)