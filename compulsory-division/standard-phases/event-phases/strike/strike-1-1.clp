;/////////////////// STRIKE 1 1: ELEGIR SI HACER FRENTE AL ATAQUE CON -3 ////////////////////////
(defmodule strike-1-1 (import MAIN ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Player chooses whether facing the strike normally or hindered with -3 prowess))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule action-face-strike-hindered
	(logical
		(only-actions (phase strike-1-1))
		
		(target ?char)
		(attackable ?at)
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