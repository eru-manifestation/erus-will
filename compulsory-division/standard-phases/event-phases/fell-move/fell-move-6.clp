(defmodule fell-move-6 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule a-play-creature#by-regions (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(enemy ?p)
		(data (phase fell-move) (data fellowship ?fell))
		(data (phase fell-move) (data route $? ?region ?n&:(numberp ?n) $?))
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
		(data (create$ ?creature position ?fell))
		(reason PLAY CREATURE REGION ?region ?n2 fell-move-6::a-play-creature#by-regions)
	))
)



(defrule a-play-creature#by-place (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(enemy ?p)
		(data (phase fell-move) (data fellowship ?fell))
		(data (phase fell-move) (data to ?to))
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
		(data (create$ ?creature position ?fell))
		(reason PLAY CREATURE PLACE fell-move-6::a-play-creature#by-place)
	))
)