;/////////////////////// CORRUPTION CHECK 1 1 1: EJECUCION LANZAR DADOS PARA EL CHEQUEO DE CORRUPCION ///////////////////////
(defmodule corruption-check-1-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Ejecucion lanzar dados chequeo corrupcion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices
	?ep <- (object (is-a EP-corruption-check) (type ONGOING))
	=>
	(send ?ep put-dices (+ (random 1 6) (random 1 6)))
)