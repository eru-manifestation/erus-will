;/////////////////////// FREE COUNCIL 1 0: JUGADOR REALIZA CHEQUEO DE CORRUPCION EN SUS PERSONAJES ///////////////////////
(defmodule free-council-1-0 (import MAIN ?ALL))


;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule player-corruption-check
    (player ?p)
	(object (is-a CHARACTER) (player ?p) (state UNTAPPED | TAPPED | WOUNDED) (name ?char))
	=>
	(make-instance (gen-name EP-corruption-check) of EP-corruption-check
		(reason free-council-1-0::player-corruption-check)
		(target ?char))
)
