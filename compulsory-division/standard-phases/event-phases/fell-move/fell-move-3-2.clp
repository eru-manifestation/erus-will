;/////////////////// FELLWOSHIP MOVE 3 2: EL JUGADOR ELIGE SI ROBAR ////////////////////////
(defmodule fell-move-3-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Player decides whether to keep drawing, if possible))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCION: seguir robando mientras se pueda y quiera
(defrule action-player-draw
    (logical
		(only-actions (phase fell-move-3-2))
    	(player ?p)
		(object (is-a EP-fell-move) (type ONGOING) (name ?e) (player-draw ?pd&:(< 0 ?pd)))
	)
    =>
    (assert (action 
		(player ?p)
		(event-def fell-move-player-draw)
		(description (sym-cat "Draw 1"))
		(identifier DRAW)
		(data (create$ 
		"( fell-move [" ?e "])"))
	))
)