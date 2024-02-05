;/////////////////// REORGANIZE ITEMS BEFORE DISCARDING ////////////////////////
(defmodule char-discard-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Reasignacion de los objetos y seguidores del personaje descartado))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule unfollow
	(object (is-a EP-char-discard) (type ONGOING) (char ?char))
	(object (is-a CHARACTER) (name ?char))
	(object (is-a CHARACTER) (name ?follower))
	(in (over ?char) (under ?follower))

	(object (is-a FELLOWSHIP) (name ?fell))
	(in (transitive FALSE) (over ?fell) (under ?char))
	=>
	(make-instance (gen-name E-char-unfollow) of E-char-unfollow (follower ?follower) (fell ?fell))
)


(defrule action-reassign-objects (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase char-discard-1))
		(object (is-a EP-char-discard) (type ONGOING) (char ?char))

		(object (is-a CHARACTER) (name ?char) (player ?p))

		(object (is-a ITEM) (name ?item) (player ?p))
		(in (transitive FALSE) (over ?char) (under ?item))

		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
		(in (over ?fell) (under ?char))

		(object (is-a CHARACTER) (name ?newOwner&:(neq ?char ?newOwner))
			(state UNTAPPED | TAPPED) (player ?p)
		)
		(in (over ?fell) (under ?newOwner))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def item-transfer)
		(description (sym-cat "Transfer item " ?item " from " ?char " to " ?newOwner " before discarding it"))
		(identifier ?item ?newOwner)
		(data (create$ 
		"( item [" ?item "])" 
		"( disposer [" ?char "])"
		"( receiver [" ?newOwner "])")))
	)
)