(defmodule fell-move-5 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCION: seguir robando mientras se pueda y quiera
(defrule a-enemy-draw
    (logical
		(enemy ?enemy)
		(object (is-a EP-fell-move) (state EXEC) (enemy-draw ?n&:(< 0 ?n)))
	)
    =>
    (assert (action 
		(player ?enemy)
		(event-def draw)
		(description (sym-cat "Draw 1"))
		(identifier (drawsymbol ?enemy))
		(data "(target [" ?enemy "]) (ammount " 1")")
		(reason fell-move-5::a-enemy-draw)
	))
)