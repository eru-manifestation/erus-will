;/////////////////// FACTION PLAY 3: FINAL JUGAR FACCION ////////////////////////
(defmodule faction-play-3 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Final de jugar faccion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule end-play-faction (declare (salience ?*event-handler-salience*))
	?ep<-(object (is-a EP-faction-play) (type ONGOING) (faction ?faction) (char ?char))
	=>
	(debug Finaliza el intento de ?char de jugar la faccion ?faction)
)