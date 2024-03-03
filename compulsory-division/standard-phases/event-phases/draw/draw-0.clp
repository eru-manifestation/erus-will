;/////////////////// DRAW 0: ROBAR n ////////////////////////
(defmodule draw-0 (import MAIN ?ALL))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; Roba las cartas que necesites
(defrule card-draw
    (data (phase draw) (data target ?p))
    ?a <- (data (phase draw) (data ammount ?n&:(< 0 ?n)))
    (object (is-a CARD) (position ?hand&:(eq ?hand (drawsymbol ?p))) 
        (name ?card))
	=>
	; TODO: ESCOGE LOS PRIMEROS QUE SEAN, NO ES ALEATORIO
    (retract ?a)
    (assert (data (phase draw) (data ammount (- ?n 1))))
    (E-modify ?card position (handsymbol ?p) DRAW draw-0::card-draw)
    (message "El jugador " ?p " roba " ?card)
)