(defmodule attack-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule a-strike  (declare (salience ?*a-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
    	(player ?p)
		(data (phase attack) (data attackable ?at))
		?f <- (data (phase attack) (data strike ?char))
	)   
    =>
	(assert (action 
		(player ?p)
		(event-def phase)
		(initiator ?f)
		(description (sym-cat "Ejecutar golpe en " ?char))
		(identifier ?char)
		(data (create$ target ?char / attackable ?at))
		(reason strike attack-4::a-strike)
		(blocking TRUE)
	))
)

(defrule declare-result#defeated
	?e <- (object (is-a E-phase) (state EXEC))
	(not (data (phase attack) (data strike $?)))
	(not (object (is-a E-phase) (position ?e) 
		(reason strike $?) (res ~DEFEATED)))
	=>
	(complete DEFEATED)
	(message "Todos los golpes han sido superados, el ataque ha sido derrotado")
)



(defrule declare-result#undefeated
	?e <- (object (is-a E-phase) (state EXEC))
	(not (data (phase attack) (data strike $?)))
	(exists (object (is-a E-phase) (position ?e) 
		(reason strike $?) (res ~DEFEATED)))
	=>
	(complete UNDEFEATED)
	(message "Como algun golpe no se considera superado, el ataque ha sido exitoso")
)