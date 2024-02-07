;/////////////////// FACTION PLAY 2 1: EJECUCION RESOLVER CHEQUEO DE INFLUENCIA ////////////////////////
(defmodule faction-play-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Se resuelve el chequeo de influencia))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule influence-check (declare (salience ?*event-handler-salience*))
	?ep<-(object (is-a EP-faction-play) (type ONGOING) (dices ?dices) (faction ?faction) (char ?char) (loc ?loc))
	=>
	(if (< (send ?faction get-influence-check) (+ (send ?char get-influence) ?dices)) then
		(send ?faction put-position (mpsymbol (send ?faction get-player)))
		(send ?loc modify state TAPPED)
		(debug Chequeo de influencia de ?char para ?faction conseguido con (+ (send ?char get-influence) ?dices) de (send ?faction get-influence-check) necesarios)
		else
		(send ?faction put-position (send ?faction get-player))
		(debug Chequeo de influencia de ?char para ?faction fallido con (+ (send ?char get-influence) ?dices) de (send ?faction get-influence-check) necesarios)
	)
	(send ?ep complete)
)