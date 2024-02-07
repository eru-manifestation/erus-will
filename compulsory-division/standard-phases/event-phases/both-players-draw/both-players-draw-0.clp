;/////////////////// BOTH PLAYERS DRAW 0: ROBAR O DESCARTAR HASTA TENER 8 ////////////////////////
(defmodule both-players-draw-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Ambos jugadores descartan o roban hasta tener 8 cartas))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; Roba las cartas que necesites
(defrule card-draw (declare (salience ?*action-population-salience*))
	(object (is-a PLAYER) (name ?p) (hand ?hand&:(< ?hand 8)))
	=>
	(make-instance (gen-name E-player-draw) of E-player-draw (player ?p) (draw-ammount (- 8 ?hand)))
)


; ACCION descartar una desde la mano
(defrule action-card-discard-from-hand (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase both-players-draw-0))
		(object (is-a PLAYER) (name ?p) (hand ?hand&:(> ?hand 8)))
		(object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def player-discard-from-hand)
		(description (sym-cat "Discard card " ?c " from player " ?p "'s hand"))
		(identifier ?c (discardsymbol ?p))
		(data (create$ 
		"( card [" ?c "])" 
		"( player [" ?p "])"))
		(blocking TRUE)
	))
)