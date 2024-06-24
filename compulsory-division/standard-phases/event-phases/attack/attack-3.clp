(defmodule attack-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule a-attacker-select-strike (declare (salience ?*a-population*))
	(logical 
		(object (is-a EP-attack) (state EXEC) (fellowship ?fell) (attackable ?at) (strikes $?strikes) (name ?attack))
		(object (is-a ATTACKABLE) (name ?at) (strikes ?n&:(< 0 ?n)))
		(object (is-a CHARACTER) (name ?char))
		(in (over ?fell) (under ?char))
		(test (not (member$ ?char ?strikes)))
	)
	=>
	(assert (action 
		(player (enemy (send ?char get-player)))
		(event-def modify)
		(description (sym-cat "Asignar golpe de " ?at " a " ?char))
		(identifier ?at ?char)
		(data ?attack strikes (create$ ?strikes ?char))
		(reason attack-3::a-attacker-select-strike)
		(blocking TRUE)
	))
)