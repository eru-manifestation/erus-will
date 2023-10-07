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
	=>
	(if (< (send ?*player* get-mp) (send ?*enemy* get-mp)) then
		(halt)
		(debug THE WINNER OF THE COUNCIL IS ?*player*)
		else
		(if (< (send ?*player* get-mp) (send ?*enemy* get-mp)) then
			(halt)
			(debug THE WINNER OF THE COUNCIL IS ?*enemy*)
			else
			(halt)
			(debug THERE IS A TIE)
		)
	)
)
