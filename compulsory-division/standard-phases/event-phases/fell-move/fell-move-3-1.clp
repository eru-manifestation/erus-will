;/////////////////// FELLWOSHIP MOVE 3 1: AMBOS PERSONAJES ROBAN UNA CARTA ////////////////////////
(defmodule fell-move-3-1 (import MAIN ?ALL) (import fell-move-2 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; Calcula cuantas cartas debe robar cada jugador (no se roba si no se mueve)
(defrule both-draw-one
    ?f <- (data (data draw-ammount ? ?p))
    =>
    (retract ?f)
    (make-instance (gen-name E-phase) of E-phase 
        (reason draw fell-move-3-1::both-draw-one)
        (data (str-cat "target [" ?p "]") "ammount 1")
    )
)