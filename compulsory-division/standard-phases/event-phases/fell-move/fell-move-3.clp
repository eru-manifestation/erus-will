(defmodule fell-move-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule both-draw-one#player
	?e <- (object (is-a EP-fell-move) (active TRUE) (player-draw ?n&:(< 0 ?n)) (name ?fm))
    (not (object (is-a EP-draw) (position ?e) (reason fell-move-3-1::both-draw-one#player)))
    (player ?p)
    =>
    (make-instance (gen-name EP-draw) of EP-draw
        (reason fell-move-3-1::both-draw-one#player)
        (target ?p)
        (ammount 1)
    )
)

(defrule both-draw-one#enemy
	?e <- (object (is-a EP-fell-move) (active TRUE) (enemy-draw ?n&:(< 0 ?n)) (name ?fm))
    (not (object (is-a EP-draw) (position ?e) (reason fell-move-3-1::both-draw-one#enemy)))
    (enemy ?p)
    =>
    (make-instance (gen-name EP-draw) of EP-draw
        (reason fell-move-3-1::both-draw-one#enemy)
        (target ?p)
        (ammount 1)
    )
)