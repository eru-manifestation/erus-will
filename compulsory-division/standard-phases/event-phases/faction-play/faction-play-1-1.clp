;/////////////////// FACTION PLAY 1 1: EJECUCION LANZAR DADOS CHEQUEO DE INFLUENCIA ////////////////////////
(defmodule faction-play-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Ejecucion lanzar dados para el chequeo de influencia))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule dice-roll
	?ep<-(object (is-a EP-faction-play) (type ONGOING))
	=>
	(send ?ep put-dices (+ (random 1 6) (random 1 6)))
)