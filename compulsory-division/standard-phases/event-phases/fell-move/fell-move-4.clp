(defmodule fell-move-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCION: seguir robando mientras se pueda y quiera
(defrule a-player-draw
    (logical
		(player ?p)
		(object (is-a EP-fell-move) (state EXEC) (player-draw ?n&:(< 0 ?n)))
	)
    =>
    (assert (action 
		(player ?p)
		(event-def draw)
		(description (sym-cat "Draw 1"))
		(identifier (drawsymbol ?p))
		(data "(target [" ?p "]) (ammount " 1")")
		(reason fell-move-4::a-player-draw)
	))
)