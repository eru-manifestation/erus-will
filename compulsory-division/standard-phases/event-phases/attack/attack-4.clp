;/////////////////// ATTACK 4: DECLARAR RESULTADO DEL ATAQUE ////////////////////////
(defmodule attack-4 (import MAIN ?ALL) (import attack-3 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule declare-result#defeated
	?e <- (object (is-a E-phase) (state EXEC))
	(not (object (is-a E-phase) (position ?e) 
		(reason strike $?) (res ~DEFEATED)))
	=>
	(complete DEFEATED)
	(message "Todos los golpes han sido superados, el ataque ha sido derrotado")
)



(defrule declare-result#successful
	?e <- (object (is-a E-phase) (state EXEC))
	(exists (object (is-a E-phase) (position ?e) 
		(reason strike $?) (res ~DEFEATED)))
	=>
	(complete UNDEFEATED)
	(message "Como algun golpe no se considera superado, el ataque ha sido exitoso")
)