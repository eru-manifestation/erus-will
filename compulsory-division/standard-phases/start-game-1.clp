;/////////////////// INICIA EL JUEGO 1: LOS DOS ROBAN HASTA TENER 8 CARTAS ////////////////////////
(defmodule start-game-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Se roba hasta tener 8))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule both-players-draw
	=>
	(make-instance (gen-name EP-both-players-draw) of EP-both-players-draw)
)