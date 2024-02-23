;/////////////////// FACTION PLAY 2 1: EJECUCION RESOLVER CHEQUEO DE INFLUENCIA ////////////////////////
(defmodule faction-play-2-1 (import MAIN ?ALL) (import faction-play-1-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule influence-check
	;?ep<-(object (is-a EP-faction-play) (type ONGOING) (dices ?dices) (faction ?faction) (char ?char) (loc ?loc))
	(dices ?dices)
	(faction ?faction)
	(character ?char)
	=>
	(bind ?favor (+ (send ?char get-influence) ?dices))
	(bind ?against (send ?faction get-influence-check))

	(if (< ?against ?favor) then
		(message "Chequeo de influencia de " ?char " para " ?faction " conseguido con " ?favor " de " ?against " necesarios")
		else
		(assert (failed))
		(message "Chequeo de influencia de " ?char " para " ?faction " fallido con " ?favor " de " ?against " necesarios")
	)
)
(defrule check-failed
	(failed)
	(object (is-a E-phase) (state EXEC) (name ?e))
	=>
	;	TODO: optimizar los E-cancel para que funcionen con un defglobal
	(E-cancel ?e faction-play-2-1::check-failed)
)