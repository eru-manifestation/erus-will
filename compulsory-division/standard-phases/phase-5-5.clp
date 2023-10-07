;/////////////////////// FASE 5 5: INICIO SIGUIENTE TURNO ///////////////////////
(defmodule P-5-5 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Inicio siguiente turno))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule new-turn
	=>
	(bind ?p1 ?*player*)
	(bind ?*player* ?*enemy*)
	(bind ?*enemy* ?p1)
	(pop-focus)
	(jump START)
	(debug Start new turn with player: ?*player* and enemy: ?*enemy*)
)
