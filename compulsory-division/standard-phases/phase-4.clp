;/////////////////////// FASE 4: FASE DE LUGARES ///////////////////////
(defmodule P-4 (import MAIN ?ALL) (import P-3-1-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(message Fase de lugares))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



; ACCIÓN: INICIAR FASE LUGARES
(defrule action-loc-phase (declare (salience ?*action-population*))
	(logical
		;(only-actions (phase P-4))
		(object (is-a E-modify) (state EXEC) (reason turn $?))
    	(player ?p)

		(object (is-a FELLOWSHIP) (empty FALSE) (player ?p) (name ?fell))
		(not (object (is-a E-phase) (reason loc-phase $?) (state DONE)))
	)
	=>
	;	TODO: Hacer loc-phase
	(assert (action 
		(player ?p)
		(event-def phase)
		(description (sym-cat "Begin location phase for " ?fell))
		(identifier ?fell)
		(data (create$ "loc-phase P4::action-loc-phase"
			(str-cat "fellowship " ?fell)))
		(blocking TRUE)
	))
)
