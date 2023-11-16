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
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule new-turn
	?fp<-(player ?player)
	?fe<-(enemy ?enemy)
	=>
	(retract ?fp ?fe)
	(assert (player ?enemy) (enemy ?player))
	(pop-focus);TODO: FORMALIZAR
	(jump START)
	(debug Start new turn with player: ?enemy and enemy: ?player)
)
