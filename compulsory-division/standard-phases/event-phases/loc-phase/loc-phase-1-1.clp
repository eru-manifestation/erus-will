;/////////////////// LOCATION PHASE 1 1: EJECUCION ATAQUE AUTOMATICO FASE LUGARES ////////////////////////
(defmodule loc-phase-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Ejecucion ataques automaticos fase lugares))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



(defrule face-automatic-attacks
	(object (is-a EP-loc-phase) (type ONGOING) (fell ?fell) (loc ?loc))
	(object (is-a LOCATION) (name ?loc) (automatic-attacks $? ?attack $?))
	=>
	(make-instance (gen-name EP-attack) of EP-attack (fell ?fell) (attackable ?attack))
)