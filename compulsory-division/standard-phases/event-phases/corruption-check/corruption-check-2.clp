;/////////////////////// CORRUPTION CHECK 2: FIN CHEQUEO DE CORRUPCION ///////////////////////
(defmodule corruption-check-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Fin chequeo corrupcion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule fin-chequeo
	?ep <- (object (is-a EP-corruption-check) (type ONGOING) (character ?char) (dices ?dices))
	=>
	(send ?ep complete)

	(debug Termina el chequeo de corrupcion de ?char con (send ?char get-corruption) corruption tras haber sacado un ?dices)
)