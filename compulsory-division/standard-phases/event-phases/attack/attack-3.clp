;/////////////////// ATTACK 3: HACER FRENTE AL GOLPE EN EL ORDEN QUE ELIJA EL DEFENSOR ////////////////////////
(defmodule attack-3 (import MAIN ?ALL) (import attack-2-2 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule action-select-strike  (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
    	(player ?p)

		;(object (is-a E-select-strike) (name ?e) (type IN) 
        ;(char ?char) (attackable ?at))
		(data (phase attack) (data attackable ?at))
		?f <- (data (phase attack) (data strike ?char))
	)   
    =>
	(assert (action 
		(player ?p)
		(event-def phase)
		(initiator ?f)
		(description (sym-cat "Execute strike from " ?at " to " ?char))
		(identifier ?char)
		(data (create$ "strike attack-3::action-select-strike"
			target ?char / attackable ?at))
		(blocking TRUE)
	))
)


(defrule action-select-spare-strike  (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
    	(player ?p)

		;(object (is-a E-select-strike) (name ?e) (type IN) 
        ;(char ?char) (attackable ?at))
		(not (data (phase attack) (data strike ?char)))
		(data (phase attack) (data attackable ?at))
		?f <- (data (phase attack) (data spare-strike ?char))
	)   
    =>
	(assert (action 
		(player ?p)
		(event-def phase)
		(initiator ?f)
		(description (sym-cat "Execute additional strike from " ?at " to " ?char))
		(identifier ?char)
		(data (create$ "strike attack-3::action-select-spare-strike"
			target ?char / attackable ?at / additional))
		(blocking TRUE)
	))
)