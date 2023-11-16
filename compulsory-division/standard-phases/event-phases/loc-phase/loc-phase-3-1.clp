;/////////////////// LOCATION PHASE 3 1: JUGAR OBJETO MENOR ADICIONAL ////////////////////////
(defmodule loc-phase-3-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Play additional minor item))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule play-additional-minor-item (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase loc-phase-3-1))
    	(player ?p)
		(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell))
		(object (is-a MINOR-ITEM) (player ?p) (state HAND) (name ?item))
		(object (is-a CHARACTER) (player ?p) (state UNTAPPED) (name ?char))
		(in (over ?fell) (under ?char))
		(not (object (is-a E-item-play-only-minor)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def E-item-play-only-minor)
		(description (sym-cat "Play additional minor item " ?item " under " ?char))
		(identifier ?item ?char)
		(data (create$ 
		"( item [" ?item "])" 
		"( owner ["?char "])")))
	)
)