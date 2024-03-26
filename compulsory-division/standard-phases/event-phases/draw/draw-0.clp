(defmodule draw-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; Roba las cartas que necesites
(defrule card-draw
    (object (is-a EP-draw) (active TRUE) (ammount ?n&:(< 0 ?n)) (target ?p))
    (object (is-a CARD) (position ?hand&:(eq ?hand (drawsymbol ?p))) 
        (name ?card))
	=>
	; TODO: ESCOGE LOS PRIMEROS QUE SEAN, NO ES ALEATORIO
    (E-modify ?card position (handsymbol ?p) draw-0::card-draw)
    (message "El jugador " ?p " roba " ?card)
)