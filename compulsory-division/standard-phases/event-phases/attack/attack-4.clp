;/////////////////// ATTACK 4: DECLARAR RESULTADO DEL ATAQUE ////////////////////////
(defmodule attack-4 (import MAIN ?ALL) (import attack-3 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message Declare the result of the attack))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))




(defrule declare-result#defeated
	;?ep-at <- (object (is-a EP-attack) (type ONGOING))
	;(not (object (is-a EP-strike) (state SUCCESSFUL | UNDEFEATED)))
	(not (object (is-a E-phase) (reason strike $?) (state DEFUSED)))
	; Considero DEFUSED si el golpe no se considera superado por algun motivo. Considero DONE cuando se ha conseguido superar el golpe
	; TODO: datos de salida en data <_--------------------
	=>
	;(send ?ep-at modify state DEFEATED)
	(message "Todos los golpes han sido superados, el ataque ha sido derrotado")
)



(defrule declare-result#successful
	; ?ep-at <- (object (is-a EP-attack) (type ONGOING))
	; (exists (object (is-a EP-strike) (state ?state&:(neq DEFEATED ?state))))
	(exists (not (object (is-a E-phase) (reason strike $?) (state DEFUSED))))
	(object (is-a E-phase) (state EXEC) (name ?e))
	=>
	; (send ?ep-at modify state UNDEFEATED)
	(E-cancel ?e attack-4::declare-result#successful)
	(message "Como algun golpe no se considera superado, el ataque ha sido exitoso")
)