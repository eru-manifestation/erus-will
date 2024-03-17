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
		?f <- (data (phase fell-move) (data draw-ammount ? ?enemy))
		(object (is-a E-phase) (state EXEC))
	)
    =>
    (assert (action 
		(player ?enemy)
		(event-def variable)
		(initiator ?f)
		(description (sym-cat "Draw 1"))
		(identifier (drawsymbol ?enemy))
		(data (create$ draw ?enemy))
		(reason draw fell-move-5::a-enemy-draw)
	))
)