;/////////////////// FELLWOSHIP MOVE 3 3: EL ENEMIGO ELIGE SI ROBAR ////////////////////////
(defmodule fell-move-3-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Enemy decides whether to draw, if possible))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


; ACCION: seguir robando mientras se pueda y quiera
(defrule action-enemy-draw
    (logical
		(only-actions (phase fell-move-3-3))
    	(enemy ?enemy)
		(object (is-a EP-fell-move) (type ONGOING) (name ?e) (enemy-draw ?pd&:(< 0 ?pd)))
	)
    =>
    (assert (action 
		(player ?enemy)
		(event-def fell-move-enemy-draw)
		(description (sym-cat "Draw 1"))
		(identifier (drawsymbol ?enemy))
		(data (create$ 
		"( fell-move [" ?e "])"))
	))
)