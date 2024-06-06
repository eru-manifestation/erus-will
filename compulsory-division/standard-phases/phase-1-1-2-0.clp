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
		; Hay una compañía que no tiene declarado movimiento ni permanencia
		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p))
		(object (is-a EP-turn) (state EXEC) (player ?p) (move $?move) (remain $?remain) (name ?turn))
		
		; Encuentro la localización de la compañía
		(object (is-a HAVEN) (name ?loc))
		(in (over ?loc) (under ?fell))

		; Por cada localización adyacente (excluyendo el propio haven)
		(object (is-a LOCATION) (name ?to) (place ?place&:(neq ?place HAVEN)) (closest-haven ?loc))
		(test (not (member$ ?fell (create$ ?move ?remain))))
	)
	=>
	;	TODO: accion que modifique ?mov para añadir el movimiento de la compañia
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?to))
		(identifier ?fell ?to)
		(data ?turn move (insert$ ?move 1 (create$ ?fell ?to)))
		(reason P-1-1-2-0::a-fell-decl-mov#from-haven)
	))
)


; ACCIÓN: DECLARAR MOVIMIENTO DESDE REFUGIO HACIA REFUGIO
(defrule a-fell-decl-mov#haven-haven (declare (salience ?*a-population*))
	(logical
		; Hay una compañía que no tiene declarado movimiento ni permanencia
		(object (is-a FELLOWSHIP) (name ?fell) (empty FALSE) (player ?p))
		(object (is-a EP-turn) (state EXEC) (player ?p) (move $?move) (remain $?remain) (name ?turn))

		; Encuentro la localización de la compañía
		(object (is-a HAVEN) (name ?loc) (site-pathA ?pathA)); (site-pathB ?pathB))
		(in (over ?loc) (under ?fell))
		(test (not (member$ ?fell (create$ ?move ?remain))))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?pathA))
		(identifier ?fell ?pathA)
		(data ?turn move (insert$ ?move 1 (create$ ?fell ?pathA)))
		(reason P-1-1-2-0::a-fell-decl-mov#haven-haven)
	))
	; (assert (action 
	; 	(player ?p)
	; 	(event-def modify)
	; 	(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?pathB))
	; 	(identifier ?fell ?pathB)
		; (data ?turn move (insert$ ?move 1 (create$ ?fell ?pathB)))
	; 	(reason P-1-1-2-0::a-fell-decl-mov#haven-haven)
	; ))
)


; ACCIÓN: DECLARAR MOVIMIENTO DESDE NO REFUGIO
(defrule a-fell-decl-mov#no-haven (declare (salience ?*a-population*))
	(logical
		; Hay una compañía que no tiene declarado movimiento ni permanencia
		(object (is-a FELLOWSHIP) (position ?loc) (name ?fell) (empty FALSE) (player ?p))
		(object (is-a EP-turn) (state EXEC) (player ?p) (move $?move) (remain $?remain) (name ?turn))
		; Encuentro la localización de la compañía
		(object (is-a LOCATION) (name ?loc) (place ?place&:(neq ?place HAVEN)) (closest-haven ?cl-haven))
		(test (not (member$ ?fell (create$ ?move ?remain))))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?cl-haven))
		(identifier ?fell ?cl-haven)
		(data ?turn move (insert$ ?move 1 (create$ ?fell ?cl-haven)))
		(reason P-1-1-2-0::a-fell-decl-mov#no-haven)
	))
)