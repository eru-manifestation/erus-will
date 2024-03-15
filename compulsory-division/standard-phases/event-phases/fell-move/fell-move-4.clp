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
		?f <- (data (phase fell-move) (data draw-ammount ? ?p))
		(object (is-a E-phase) (state EXEC))
	)
    =>
    (assert (action 
		(player ?p)
		(event-def phase)
		(initiator ?f)
		(description (sym-cat "Draw 1"))
		(identifier (drawsymbol ?p))
		(data (create$ "draw fell-move-4::a-player-draw"
			target ?p / ammount 1))
	))
)