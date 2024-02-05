;/////////////////// FINALLY DISCARDING THE CHARACTER ////////////////////////
(defmodule char-discard-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Descartar personaje))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule end-char-discard-phase (declare (salience ?*action-population-salience*))
	?ep<-(object (is-a EP-char-discard) (type ONGOING) (char ?char))
	=>
    (send ?ep complete)
    (send ?char modify state DISCARD)

    (debug Discarding character ?char)
)