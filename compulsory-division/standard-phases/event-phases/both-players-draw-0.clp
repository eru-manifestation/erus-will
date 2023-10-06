;/////////////////// BOTH PLAYERS DRAW 0: FIN ROBAR ////////////////////////
(defmodule both-players-draw-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Fin robar))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))


(defrule end-draw (declare (salience ?*event-handler-salience*))
	?ep<-(object (is-a EP-both-players-draw) (type ONGOING))
	=>
	(send ?ep complete)
)