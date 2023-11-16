;/////////////////////// FREE COUNCIL 2 1: NOMBRAMIENTO DEL VENCEDOR ///////////////////////
(defmodule free-council-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Nombramiento del vencedor del concilio))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule declare-winner
    (player ?p)
    (enemy ?e)
	=>		
	(halt)
	(if (< (send ?p get-mp) (send ?e get-mp)) then
		(debug THE WINNER OF THE COUNCIL IS ?p)
		else
		(if (< (send ?p get-mp) (send ?e get-mp)) then
			(debug THE WINNER OF THE COUNCIL IS ?e)
			else
			(debug THERE IS A TIE)
		)
	)
)
