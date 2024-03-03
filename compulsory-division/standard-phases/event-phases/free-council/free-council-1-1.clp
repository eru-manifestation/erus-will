;/////////////////////// FREE COUNCIL 1 1: ENEMIGO REALIZA CHEQUEO DE CORRUPCION EN SUS PERSONAJES ///////////////////////
(defmodule free-council-1-1 (import MAIN ?ALL) (import free-council-1-0 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule enemy-corruption-check
    (enemy ?p)
	(object (is-a CHARACTER) (player ?p) (state UNTAPPED | TAPPED | WOUNDED) (name ?char))
	=>
	(make-instance (gen-name E-phase) of E-phase
		(reason corruption-check free-council-1-0::player-corruption-check)
		(data target ?char))
)
