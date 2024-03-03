;/////////////////// FELLWOSHIP MOVE 3 2: EL JUGADOR ELIGE SI ROBAR ////////////////////////
(defmodule fell-move-3-2 (import MAIN ?ALL) (import fell-move-3-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCION: seguir robando mientras se pueda y quiera
(defrule action-player-draw
    (logical
		(player ?p)
		?f <- (data (phase fell-move) (data draw-ammount ? ?p))
		(object (is-a E-phase) (state EXEC) (reason fell-move $?))
	)
    =>
    (assert (action 
		(player ?p)
		(event-def variable)
		(initiator ?f)
		(description (sym-cat "Draw 1"))
		(identifier (drawsymbol ?p))
		(data (create$ draw ?p))
	))
)


(defrule exec-player-draw
	?f <- (data (phase fell-move) (data draw ?p))
	=>
	(retract ?f)
	(make-instance (gen-name E-phase) of E-phase
		(reason draw fell-move-3-2::exec-player-draw)
		(data target ?p / ammount 1))
)