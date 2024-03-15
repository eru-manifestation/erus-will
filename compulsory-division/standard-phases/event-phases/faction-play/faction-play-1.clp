(defmodule faction-play-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule tap-character
	(data (phase faction-play) (data character ?char))
	=>
	(message "Se gira el personaje " ?char " para intentar influenciar")
	(E-modify ?char state TAPPED faction-play-1::tap-character)
)