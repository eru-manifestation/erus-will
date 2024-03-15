(defmodule attack-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule init-strikes
	(data (phase attack) (data attackable ?at))
	=>
	(loop-for-count (?i (send ?at get-strikes)) 
		(assert (data (phase attack) (data unasigned-strike ?i)))
	)
)

(defrule a-defender-select-strike (declare (salience ?*a-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
		(data (phase attack) (data fellowship ?fell))
		(data (phase attack) (data attackable ?at))
		?f <- (data (phase attack) (data unasigned-strike ?))
		(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
		(in (over ?fell) (under ?char))
		(not (data (phase attack) (data strike ?char)))
	)
	=>
	(assert (action 
		(player (send ?fell get-player))
		(event-def variable)
		(initiator ?f)
		(description (sym-cat "Asignar golpe de " ?at " a " ?char))
		(identifier ?at ?char)
		(data (create$ strike ?char))
	))
)