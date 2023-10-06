;/////////////////// LOCATION PHASE 1 2: JUGAR OBJETO, FACCION O ALIADO SI ES POSIBLE ////////////////////////
(defmodule loc-phase-1-2 (import MAIN ?ALL))
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



(defrule play-item
	(logical
		(only-actions (phase loc-phase-1-2))
		(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell) (loc ?loc))
		(object (is-a LOCATION) (name ?loc) (state UNTAPPED) (playable-items $? ?item-type $?))
		(object (is-a ?item-type) (player ?p&:(eq ?p ?*player*)) (state HAND) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def item-play)
		(description (sym-cat "Play item " ?item " under " ?char " in " ?loc))
		(data (create$ 
		"( item [" ?item "])" 
		"( owner ["?char "])")
		"( loc ["?loc "])"))
	)
)