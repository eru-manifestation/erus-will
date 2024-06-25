(defmodule fell-move-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule reveal-move 
    (object (is-a EP-fell-move) (active TRUE)  (fellowship ?fell) (to ?to))
    =>
    (phase (str-cat "La compañía " ?fell " parte de camino a " ?to))
)