;/////////////////// STRIKE 1 1: ELEGIR SI HACER FRENTE AL ATAQUE CON -3 ////////////////////////
(defmodule strike-1-1 (import MAIN ?ALL) (export ?ALL))
(deftemplate data (multislot data))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule action-face-strike-hindered
	(logical
		(object (is-a E-phase) (state EXEC) (reason strike $?))
		
		(data (data target ?char))
		(data (data attackable ?at))
		(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
	)
	=>
	(assert (action 
		(player (send ?char get-player))
		(event-def variable)
		(description (sym-cat "Face strike from " ?at " to " ?char " hindered"))
		(identifier ?char)
		(data (create$ unpunished-hindered))
	))
)