;/////////////////// FACTION PLAY 1 1: EJECUCION LANZAR DADOS CHEQUEO DE INFLUENCIA ////////////////////////
(defmodule faction-play-1-1 (import MAIN ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Ejecucion lanzar dados para el chequeo de influencia))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule dice-roll
	=>
	(assert (dices (+ (random 1 6) (random 1 6))))
)