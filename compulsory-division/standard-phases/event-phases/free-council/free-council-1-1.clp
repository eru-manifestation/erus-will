;/////////////////////// FREE COUNCIL 1 1: ENEMIGO REALIZA CHEQUEO DE CORRUPCION EN SUS PERSONAJES ///////////////////////
(defmodule free-council-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Enemigo realiza chequeo de corrupcion de sus personajes))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule enemy-corruption-check
    (enemy ?p)
	(object (is-a CHARACTER) (player ?p) (state UNTAPPED | TAPPED | WOUNDED) (name ?char))
	=>
	(make-instance (gen-name EP-corruption-check) of EP-corruption-check (character ?char))
)
