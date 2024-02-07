;/////////////////// FELLWOSHIP MOVE 4 1: EL ENEMIGO JUEGA ADVERSIDADES ////////////////////////
(defmodule fell-move-4-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Enemy plays adversities))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule action-play-creature#by-regions (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase fell-move-4-1))
    	(enemy ?p)
		?ep <- (object (is-a EP-fell-move) (type ONGOING) (fell ?fell) (route $? ?region ?n&:(numberp ?n) $?))
		(object (is-a CREATURE) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?creature) (regions $? ?region ?n2&:(<= ?n2 ?n) $?))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def creature-attack-fell)
		(description (sym-cat "Play creature " ?creature " to attack " ?fell " in " ?region " region"))
		(identifier ?creature ?fell)
		(data (create$ 
		"( creature [" ?creature "])" 
		"( attack-at [" ?region "])" 
		"( fell [" ?fell "])"))
	))
)



(defrule action-play-creature#by-place (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase fell-move-4-1))
    	(enemy ?p)
		?ep <- (object (is-a EP-fell-move) (type ONGOING) (fell ?fell) (to ?to))
		(object (is-a CREATURE) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?creature) 
			(places $? ?place&:(eq ?place (send ?to get-place)) $?))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def creature-attack-fell)
		(description (sym-cat "Play creature " ?creature " to attack " ?fell " in " ?place " place"))
		(identifier ?creature ?fell)
		(data (create$ 
		"( creature [" ?creature "])" 
		"( attack-at [" ?place "])" 
		"( fell [" ?fell "])"))
	))
)