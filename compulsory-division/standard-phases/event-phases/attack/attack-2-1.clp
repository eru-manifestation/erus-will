;/////////////////// ATTACK 2 1: EL JUGADOR DISTRIBUYE LOS GOLPES ////////////////////////
(defmodule attack-2-1 (import MAIN ?ALL) (import attack-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule init-strikes
	(attackable ?at)
	=>
	(assert (num-strikes (send ?at get-strikes)))
)

(defrule decrease-strikes
	(num-strikes ?n&:(< 1 ?n))
	=>
	(assert (num-strikes (- ?n 1)))
)

;	TODO: deberia funcionar correctamente solo si la saliencia de action-selection es inferior a 0
(defrule player-select-strike (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
    	(player ?p)
		(fellowship ?fell)
		(attackable ?at)
		?f <- (num-strikes ?)
		;(object (is-a ATTACKABLE) (name ?at) (strikes ?strikes&:(< 0 ?strikes)))
		(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
		(in (over ?fell) (under ?char))
		;(not (object (is-a E-select-strike) (char ?char)))
		(not (strike ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def varswap)
		(description (sym-cat "Assign strike from " ?at " to " ?char))
		(identifier ?at ?char)
		(data (create$ ?f strike ?char))
	))
)