;/////////////////// STRIKE 4: FIN RESOLUCION DEL GOLPE ////////////////////////
(defmodule strike-4 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug End of strike phase))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))




(defrule end-strike
	(object (is-a EP-strike) (name ?ep) (char ?char) (attackable ?at) (type ONGOING))
	=>
	(send ?ep complete)
	(debug The strike has been (send ?ep get-state) since (send ?ep get-dices) in the roll and ?char has (send ?char get-prowess) prowess and ?at has (send ?at get-prowess) prowess)
)