;/////////////////// LOCATION PHASE 2 1: JUGAR OBJETO, FACCION O ALIADO SI ES POSIBLE ////////////////////////
(defmodule loc-phase-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule play-item#minor (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
		(data (phase loc-phase) (data fellowship ?fell))
		(object (is-a LOCATION) (name ?loc&:(eq ?loc (send ?fell get-position)))
			(state UNTAPPED) (playable-items $? MINOR-ITEM $?))
		(object (is-a MINOR-ITEM) (player ?p) 
			(position ?pos&:(eq ?pos (handsymbol ?p))) (name ?item))
		(object (is-a CHARACTER) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play minor item " ?item " under " ?char " in " ?loc))
		(identifier ?item ?char)
		(data (create$ ?item position ?char PLAY ITEM loc-phase-2-1::play-item#minor))
	))
)



(defrule play-item#greater (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
		(data (phase loc-phase) (data fellowship ?fell))
		(object (is-a LOCATION) (name ?loc&:(eq ?loc (send ?fell get-position)))
			(state UNTAPPED) (playable-items $? GREATER-ITEM $?))
		(object (is-a GREATER-ITEM) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play greater item " ?item " under " ?char " in " ?loc))
		(identifier ?item ?char)
		(data (create$ ?item position ?char 
			PLAY ITEM loc-phase-2-1::play-item#greater))
	))
)



(defrule play-item#major (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
		(data (phase loc-phase) (data fellowship ?fell))
		(object (is-a LOCATION) (name ?loc&:(eq ?loc (send ?fell get-position)))
			(state UNTAPPED) (playable-items $? MAJOR-ITEM $?))
		(object (is-a MAJOR-ITEM) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play major item " ?item " under " ?char " in " ?loc))
		(identifier ?item ?loc)
		(data (create$ ?item position ?char 
			PLAY ITEM loc-phase-2-1::play-item#major))
	))
)



(defrule play-ally (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
		(data (phase loc-phase) (data fellowship ?fell))
		(object (is-a LOCATION) (name ?loc&:(eq ?loc (send ?fell get-position)))
			(state UNTAPPED))
		(object (is-a ALLY) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (playable-places $? ?loc $?) (name ?ally))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play ally " ?ally " under " ?char " in " ?loc))
		(identifier ?ally ?char)
		(data (create$ ?ally position ?char
			PLAY ALLY loc-phase-2-1::play-ally))
	))
)



(defrule play-faction (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
		(data (phase loc-phase) (data fellowship ?fell))
		(object (is-a LOCATION) (name ?loc&:(eq ?loc (send ?fell get-position)))
			(state UNTAPPED))
		(object (is-a FACTION) (player ?p) 
			(position ?pos&:(eq ?pos (handsymbol ?p))) 
			(playable-places $? ?loc $?) (name ?faction))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def phase)
		(description (sym-cat "Influence faction " ?faction " with " ?char " in " ?loc))
		(identifier ?faction ?char)
		(data (create$ "faction-play loc-phase-2-1::play-faction"
			character ?char / faction ?faction)))
	)
)