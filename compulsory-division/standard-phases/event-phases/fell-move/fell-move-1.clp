;/////////////////// FELLWOSHIP MOVE 2: REVELAR MOVIMIENTO AL OPONENTE ////////////////////////
(defmodule fell-move-1 (import MAIN ?ALL) (export ?ALL))
(deftemplate data (multislot data))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule reveal-move 
    =>
    ;TODO REVELAR
)