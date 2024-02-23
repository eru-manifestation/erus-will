;/////////////////// STANDARIZE HAND 0: ROBAR O DESCARTAR HASTA TENER 8 ////////////////////////
(defmodule standarize-hand-0 (import MAIN ?ALL))
(deftemplate data (multislot data))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Jugar o robar hasta tener 8 cartas))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; Roba las cartas que necesites
(defrule card-draw
	(data (data target ?p))
	(object (is-a PLAYER) (name ?p) (hand ?hand&:(< ?hand 8)))
	=>
	(make-instance (gen-name E-phase) of E-phase 
		(reason draw standarize-hand::card-draw) 
		(data (str-cat "target [" ?p "]") (str-cat "ammount " (- 8 ?hand)))
	)
	; (make-instance (gen-name E-player-draw) of E-player-draw (player ?p) (draw-ammount (- 8 ?hand)))
)


; ACCION descartar una desde la mano
(defrule action-card-discard-from-hand (declare (salience ?*action-population*))
	(logical
		;(only-actions (phase standarize-hand-0))
		(object (is-a E-phase) (state EXEC) (reason standarize-hand))
		(target ?p)
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
			DISCARD FROM-HAND standarize-hand-0::action-card-discard-from-hand))
		(blocking TRUE)
	))
)