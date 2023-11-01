;/////////////////// FELLWOSHIP MOVE 2: REVELAR MOVIMIENTO AL OPONENTE ////////////////////////
(defmodule fell-move-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Revelar movimiento))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule reveal-move 
    (enemy ?enemy)
    (object (is-a EP-fell-move) (type ONGOING) (fell ?fell) (from ?from) (to ?to&:(neq ?to ?from)))
    =>
    (announce ?enemy Fellowship ?fell is moving from ?from to ?to))