;/////////////////// ATTACK 3: HACER FRENTE AL GOLPE EN EL ORDEN QUE ELIJA EL DEFENSOR ////////////////////////
(defmodule attack-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug ?*player* chooses the order in which strikes execute))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))




(defrule action-E-select-strike (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
	(logical 
		(only-actions (phase attack-3))

		?e <- (object (is-a E-select-strike) (type IN) 
        (char ?char) (attackable ?attackable))
	)   
    =>
	(assert (action 
		(player ?*player*)
		(event-def strike)
		(description (sym-cat "Execute strike from " ?at " to " ?char))
		(data (create$ 
		"( char [" ?char "])" 
		"( attackable [" ?at "])"))
	))
)