(defmodule faction-play-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule dice-roll
	=>
	(E-roll-dices faction-influence-roll faction-play-3::dice-roll)
)


(defrule influence-check
	(object (is-a EP-faction-influence-roll) (state DONE) (res ?dices))
	(object (is-a EP-faction-play) (active TRUE) (faction ?faction) (character ?char))
	=>
	(bind ?favor (+ (send ?char get-influence) ?dices))
	(bind ?against (send ?faction get-influence-check))

	(if (< ?against ?favor) then
		(message "Chequeo de influencia de " ?char " para " ?faction " conseguido con " ?favor " de " ?against " necesarios")
		(complete SUCCESSFUL)
		else
		(message "Chequeo de influencia de " ?char " para " ?faction " fallido con " ?favor " de " ?against " necesarios")
		(complete UNSUCCESSFUL)
	)
)