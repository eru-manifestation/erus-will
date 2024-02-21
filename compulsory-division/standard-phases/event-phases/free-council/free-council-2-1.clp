;/////////////////////// FREE COUNCIL 2 1: NOMBRAMIENTO DEL VENCEDOR ///////////////////////
(defmodule free-council-2-1 (import MAIN ?ALL) (import free-council-1-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(message Nombramiento del vencedor del concilio))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule declare-winner
    (player ?p)
    (enemy ?e)
	=>		
	(halt)
	(if (< (send ?p get-mp) (send ?e get-mp)) then
		(message "THE WINNER OF THE COUNCIL IS " ?p)
		else
		(if (< (send ?p get-mp) (send ?e get-mp)) then
			(message "THE WINNER OF THE COUNCIL IS " ?e)
			else
			(message "THERE IS A TIE")
		)
	)
)
