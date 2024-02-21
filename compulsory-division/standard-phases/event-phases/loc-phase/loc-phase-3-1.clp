;/////////////////// LOCATION PHASE 3 1: JUGAR OBJETO MENOR ADICIONAL ////////////////////////
(defmodule loc-phase-3-1 (import MAIN ?ALL) (import loc-phase-2-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Play additional minor item))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule play-additional-minor-item (declare (salience ?*action-population*))
	(logical
		(only-actions (phase loc-phase-3-1))
    	(player ?p)
		(fellowship ?fell)
		(object (is-a MINOR-ITEM) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))

		(object (is-a E-modify) (reason $? PLAY ITEM $?) (state DONE))
		(not (object (is-a E-modify) (reason $? loc-phase-3-1::play-additional-minor-item) (state DONE)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play additional minor item " ?item " under " ?char))
		(identifier ?item ?char)
		(data (create$ ?item position ?char PLAY ITEM loc-phase-3-1::play-additional-minor-item))
	))
)