;/////////////////// FELLWOSHIP MOVE 3 2: EL JUGADOR ELIGE SI ROBAR ////////////////////////
(defmodule fell-move-3-2 (import MAIN ?ALL) (import fell-move-3-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Player decides whether to keep drawing, if possible))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCION: seguir robando mientras se pueda y quiera
(defrule action-player-draw
    (logical
		(player ?p)
		?f <- (draw-ammount ? ?p)
		(object (is-a E-phase) (state EXEC) (reason fell-move $?))
		; (only-actions (phase fell-move-3-2))		
	)
    =>
    (assert (action 
		(player ?p)
		(event-def varswap)
		(description (sym-cat "Draw 1"))
		(identifier (drawsymbol ?p))
		(data (create$ ?f draw ?p))
	))
)


(defrule exec-player-draw
	?f <- (draw ?p)
	=>
	(retract ?f)
	(make-instance (gen-name E-phase) of E-phase
		(reason draw fell-move-3-2::exec-player-draw)
		(data (str-cat "target " ?p) "ammount 1"))
)