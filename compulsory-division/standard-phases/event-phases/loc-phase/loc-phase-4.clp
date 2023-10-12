;/////////////////// LOCATION PHASE 4: FIN FASE LUGARES ////////////////////////
(defmodule loc-phase-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Final fase de lugares))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule end-loc-phase (declare (salience ?*action-population-salience*))
	?ep<-(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell) (loc ?loc))
	=>
	(send ?ep complete)
	(debug Final fase de lugares de ?fell en ?loc)
)