;/////////////////////// FASE 1 1 1: EJECUCIÓN ACCIONES FASE ORGANIZACION ///////////////////////
(defmodule P-1-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) => 
(announce (sym-cat DEV - (get-focus)) Ejecucion de la fase de organizacion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))

; ACCIÓN: JUGAR PERSONAJE 1
; Puedes jugar un personaje de tu mano en su lugar natal o
; en cualquier refugio si tienes suficiente Influencia general o
; Influencia directa de algún personaje para controlarlo
(defrule action-play-as-follower (declare (salience ?*action-population-salience*))
	(logical 
		; Hay un personaje en la mano del jugador dueño del turno
		(object (is-a CHARACTER) (state HAND) (name ?char) (player ?p&:(eq ?p ?*player*)) (birthplace ?bp) (race ?race))
		
		; Localiza un personaje en una localización
		(object (is-a CHARACTER) (name ?play-under) (player ?p))
		(object (is-a LOCATION) (name ?loc))
		(in (over ?loc) (under ?play-under))
	
		; Un seguidor no puede tener sus propios seguidores.
		(object (is-a CHARACTER) (name ?followed))
		(not (in (transitive FALSE) (over ?followed) (under ?play-under)))

		; O bien está en el lugar natal del personaje o en un refugio
		; No tiene sentido que un mago sea seguidor
		(test (and (neq ?race WIZZARD)
			(or 
				(eq ?bp ?loc)
				(send ?loc get-is-haven)
		)))

		; Comprobar que el personaje play-under tiene infl. dir. como para tener
		; a char de seguidor
		(test (< (send ?char get-mind) (send ?play-under get-influence)))
	)
	=>
	; Asertar la acción "Jugar al personaje como seguidor"
	(assert (action 
		(player ?p)
		(event-def char-play)
		(description (sym-cat "Play character " ?char " as a follower of " ?play-under))
		(data (create$ 
		"( character [" ?char "])" 
		"( under ["?play-under "])"))
	))
)

; ACCIÓN: Jugar personaje 2
(defrule action-play-under-fellowship (declare (salience ?*action-population-salience*))
	(logical 
		; Hay un personaje en la mano del jugador dueño del turno
		(object (is-a CHARACTER) (state HAND) (name ?char) (player ?p&:(eq ?p ?*player*)) (birthplace ?bp) (race ?race))
		
		; Localiza una compañía/personaje en una localización
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
		(object (is-a LOCATION) (name ?loc) (is-haven ?is-haven))
		(in (transitive FALSE) (over ?loc) (under ?fell))
		
		
		; Tiene que haber suficiente influencia general
		(test (<= (send ?char get-mind) (send ?p get-general-influence)))
		; O es su lugar de nacimiento, o es RIVENDELL, o no es mago
		
		(test (or 
				(eq ?bp ?loc)
				(eq ?loc [rivendell]); TODO: []?
				(and ?is-haven (neq ?race WIZZARD))
		))
	)
	=>
	; Asertar la acción "Jugar al personaje en esa compañía" (tener en cuenta la
	; condición de que una localización debe tener siempre una compañía vacía
	; asociada)
	(assert (action 
		(player ?p)
		(event-def char-play)
		(description (sym-cat "Play character " ?char " in fellowship " ?fell))
		(data (create$ 
		"( character [" ?char "])" 
		"( under ["?fell "])"))
	))
)


; ACCIÓN: DECLARAR MOVIMIENTO DESDE REFUGIO
(defrule action-decl-mov-hav (declare (salience ?*action-population-salience*))
	(logical
		; Hay una compañía con movimiento por defecto del jugador dueño del turno (no tiene declarado movimiento)
		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p&:(eq ?p ?*player*)))
		
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
(defrule action-decl-mov-hav-to-hav (declare (salience ?*action-population-salience*))
	(logical
		; Hay una compañía con movimiento por defecto del jugador dueño del turno (no tiene declarado movimiento)
		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p&:(eq ?p ?*player*)))
		
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
(defrule action-decl-mov (declare (salience ?*action-population-salience*))
	(logical
		; Hay una compañía con movimiento por defecto del dueño del turno (no tiene declarado movimiento)
		(object (is-a FELLOWSHIP) (empty FALSE) (name ?fell) (player ?p&:(eq ?p ?*player*)))

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


; ACCIÓN: TRANSFERIR OBJETO
; Puedes intercambiar objetos entre tus personajes si están en
; el mismo lugar, pero antes, el portador de cada objeto deberá
; hacer un chequeo de corrupción
(defrule action-transfer-item (declare (salience ?*action-population-salience*))
	(logical
		; Localiza el personaje que posee (directamente) el objeto, ambos del jugador dueño del turno
		(object (is-a ITEM) (name ?i) (player ?p&:(eq ?p ?*player*)))
		(object (is-a CHARACTER) (state UNTAPPED | TAPPED | WOUNDED) (name ?disposer) (player ?p))
		(in (transitive FALSE) (over ?disposer) (under ?i))

		; Localiza un personaje que esté en el mismo lugar
		(object (is-a LOCATION) (name ?loc))
		(in (over ?loc) (under ?disposer))
		(object (is-a CHARACTER) (state UNTAPPED | TAPPED | WOUNDED) (name ?receiver) (player ?p))
		; Reviso que el personaje que posee el objeto no puede ser el receptor
		(test (neq ?disposer ?receiver))
		(in (over ?loc) (under ?receiver))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def item-transfer)
		(description (sym-cat "Transfer item " ?i " from " ?disposer " to " ?receiver))
		(data (create$ 
		"(item [" ?i "])"
		"(disposer [" ?disposer "])" 
		"(receiver ["  ?receiver "])"))
	))
)

; ACCIÓN: ALMACENAR OBJETO
; También puedes almacenar objetos si el portador está en un refugio
(defrule action-item-store (declare (salience ?*action-population-salience*))
	(logical
		; Localiza un objeto y si está en un refugio, debe ser del jugador del turno
		(object (is-a ITEM) (name ?i) (player ?p&:(eq ?p ?*player*)))
		(object (is-a HAVEN) (name ?loc))
		(in (over ?loc) (under ?i))

		(object (is-a CHARACTER) (name ?bearer) (player ?p))
		(in (transitive FALSE) (over ?bearer) (under ?i))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def item-store)
		(description (sym-cat "Store item " ?i " from " ?bearer " in " ?loc))
		(data (create$ 
		"( item [" ?i "])"
		"( bearer [" ?bearer "])"
		"( haven [" ?loc "])"))
	))
)


; ACCIÓN: REORGANIZAR COMPAÑÍAS EN UN LUGAR
; Si tus personajes están en el mismo refugio puedes dividirlos en
; cualquier número de compañías
(defrule action-loc-organize (declare (salience ?*action-population-salience*))
	(logical
		; Dada una localización refugio donde existe un personaje (debe haber una compañía)
		(object (is-a HAVEN) (name ?loc))
		;TODO: hacer que funcione con un exist
		(exists 
			(object (is-a CHARACTER) (name ?char) (player ?p&:(eq ?p ?*player*)))
			(in (over ?loc) (under ?char))
		)
	)
	=>
	(assert (action 
		(player ?*player*)
		(event-def loc-organize)
		(description (sym-cat "Organize fellowship in " ?loc))
		(data (create$ 
		"( player [" ?*player* "])" 
		"( loc [" ?loc "])"))
	))
)