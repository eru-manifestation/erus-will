;/////////////////// ATTACK 2 1: EL JUGADOR DISTRIBUYE LOS GOLPES ////////////////////////
(defmodule attack-2-1 (import MAIN ?ALL) (import attack-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule init-strikes
	(data (data attackable ?at))
	=>
	(assert (data (data num-strikes (send ?at get-strikes))))
)

(defrule decrease-strikes
	(data (data num-strikes ?n&:(< 1 ?n)))
	=>
	(assert (data (data num-strikes (- ?n 1))))
)

;	TODO: deberia funcionar correctamente solo si la saliencia de action-selection es inferior a 0
(defrule player-select-strike (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
    	(player ?p)
		(data (data fellowship ?fell))
		(data (data attackable ?at))
		?f <- (data (data num-strikes ?))
		;(object (is-a ATTACKABLE) (name ?at) (strikes ?strikes&:(< 0 ?strikes)))
		(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
		(in (over ?fell) (under ?char))
		;(not (object (is-a E-select-strike) (char ?char)))
		(not (data (data strike ?char)))
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