;/////////////////// FELLWOSHIP MOVE 5 0: INICIO LLEGAR AL LUGAR ////////////////////////
(defmodule fell-move-5-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Start of player getting to the location))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule fell-change-loc (declare (salience ?*action-population-salience*))
	(object (is-a EP-fell-move) (type ONGOING) (fell ?fell) (from ?from) (to ?to))
	=>
	(make-instance (gen-name E-fell-change-loc) of E-fell-change-loc (fell ?fell) (from ?from) (to ?to))
)