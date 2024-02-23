;/////////////////// FELLWOSHIP MOVE 4 1: EL ENEMIGO JUEGA ADVERSIDADES ////////////////////////
(defmodule fell-move-4-1 (import MAIN ?ALL) (import fell-move-3-3 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule action-play-creature#by-regions (declare (salience ?*action-population*))
	(logical
		(object (is-a E-phase) (state EXEC) (reason fell-move $?))
    	(enemy ?p)
		(fellowship ?fell)
		(route $? ?region ?n&:(numberp ?n) $?)
		;?ep <- (object (is-a EP-fell-move) (type ONGOING) (fell ?fell) (route $? ?region ?n&:(numberp ?n) $?))
		(object (is-a CREATURE) (player ?p) 
			(regions $? ?region ?n2&:(<= ?n2 ?n) $?)
			(position ?pos&:(eq ?pos (handsymbol ?p))) (name ?creature))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play creature " ?creature " to attack " ?fell " in " ?region " region"))
		(identifier ?creature ?fell)
		(data (create$ ?creature position ?fell 
			PLAY CREATURE REGION ?region ?n2 fell-move-4-1::action-play-creature#by-regions))
	))
)



(defrule action-play-creature#by-place (declare (salience ?*action-population*))
	(logical
		(object (is-a E-phase) (state EXEC) (reason fell-move $?))
    	(enemy ?p)
		(fellowship ?fell)
		(to ?to)
		(object (is-a CREATURE) (player ?p) 
			(position ?pos&:(eq ?pos (handsymbol ?p))) 
			(places $? ?place&:(eq ?place (send ?to get-place)) $?) (name ?creature))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play creature " ?creature " to attack " ?fell " in " ?place " place"))
		(identifier ?creature ?fell)
		(data (create$ ?creature position ?fell
			PLAY CREATURE PLACE ?place fell-move-4-1::action-play-creature#by-place))
	))
)