;/////////////////////// FASE 1 1 2 1: TODO: CAMBIAR NOMBRE -> INICIO DECLARAR MOVIMIENTO ///////////////////////
(defmodule P-1-1-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



(defrule a-fell-decl-remain (declare (salience ?*a-population*))
	; Hay una compañía que no tiene declarado movimiento ni permanencia
	(object (is-a FELLOWSHIP) (name ?fell) (player ?p) (empty FALSE) (position ?loc))
	(object (is-a EP-turn) (state EXEC) (player ?p)(move $?move) (remain $?remain) (name ?turn))
	(test (not (member$ ?fell (create$ ?move ?remain))))
	=>
	(message "La compañia " ?fell " permanecera en " ?loc)
	(E-modify ?turn remain (insert$ ?remain 1 ?fell) P-1-1-2-1::a-fell-decl-remain)
)