(defmodule attack-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule a-attacker-select-strike (declare (salience ?*a-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
		(data (phase attack) (data fellowship ?fell))
		(data (phase attack) (data attackable ?at))
		?f <- (data (phase attack) (data unasigned-strike ?))
		(object (is-a CHARACTER) (name ?char))
		(in (over ?fell) (under ?char))
		(not (data (phase attack) (data strike ?char)))
	)
	=>
	(assert (action 
		(player (send ?at get-player))
		(event-def variable)
		(initiator ?f)
		(description (sym-cat "Asignar golpe de " ?at " a " ?char))
		(identifier ?at ?char)
		(data (create$ strike ?char))
		(blocking TRUE)
	))
)