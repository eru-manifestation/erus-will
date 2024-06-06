(defmodule attack-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule a-strike (declare (salience ?*a-population*))
	(logical 
		?e <- (object (is-a EP-attack) (state EXEC) (attackable ?at) (strikes $? ?char $?))
		(player ?p)
	)   
    =>
	(assert (action 
		(player ?p)
		(event-def strike)
		(description (sym-cat "Ejecutar golpe en " ?char))
		(identifier ?char)
		(data "(target [" ?char "]) (attackable [" ?at "])")
		(reason attack-4::a-strike)
		(blocking TRUE)
	))
)

(defrule declare-result#defeated
	?e <- (object (is-a EP-attack) (active TRUE) (strikes))
	(not (object (is-a EP-strike) (position ?e) (res ~DEFEATED)))
	=>
	(complete DEFEATED)
	(message "Todos los golpes han sido superados, el ataque ha sido derrotado")
)



(defrule declare-result#undefeated
	?e <- (object (is-a EP-attack) (active TRUE) (strikes))
	(exists (object (is-a EP-strike) (position ?e) (res ~DEFEATED)))
	=>
	(complete UNDEFEATED)
	(message "Como algun golpe no se considera superado, el ataque ha sido exitoso")
)