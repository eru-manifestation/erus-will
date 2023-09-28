;/////////////////////// CORRUPTION CHECK 1 1 1: EJECUCION LANZAR DADOS PARA EL CHEQUEO DE CORRUPCION ///////////////////////
(defmodule corruption-check-1-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Ejecucion lanzar dados chequeo corrupcion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))


(defrule throw-dices
	?ep <- (object (is-a EP-corruption-check) (type ONGOING))
	=>
	(send ?ep put-dices (+ (random 1 6) (random 1 6)))
)