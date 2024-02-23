;/////////////////////// FASE 1 1 2 1: TODO: CAMBIAR NOMBRE -> INICIO DECLARAR MOVIMIENTO ///////////////////////
(defmodule P-1-1-2-1 (import MAIN ?ALL) (import P-1-1-2-0 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule action-fell-decl-remain (declare (salience ?*action-population*))
    (player ?p)

	; Hay una compañía que no tiene declarado movimiento ni permanencia
	(object (is-a FELLOWSHIP) (name ?fell) (player ?p) (empty FALSE) (position ?loc))
	(not (data (data move ?fell $?)))
	(not (data (data remain ?fell $?)))
	
	(object (is-a E-phase) (state EXEC) (reason turn $?))
	=>
	(assert (data (data remain ?fell)))
	(message "La compañia " ?fell " permanecera en " ?loc)
)