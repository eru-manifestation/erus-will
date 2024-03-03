;/////////////////// ATTACK 2 1: EL JUGADOR DISTRIBUYE LOS GOLPES ////////////////////////
(defmodule attack-2-1 (import MAIN ?ALL) (import attack-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule init-strikes
	(data (phase attack) (data attackable ?at))
	=>
	(assert (data (phase attack) (data num-strikes (send ?at get-strikes))))
)

(defrule decrease-strikes
	?f <- (data (phase attack) (data num-strikes ?n))
	=>
	(loop-for-count (?i ?n) 
		(assert (data (phase attack) (data unasigned-strike ?i)))
	)
	(retract ?f)
)

(defrule player-select-strike (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
    	(player ?p)
		(data (phase attack) (data fellowship ?fell))
		(data (phase attack) (data attackable ?at))
		?f <- (data (phase attack) (data unasigned-strike ?))
		;(object (is-a ATTACKABLE) (name ?at) (strikes ?strikes&:(< 0 ?strikes)))
		(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
		(in (over ?fell) (under ?char))
		;(not (object (is-a E-select-strike) (char ?char)))
		(not (data (phase attack) (data strike ?char)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def variable)
		(initiator ?f)
		(description (sym-cat "Assign strike from " ?at " to " ?char))
		(identifier ?at ?char)
		(data (create$ strike ?char))
	))
)