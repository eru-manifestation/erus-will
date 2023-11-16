;/////////////////// ATTACK 2 2: EL ENEMIGO DISTRIBUYE LOS DEMAS GOLPES ////////////////////////
(defmodule attack-2-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Enemy chooses how to distrubute the spare strikes))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule enemy-select-strike (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase attack-2-2))
    	(player ?p)
		(object (is-a EP-attack) (type ONGOING) (fell ?fell) (attackable ?at))
		(object (is-a ATTACKABLE) (name ?at) (strikes ?strikes&:(< 0 ?strikes)))
		(object (is-a CHARACTER) (name ?char))
		(in (over ?fell) (under ?char))
		(not (object (is-a E-select-strike) (char ?char)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def select-strike)
		(description (sym-cat "Assign strike from " ?at " to " ?char))
		(data (create$ 
		"( char [" ?char "])" 
		"( attackable [" ?at "])"))
	))
)



(defrule enemy-select-spare-strike (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase attack-2-2))
    	(player ?p)
		(object (is-a EP-attack) (type ONGOING) (fell ?fell) (attackable ?at))
		(object (is-a ATTACKABLE) (name ?at) (strikes ?strikes&:(< 0 ?strikes)))
		(object (is-a CHARACTER) (name ?char))
		(in (over ?fell) (under ?char))
		(not (exists
			(object (is-a CHARACTER) (name ?char1))
			(in (over ?fell) (under ?char1))
			(not (object (is-a E-select-strike) (char ?char)))
		))
	)
	=>
	(assert (action ;TODO: hacer que este golpe esté a -1 de prowess el char
		(player ?p)
		(event-def select-strike)
		(description (sym-cat "Assign spare strike from " ?at " to " ?char))
		(data (create$ 
		"( char [" ?char "])" 
		"( attackable [" ?at "])"))
	))
)