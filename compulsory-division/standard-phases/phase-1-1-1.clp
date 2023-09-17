;/////////////////////// FASE 1 1 1: EJECUCIÓN ACCIONES FASE ORGANIZACION ///////////////////////
(defmodule P-1-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Ejecucion de la fase de organizacion))

; ACCIÓN: JUGAR PERSONAJE 1
; Puedes jugar un personaje de tu mano en su lugar natal o
; en cualquier refugio si tienes suficiente Influencia general o
; Influencia directa de algún personaje para controlarlo
(defrule action-play-under-follower (declare (salience ?*action-population-salience*))
	(logical 
		; Hay un personaje en la mano del jugador dueño del turno
		(object (is-a CHARACTER) (name ?char) (player ?p) (birthplace ?bp) (race ?race))
		(object (is-a HAND) (name ?hand) (player ?p))
		(in (over ?hand) (under ?char))
		
		; Localiza un personaje en una localización
		(object (is-a CHARACTER) (name ?play-under) (player ?p))
		(object (is-a LOCATION) (name ?loc))
		(in (over ?loc) (under ?play-under))
	
		; Un seguidor no puede tener sus propios seguidores.
		(not (in (over ?over&:(send ?over is-a CHARACTER)) (under ?play-under)))

		; O bien está en el lugar natal del personaje o en un refugio
		; No tiene sentido que un mago sea seguidor
		(test (and (neq ?race Wizzard)
			(or 
				(eq ?bp ?loc)
				(send ?loc is-haven)
		)))

		; Comprobar que el personaje play-under tiene infl. dir. como para tener
		; a char de seguidor
		(test (< (send ?char get-mind) (send ?play-under get-direct-influence)))
	)
	=>
	; Asertar la acción "Jugar al personaje como seguidor"
	;(gen-action ?p CHARACTER-play 
	;	target ?char 
	;	under ?play-under
	;)
)

; ACCIÓN: Jugar personaje 2
(defrule action-play-under-fellowship (declare (salience ?*action-population-salience*))
	(logical 
		; Hay un personaje en la mano del jugador dueño del turno
		(object (is-a CHARACTER) (name ?char) (player ?p) (birthplace ?bp) (race ?race))
		(object (is-a HAND) (name ?hand) (player ?p))
		(in (over ?hand) (under ?char))
		
		; Localiza una compañía/personaje en una localización
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
		(object (is-a LOCATION) (name ?loc))
		(in (over ?loc) (under ?fell))
		
		(test (or 
			(eq ?bp ?loc)
			(eq ?loc Rivendel); TODO: []?
			(and (send ?loc is-haven) (neq ?race Wizzard))
		))
	)
	=>
	; Asertar la acción "Jugar al personaje en esa compañía" (tener en cuenta la
	; condición de que una localización debe tener siempre una compañía vacía
	; asociada)
	;(gen-action ?p CHARACTER-play 
	;	target ?char 
	;	under ?fell)
)


; ACCIÓN: DECLARAR MOVIMIENTO
(defrule action-declare-movement (declare (salience ?*action-population-salience*))
	(logical
		; Hay una compañía con movimiento por defecto (no tiene declarado movimiento)
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
		(not (object (is-a EVENT) (event-definitor FELLOWSHIP-move) (type IN)
			(name ?e&:(eq ?fell (send ?e get-data fell)))
		))
		
		; Encuentro la localización de la compañía
		(object (is-a LOCATION) (name ?loc))
		(in (over ?loc) (under ?fell))
	)
	=>
	;(if (send ?loc is-haven)
	;	then
		; Si está ahora en un refugio puede moverse a cualquier localización colindante
	;	(do-for-all-instances ((?destination LOCATION)) (eq ?destination:closest-haven ?loc)
	;		(gen-action ?p FELLOWSHIP-move 
	;			fell ?fell 
	;			from ?loc
	;			to ?destination
	;		)
	;	)
	;	else
	;	; Si no, solo puede moverse hacia el refugio más cercano
	;	(gen-action ?p FELLOWSHIP-move 
	;		fell ?fell 
	;		from ?loc
	;		to (send ?loc get-closest-haven)
	;	)
	;)
)


; ACCIÓN: TRANSFERIR OBJETO
; Puedes intercambiar objetos entre tus personajes si están en
; el mismo lugar, pero antes, el portador de cada objeto deberá
; hacer un chequeo de corrupción
(defrule action-transfer-object (declare (salience ?*action-population-salience*))
	(logical
		; Localiza el personaje que posee (directamente) el objeto
		(object (is-a OBJECT) (name ?o))
		(object (is-a CHARACTER) (name ?disposer))
		(in (transitive FALSE) (over ?disposer) (under ?o))

		; Localiza un personaje que esté en el mismo lugar
		(object (is-a LOCATION) (name ?loc))
		(in (over ?loc) (under ?o))
		(object (is-a CHARACTER) (name ?receiver))
		(in (over ?loc) (under ?receiver))
		
		; Reviso que el personaje que posee el objeto no puede ser el receptor
		(test (neq ?disposer ?receiver))
	)
	=>
	;(gen-action OBJECT-transfer 
	;	obj ?o 
	;	disposer ?disposer 
	;	receiver ?receiver)
)

; ACCIÓN: ALMACENAR OBJETO
; También puedes almacenar objetos si el portador está en un refugio
(defrule action-object-store (declare (salience ?*action-population-salience*))
	(logical
		; Localiza un objeto y el lugar donde está
		(object (is-a OBJECT) (name ?o))
		(object (is-a LOCATION) (name ?loc))
		(in (over ?loc) (under ?o))
		
		; Verifico que la localización es un refugio
		(test (send ?loc is-haven))
	)
	=>
	;(gen-action OBJECT-store 
	;	obj ?o)
)


; ACCIÓN: REORGANIZAR COMPAÑÍAS EN UN LUGAR
; Si tus personajes están en el mismo refugio puedes dividirlos en
; cualquier número de compañías
(defrule action-reorganize-fellowship (declare (salience ?*action-population-salience*))
	(logical
		; Dada una localización refugio donde existe un personaje
		(object (is-a LOCATION) (name ?loc&:(send ?loc is-haven)))
		(object (is-a CHARACTER) (name ?char))
		(in (over ?loc) (under ?char))
	)
	=>
	;(gen-action LOCATION-reorganize 
	;	player ?p 
	;	loc ?loc)
)