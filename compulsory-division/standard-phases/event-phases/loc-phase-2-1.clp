;/////////////////// LOCATION PHASE 2 1: JUGAR OBJETO, FACCION O ALIADO SI ES POSIBLE ////////////////////////
(defmodule loc-phase-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Ejecucion ataques automaticos fase lugares))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule play-item#minor (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase loc-phase-2-1))
		(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell) (loc ?loc))
		(object (is-a LOCATION) (name ?loc) (state UNTAPPED) (playable-items $? MINOR-ITEM $?))
		(object (is-a MINOR-ITEM) (player ?p&:(eq ?p ?*player*)) (state HAND) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def item-play)
		(description (sym-cat "Play minor item " ?item " under " ?char " in " ?loc))
		(data (create$ 
		"( item [" ?item "])" 
		"( owner ["?char "])"
		"( loc ["?loc "])")))
	)
)



(defrule play-item#greater (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase loc-phase-2-1))
		(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell) (loc ?loc))
		(object (is-a LOCATION) (name ?loc) (state UNTAPPED) (playable-items $? GREATER-ITEM $?))
		(object (is-a GREATER-ITEM) (player ?p&:(eq ?p ?*player*)) (state HAND) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def item-play)
		(description (sym-cat "Play greater item " ?item " under " ?char " in " ?loc))
		(data (create$ 
		"( item [" ?item "])" 
		"( owner ["?char "])"
		"( loc ["?loc "])")))
	)
)



(defrule play-item#major (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase loc-phase-2-1))
		(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell) (loc ?loc))
		(object (is-a LOCATION) (name ?loc) (state UNTAPPED) (playable-items $? MAJOR-ITEM $?))
		(object (is-a MAJOR-ITEM) (player ?p&:(eq ?p ?*player*)) (state HAND) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def item-play)
		(description (sym-cat "Play major item " ?item " under " ?char " in " ?loc))
		(data (create$ 
		"( item [" ?item "])" 
		"( owner ["?char "])"
		"( loc ["?loc "])")))
	)
)



(defrule play-ally (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase loc-phase-2-1))
		(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell) (loc ?loc))
		(object (is-a LOCATION) (name ?loc) (state UNTAPPED))
		(object (is-a ALLY) (player ?p&:(eq ?p ?*player*)) (state HAND) (playable-places $? ?loc $?) (name ?ally))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def ally-play)
		(description (sym-cat "Play ally " ?ally " under " ?char " in " ?loc))
		(data (create$ 
		"( ally [" ?ally "])" 
		"( char ["?char "])"
		"( loc ["?loc "])")))
	)
)



(defrule play-faction (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase loc-phase-2-1))
		(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell) (loc ?loc))
		(object (is-a LOCATION) (name ?loc) (state UNTAPPED))
		(object (is-a FACTION) (player ?p&:(eq ?p ?*player*)) (state HAND) (playable-places $? ?loc $?) (name ?faction))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def faction-play)
		(description (sym-cat "Influence faction " ?faction " with " ?char " in " ?loc))
		(data (create$ 
		"( faction [" ?faction "])" 
		"( char ["?char "])"
		"( loc ["?loc "])")))
	)
)