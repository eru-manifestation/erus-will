;/////////////////////// FASE 1 1 2 0: EJECUCION DECLARAR MOVIMIENTO ///////////////////////
(defmodule P-1-1-2-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



; ACCIÓN: DECLARAR MOVIMIENTO DESDE REFUGIO
(defrule a-fell-decl-mov#from-haven (declare (salience ?*a-population*))
	(logical
    	(player ?p)

		; Hay una compañía que no tiene declarado movimiento ni permanencia
		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p))
		(object (is-a E-phase) (state EXEC) (reason turn $?))
		;	TODO: Testear si es posible eliminar reason: la activacion original deberia desactivarse al cambiar de E-phase, pero como esta regla es dependiente de la fase, no deberia haber una activacion inesperada en la fase superior

		(not (data (phase turn) (data move ?fell $?)))
		(not (data (phase turn) (data remain ?fell $?)))
		
		; Encuentro la localización de la compañía
		(object (is-a HAVEN) (name ?loc))
		(in (over ?loc) (under ?fell))

		; Por cada localización adyacente (excluyendo el propio haven)
		(object (is-a LOCATION) (name ?to) (place ?place&:(neq ?place HAVEN)) (closest-haven ?loc))
	)
	=>
	;	TODO: accion que modifique ?mov para añadir el movimiento de la compañia
	(assert (action 
		(player ?p)
		(event-def variable)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?to))
		(identifier ?fell ?to)
		(data (create$ move ?fell ?to))
	))
)


; ACCIÓN: DECLARAR MOVIMIENTO DESDE REFUGIO HACIA REFUGIO
(defrule a-fell-decl-mov#haven-haven (declare (salience ?*a-population*))
	(logical
    	(player ?p)

		; Hay una compañía que no tiene declarado movimiento ni permanencia
		(object (is-a FELLOWSHIP) (name ?fell) (empty FALSE) (player ?p))
		(not (data (phase turn) (data move ?fell $?)))
		(not (data (phase turn) (data remain ?fell $?)))
		
		(object (is-a E-phase) (state EXEC) (reason turn $?))

		; Encuentro la localización de la compañía
		(object (is-a HAVEN) (name ?loc) (site-pathA ?pathA) (site-pathB ?pathB))
		(in (over ?loc) (under ?fell))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def variable)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?pathA))
		(identifier ?fell ?pathA)
		(data (create$ move ?fell ?pathA))
	))
	(assert (action 
		(player ?p)
		(event-def variable)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?pathB))
		(identifier ?fell ?pathB)
		(data (create$ move ?fell ?pathB))
	))
)


; ACCIÓN: DECLARAR MOVIMIENTO DESDE NO REFUGIO
(defrule a-fell-decl-mov#no-haven (declare (salience ?*a-population*))
	(logical
    	(player ?p)

		; Hay una compañía que no tiene declarado movimiento ni permanencia
		(object (is-a FELLOWSHIP) (position ?loc) (name ?fell) (empty FALSE) (player ?p))
		(not (data (phase turn) (data move ?fell $?)))
		(not (data (phase turn) (data remain ?fell $?)))

		(object (is-a E-phase) (state EXEC) (reason turn $?))

		; Encuentro la localización de la compañía
		(object (is-a LOCATION) (name ?loc) (place ?place&:(neq ?place HAVEN)) (closest-haven ?cl-haven))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def variable)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?cl-haven))
		(identifier ?fell ?cl-haven)
		(data (create$ move ?fell ?cl-haven))
	))
)