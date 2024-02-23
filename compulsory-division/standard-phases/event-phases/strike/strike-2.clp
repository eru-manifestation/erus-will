;/////////////////// STRIKE 2: JUGAR RECURSOS QUE MODIFIQUEN EL GOLPE ////////////////////////
(defmodule strike-2 (import MAIN ?ALL) (import strike-1-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

