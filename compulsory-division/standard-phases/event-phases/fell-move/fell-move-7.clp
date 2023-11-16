;/////////////////// FELLWOSHIP MOVE 7: FIN FASE MOVIMIENTO ////////////////////////
(defmodule fell-move-7 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Fin fase movimiento))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule fell-move-end
	?ep<-(object (is-a EP-fell-move) (type ONGOING) (fell ?fell) (from ?from) (to ?to))
	=>
	(send ?ep complete)
	(debug Finaliza la fase de movimiento para ?fell desde ?from hasta ?to)
)