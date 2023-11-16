;/////////////////// STRIKE 1 1: ELEGIR SI HACER FRENTE AL ATAQUE CON -3 ////////////////////////
(defmodule strike-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Player chooses whether facing the strike normally or hindered with -3 prowess))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule action-face-strike-hindered
	(logical
		(only-actions (phase strike-1-1))
    	(player ?p)
		
		(object (is-a EP-strike) (name ?ep) (type ONGOING) (attackable ?at) (char ?char) (hindered FALSE))
		(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def face-strike-hindered)
		(description (sym-cat "Face strike from " ?at " to " ?char " hindered"))
		(identifier ?char)
		(data (create$ 
		"( strike [" ?ep "])"))
	))
)