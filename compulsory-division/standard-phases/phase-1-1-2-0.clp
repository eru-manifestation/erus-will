;/////////////////////// FASE 1 1 2 0: INICIO DECLARAR MOVIMIENTO ///////////////////////
(defmodule P-1-1-2-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Inicio declarar movimiento))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



; DECLARAR ESTANCIA PREVENTIVAMENTE
(defrule action-fell-decl-remain (declare (salience ?*action-population-salience*))
	; Hay una compañía con movimiento por defecto del dueño del turno (no tiene declarado movimiento)
	(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p&:(eq ?p ?*player*)))

	; Encuentro la localización de la compañía
	(object (is-a LOCATION) (name ?loc))
	(in (transitive FALSE) (over ?loc) (under ?fell))
	=>
	(make-instance (gen-name E-fell-decl-remain) of E-fell-decl-remain (fell ?fell) (loc ?loc))
	(debug Initializing pre-emptive stay of ?fell in ?loc)
)