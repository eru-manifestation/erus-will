;/////////////////// FELLWOSHIP MOVE 3 3: EL ENEMIGO ELIGE SI ROBAR ////////////////////////
(defmodule fell-move-3-3 (import MAIN ?ALL) (import fell-move-3-2 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Enemy decides whether to draw, if possible))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCION: seguir robando mientras se pueda y quiera
(defrule action-enemy-draw
    (logical
		(enemy ?enemy)
		?f <- (draw-ammount ? ?enemy)
		(object (is-a E-phase) (state EXEC) (reason fell-move $?))
		; (only-actions (phase fell-move-3-3))		
	)
    =>
    (assert (action 
		(player ?enemy)
		(event-def varswap)
		(description (sym-cat "Draw 1"))
		(identifier (drawsymbol ?enemy))
		(data (create$ ?f draw ?enemy))
	))
)


(defrule exec-enemy-draw
	?f <- (draw ?p)
	=>
	(retract ?f)
	(make-instance (gen-name E-phase) of E-phase
		(reason draw fell-move-3-2::exec-enemy-draw)
		(data (str-cat "target " ?p) "ammount 1"))
)