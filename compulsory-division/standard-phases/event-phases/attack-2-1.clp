;/////////////////// ATTACK 2 1: EL JUGADOR DISTRIBUYE LOS GOLPES ////////////////////////
(defmodule attack-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug ?*player* chooses how to distrubute the strikes))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule player-select-strike (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase attack-2-1))
		(object (is-a EP-attack) (type ONGOING) (fell ?fell) (attackable ?at))
		(object (is-a ATTACKABLE) (name ?at) (strikes ?strikes&:(< 0 ?strikes)))
		(object (is-a CHARACTER) (name ?char) (state UNTAPPED))
		(in (over ?fell) (under ?char))
		(not (object (is-a E-select-strike) (char ?char)))
	)
	=>
	(assert (action 
		(player ?*player*)
		(event-def select-strike)
		(description (sym-cat "Assign strike from " ?at " to " ?char))
		(data (create$ 
		"( char [" ?char "])" 
		"( attackable [" ?at "])"))
	))
)