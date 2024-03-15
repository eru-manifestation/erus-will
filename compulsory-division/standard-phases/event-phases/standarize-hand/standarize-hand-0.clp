(defmodule standarize-hand-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; Roba las cartas que necesites
(defrule card-draw
	(data (phase standarize-hand) (data target ?p))
	(object (is-a PLAYER) (name ?p) (hand ?hand&:(< ?hand 8)))
	=>
	(make-instance (gen-name E-phase) of E-phase 
		(reason draw standarize-hand::card-draw) 
		(data target ?p / ammount (- 8 ?hand))
	)
)


; ACCION descartar una desde la mano
(defrule a-card-discard-from-hand (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
		(data (phase standarize-hand) (data target ?p))
		(object (is-a PLAYER) (name ?p) (hand ?hand&:(> ?hand 8)))
		(object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Discard card " ?c " from player " ?p "'s hand"))
		(identifier ?c (discardsymbol ?p))
		(data (create$ ?c position (discardsymbol ?p)
			DISCARD FROM-HAND standarize-hand-0::a-card-discard-from-hand))
		(blocking TRUE)
	))
)