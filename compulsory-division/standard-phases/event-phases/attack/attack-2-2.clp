;/////////////////// ATTACK 2 2: EL ENEMIGO DISTRIBUYE LOS DEMAS GOLPES ////////////////////////
(defmodule attack-2-2 (import MAIN ?ALL) (import attack-2-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule enemy-select-strike (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
		(data (data fellowship ?fell))
		(data (data attackable ?at))
		?f <- (data (data num-strikes ?))
		;(object (is-a ATTACKABLE) (name ?at) (strikes ?strikes&:(< 0 ?strikes)))
		(object (is-a CHARACTER) (name ?char))
		(in (over ?fell) (under ?char))
		(not (data (data strike ?char)))
		;(not (object (is-a E-select-strike) (char ?char)))
	)
	=>
	(assert (action 
		(player (send ?fell get-player))
		(event-def variable)
		(initiator ?f)
		(description (sym-cat "Assign strike from " ?at " to " ?char))
		(identifier ?at ?char)
		(data (create$ strike ?char))
		(blocking TRUE)
	))
)



(defrule enemy-select-spare-strike (declare (salience ?*action-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason attack $?))
		(data (data fellowship ?fell))
		(data (data attackable ?at))
		;(object (is-a ATTACKABLE) (name ?at) (strikes ?strikes&:(< 0 ?strikes)))
		?f <- (data (data num-strikes ?))
		(object (is-a CHARACTER) (name ?char))
		(in (over ?fell) (under ?char))
		(not (exists
			(object (is-a CHARACTER) (name ?char1))
			(in (over ?fell) (under ?char1))
			;(not (object (is-a E-select-strike) (char ?char)))
			(not (data (data strike ?char1)))
		))
	)
	=>
	(assert (action ;TODO: hacer que este golpe esté a -1 de prowess el char
		(player (send ?fell get-player))
		(event-def variable)
		(initiator ?f)
		(description (sym-cat "Assign spare strike from " ?at " to " ?char))
		(identifier ?at ?char)
		(data (create$ spare-strike ?char))
		(blocking TRUE)
	))
)