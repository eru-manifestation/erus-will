(defmodule attack-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule a-defender-select-strike (declare (salience ?*a-population*))
	(logical 
		(object (is-a EP-attack) (state EXEC) (fellowship ?fell) (attackable ?at) (strikes $?strikes) (name ?attack))
		(object (is-a ATTACKABLE) (name ?at) (strikes ?n&:(< 0 ?n)))
		(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
		(in (over ?fell) (under ?char))
		(test (not (member$ ?char ?strikes)))
	)
	=>
	(assert (action 
		(player (send ?fell get-player))
		(event-def modify)
		(description (sym-cat "Asignar golpe de " ?at " a " ?char))
		(identifier ?at ?char)
		(data ?attack strikes (create$ ?strikes ?char))
		(reason attack-2::a-defender-select-strike)
	))
)