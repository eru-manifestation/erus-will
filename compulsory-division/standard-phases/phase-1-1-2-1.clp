;/////////////////////// FASE 1 1 2 1: TODO: CAMBIAR NOMBRE -> INICIO DECLARAR MOVIMIENTO ///////////////////////
(defmodule P-1-1-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule a-fell-decl-remain (declare (salience ?*a-population*))
    (player ?p)

	; Hay una compañía que no tiene declarado movimiento ni permanencia
	(object (is-a FELLOWSHIP) (name ?fell) (player ?p) (empty FALSE) (position ?loc))
	(not (data (phase turn) (data move ?fell $?)))
	(not (data (phase turn) (data remain ?fell $?)))
	
	(object (is-a E-phase) (state EXEC) (reason turn $?))
	=>
	(assert (data (phase turn) (data remain ?fell)))
	(message "La compañia " ?fell " permanecera en " ?loc)
)