;/////////////////////// FASE 1 1 1: EJECUCIÓN ACCIONES FASE ORGANIZACION ///////////////////////
(defmodule P-1-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INIT
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule)) 
(debug Ejecucion de la fase de organizacion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))



; ACCIÓN: JUGAR PERSONAJE 1
; Puedes jugar un personaje de tu mano en su lugar natal o
; en cualquier refugio si tienes suficiente Influencia general o
; Influencia directa de algún personaje para controlarlo
(defrule action-char-play#as-follower (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase P-1-1-1))
		; Hay un personaje en la mano del jugador dueño del turno
		(object (is-a CHARACTER) (state HAND) (name ?char) (player ?p&:(eq ?p ?*player*)) 
			(birthplace ?bp) (race ?race) (mind ?mind))
		
		; Localiza un personaje en una localización, que no sea seguidor (está debajo justo de
		; una compañía) y la compañía tiene espacio
		(object (is-a CHARACTER) (player ?p) (name ?play-under) (influence ?influence&:(<= ?mind ?influence)))
		(object (is-a FELLOWSHIP) (player ?p) (name ?fell) (companions ?comp&:(< ?comp 7)))
		(in (transitive FALSE) (over ?fell) (under ?play-under))

		(object (is-a LOCATION) (name ?loc))
		(in (over ?loc) (under ?play-under))

		; O bien está en el lugar natal del personaje o en un refugio
		; No tiene sentido que un mago sea seguidor
		(test (and (neq ?race WIZARD)
			(or 
				(eq ?bp ?loc)
				(eq (send ?loc get-place) HAVEN)
		)))
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
(defrule action-char-play#under-fell (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase P-1-1-1))
		; Hay un personaje en la mano del jugador dueño del turno (el jugador debe la inf gen
		; necesaria para jugarlo)
		(object (is-a PLAYER) (name ?p&:(eq ?p ?*player*)) (general-influence ?gen-inf))
		(object (is-a CHARACTER) (state HAND) (name ?char) (player ?p) 
			(birthplace ?bp) (race ?race) (mind ?mind&:(<= ?mind ?gen-inf)))
		
		; Localiza una compañía/personaje en una localización
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p) (companions ?comp&:(< ?comp 7)))
		(object (is-a LOCATION) (name ?loc) (place ?place))
		(in (transitive FALSE) (over ?loc) (under ?fell))
		
		; O es su lugar de nacimiento, o es RIVENDELL, o no es mago
		(test (or 
				(eq ?bp ?loc)
				(eq ?loc [rivendell]); TODO: []?
				(and (eq ?place HAVEN) (neq ?race WIZARD))
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


; ACCIÓN: TRANSFERIR OBJETO
; Puedes intercambiar objetos entre tus personajes si están en
; el mismo lugar, pero antes, el portador de cada objeto deberá
; hacer un chequeo de corrupción
(defrule action-item-transfer (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-1-1-1))
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
		(only-actions (phase P-1-1-1))
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
		(only-actions (phase P-1-1-1))
		; Dada una localización refugio donde existe un personaje (debe haber una compañía)
		(object (is-a HAVEN) (name ?loc))
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


; ACCIÓN: DESCARTAR UN PERSONAJE
; Como parche para la opcion que deja la guia de organizar compañia de modo que descartes los
; personajes que no te quepan en la compañia

; TODO: comprobar a la salida de esta fase de organizacion que la compañia esta correctamente
(defrule action-char-discard (declare (salience ?*action-population-salience*))
	(logical
		(only-actions (phase P-1-1-1))
		; Dada una localización refugio donde existe un personaje (debe haber una compañía)
		(object (is-a HAVEN) (name ?loc))
		(object (is-a CHARACTER) (name ?char) (player ?p&:(eq ?p ?*player*)))
		(in (over ?loc) (under ?char))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def char-discard)
		(description (sym-cat "Discard character " ?char))
		(data (create$ 
		"( char [" ?char "])"))
	))
)