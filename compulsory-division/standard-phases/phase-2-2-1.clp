;////////////////// Fase 2 2 1: EJECUCION JUGAR RECURSOS SUCESOS DURADEROS ////////////////////////
(defmodule P-2-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Jugar recursos suceso duradero))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))

; ACCIÓN: JUGAR RECURSOS DE SUCESOS DURADEROS
(defrule action-long-event-play (declare (salience ?*action-population-salience*))
	(logical
		; Dado un suceso duradero en la mano del jugador
		(object (is-a R-LONG-EVENT) (name ?rle) (player ?p&:(eq ?p ?*player*))
			(state HAND))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def r-long-event-play)
		(description (sym-cat "Play long event resource " ?rle))
		(data (create$ "( r-long-event [" ?rle "])"))
	))
)
