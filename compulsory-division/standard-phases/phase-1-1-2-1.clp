;/////////////////////// FASE 1 1 2 1: EJECUCION DECLARAR MOVIMIENTO ///////////////////////
(defmodule P-1-1-2-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Ejecucion declarar movimiento))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



; ACCIÓN: DECLARAR MOVIMIENTO DESDE REFUGIO
(defrule action-fell-decl-mov#from-haven (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-1-1-2-1))
		; Hay una compañía con movimiento por defecto del jugador dueño del turno (no tiene declarado movimiento)
		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p&:(eq ?p ?*player*)))
		(not (object (is-a E-fell-decl-move) (fell ?fell)))
		
		; Encuentro la localización de la compañía
		(object (is-a HAVEN) (name ?loc))
		(in (over ?loc) (under ?fell))

		; Por cada localización adyacente (excluyendo el propio haven)
		(object (is-a LOCATION) (name ?to) (is-haven FALSE) (closest-haven ?loc))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def fell-decl-move)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?to))
		(data (create$ 
		"( fell [" ?fell "])"
		"( from [" ?loc "])"
		"( to [" ?to "])"))
	))
)


; ACCIÓN: DECLARAR MOVIMIENTO DESDE REFUGIO HACIA REFUGIO
(defrule action-fell-decl-mov#haven-haven (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-1-1-2-1))
		; Hay una compañía con movimiento por defecto del jugador dueño del turno (no tiene declarado movimiento)
		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p&:(eq ?p ?*player*)))
		(not (object (is-a E-fell-decl-move) (fell ?fell)))
		
		; Encuentro la localización de la compañía
		(object (is-a HAVEN) (name ?loc) (site-paths $?paths))
		(in (over ?loc) (under ?fell))

		(object (is-a HAVEN) (name ?to&:(member$ ?to ?paths)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def fell-decl-move)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?to))
		(data (create$ 
		"( fell [" ?fell "])"
		"( from [" ?loc "])"
		"( to [" ?to "])"))
	))
)


; ACCIÓN: DECLARAR MOVIMIENTO DESDE NO REFUGIO
(defrule action-fell-decl-mov#no-haven (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-1-1-2-1))
		; Hay una compañía con movimiento por defecto del dueño del turno (no tiene declarado movimiento)
		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p&:(eq ?p ?*player*)))
		(not (object (is-a E-fell-decl-move) (fell ?fell)))

		; Encuentro la localización de la compañía
		(object (is-a LOCATION) (name ?loc) (is-haven FALSE) (closest-haven ?cl-haven))
		(in (transitive FALSE) (over ?loc) (under ?fell))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def fell-decl-move)
		(description (sym-cat "Declare movement of fellowship " ?fell " from " ?loc " to " ?cl-haven))
		(data (create$ 
		"( fell [" ?fell "])"
		"( from [" ?loc "])"
		"( to [" ?cl-haven "])"))
	))
)