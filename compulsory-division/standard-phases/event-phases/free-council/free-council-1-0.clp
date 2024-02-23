;/////////////////////// FREE COUNCIL 1 0: JUGADOR REALIZA CHEQUEO DE CORRUPCION EN SUS PERSONAJES ///////////////////////
(defmodule free-council-1-0 (import MAIN ?ALL) (export ?ALL))
(deftemplate data (multislot data))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule player-corruption-check
    (player ?p)
	(object (is-a CHARACTER) (player ?p) (state UNTAPPED | TAPPED | WOUNDED) (name ?char))
	=>
	(make-instance (gen-name E-phase) of E-phase
		(reason corruption-check free-council-1-0::player-corruption-check)
		(data (str-cat "target [" ?char "]")))
	;(make-instance (gen-name EP-corruption-check) of EP-corruption-check (character ?char))
)
