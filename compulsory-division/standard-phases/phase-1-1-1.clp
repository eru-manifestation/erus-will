;/////////////////////// FASE 1 1 1: EJECUCIÓN ACCIONES FASE ORGANIZACION ///////////////////////
(defmodule P-1-1-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))



; ACCIÓN: JUGAR PERSONAJE 1
; Puedes jugar un personaje de tu mano en su lugar natal o
; en cualquier refugio si tienes suficiente Influencia general o
; Influencia directa de algún personaje para controlarlo
(defrule a-char-play#as-follower (declare (salience ?*a-population*))
	(logical 
		?e <- (object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)

		; Sólo se puede jugar un personaje por turno en fase de organización
		(not (object (is-a E-modify) (position ?e) (state DONE) (reason $? PLAY CHARACTER $?)))


		; Hay un personaje en la mano del jugador dueño del turno
		(object (is-a CHARACTER) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?char) 
			(birthplace ?bp) (race ?race) (mind ?mind))
		
		; Localiza un personaje en una localización, que no sea seguidor (está debajo justo de una compañía) y la compañía tiene espacio
		(object (is-a CHARACTER) (player ?p) (name ?play-under) (position ?fell) (influence ?influence&:(<= ?mind ?influence)))
		(object (is-a FELLOWSHIP) (player ?p) (name ?fell) (companions ?comp&:(< ?comp 7)))

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
		(event-def modify)
		(description (sym-cat "Play character " ?char " as a follower of " ?play-under))
		(identifier ?char ?play-under)
		(data (create$ ?char position ?play-under PLAY CHARACTER P111-a-char-play#as-follower))
	))
)

; ACCIÓN: Jugar personaje 2
(defrule a-char-play#under-fell (declare (salience ?*a-population*))
	(logical 
		?e <- (object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)
		
		; Sólo se puede jugar un personaje por turno en fase de organización
		(not (object (is-a E-modify) (position ?e) (state DONE) (reason $? PLAY CHARACTER $?)))

		; Hay un personaje en la mano del jugador dueño del turno (el jugador debe la inf gen necesaria para jugarlo)
		(object (is-a PLAYER) (name ?p) (general-influence ?gen-inf))
		(object (is-a CHARACTER) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?char) (player ?p) 
			(birthplace ?bp) (race ?race) (mind ?mind&:(<= ?mind ?gen-inf)))
		
		; Localiza una compañía/personaje en una localización
		(object (is-a FELLOWSHIP) (name ?fell) (position ?loc) (player ?p) (companions ?comp&:(< ?comp 7)))
		(object (is-a LOCATION) (name ?loc) (place ?place))
		
		; O es su lugar de nacimiento, o es RIVENDELL, o no es mago
		(test (or 
				(eq ?bp ?loc)
				(eq ?loc [rivendell]); TODO: []?
				(and (eq ?place HAVEN) (neq ?race WIZARD))
		))
	)
	=>
	; Asertar la acción "Jugar al personaje en esa compañía" (tener en cuenta la condición de que una localización debe tener siempre una compañía vacía asociada)
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Play character " ?char " in fellowship " ?fell))
		(identifier ?char ?fell)
		(data (create$ ?char position ?fell PLAY CHARACTER P111-a-char-play#under-fell))
	))
)


; ACCIÓN: TRANSFERIR OBJETO
; Puedes intercambiar objetos entre tus personajes si están en el mismo lugar, pero antes, el portador de cada objeto deberá hacer un chequeo de corrupción
(defrule a-item-transfer (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)
		; Localiza el personaje que posee (directamente) el objeto, ambos del jugador dueño del turno
		(object (is-a ITEM) (name ?i) (position ?disposer) (player ?p))
		(object (is-a CHARACTER) (state UNTAPPED | TAPPED | WOUNDED) (name ?disposer) (player ?p))

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
		(event-def modify)
		(description (sym-cat "Transfer item " ?i " from " ?disposer " to " ?receiver))
		(identifier ?i ?receiver)
		(data (create$ ?i position ?receiver
			TRANSFER ITEM P111::a-item-transfer))
	))
)

; ACCIÓN: ALMACENAR OBJETO
; También puedes almacenar objetos si el portador está en un refugio
(defrule a-item-store (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)
		; Localiza un objeto y si está en un refugio, debe ser del jugador del turno
		(object (is-a ITEM) (name ?i) (position ?bearer) (player ?p))
		(object (is-a HAVEN) (name ?loc))
		(in (over ?loc) (under ?i))

		(object (is-a CHARACTER) (name ?bearer) (player ?p))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Store item " ?i " from " ?bearer " in " ?loc))
		(identifier ?i ?loc)
		(data (create$ ?i position (mpsymbol ?p) 
			STORE ITEM P111::a-item-store))
	))
)


; ACCIÓN: DESCARTAR UN PERSONAJE
; Como parche para la opcion que deja la guia de organizar compañia de modo que descartes los personajes que no te quepan en la compañia

; TODO: comprobar a la salida de esta fase de organizacion que la compañia esta correctamente
(defrule a-char-discard (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC) (reason turn $?))
    	(player ?p)
		; Dada una localización refugio donde existe un personaje (debe haber una compañía)
		(object (is-a HAVEN) (name ?loc))
		(object (is-a CHARACTER) (name ?char) (player ?p))
		(in (over ?loc) (under ?char))
	)
	=>
	(assert (action
		(player ?p)
		(event-def modify)
		(description (sym-cat "Discard character " ?char))
		(identifier ?char (discardsymbol ?p))
		(data (create$ ?char position (discardsymbol ?p) DISCARD CHARACTER P111::a-char-discard))
	))
)



; ACCIÓN: MOVER PERSONAJE DE UNA COMPAÑÍA A OTRA
; Siempre puedes mover a un personaje a otra compañia del lugar a menos que ya tenga 7 integrantes
(defrule a-char-move#change-fell (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC) (reason turn $?))
		(object (is-a HAVEN) (name ?loc))
		(player ?p)

		; Dado un personaje directamente bajo una compañía del lugar (no es seguidor), y otra compañía del lugar
      	(object (is-a FELLOWSHIP) (name ?ini-fell) (position ?loc) (player ?p))

		(object (is-a CHARACTER) (name ?char) (position ?ini-fell) (player ?p))

      ;Testear que la compañía destino no tenga 7 o más integrantes
      (object (is-a FELLOWSHIP) (name ?fell&:(neq ?ini-fell ?fell)) (position ?loc)
			(companions ?cn&:(< ?cn 7)) (player ?p))

	)
	=>
	; Asertar la acción "Mover personaje de una compañia a otra"
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Move " ?char " from " ?ini-fell " to " ?fell))
		(identifier ?char ?fell)
		(data (create$ ?char position ?fell
			MOVE CHARACTER P111::a-char-move#change-fell))
	))
)


; ACCIÓN: HACER PERSONAJE UN SEGUIDOR
; Siempre que un personaje tenga suficiente influencia puedes hacer de un personaje seguidor
(defrule a-char-follow (declare (salience ?*a-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason turn $?))
		(object (is-a HAVEN) (name ?loc))
		(player ?p)

		;Dado un personaje en la localizacion con mente inferior a la influencia de otro en juego (que no es seguidor)
		(object (is-a CHARACTER) (name ?headchar) (position ?fell) (player ?p) (influence ?influence))
		(in (over ?loc) (under ?headchar))

		;Encuentro la compañia del personaje (uso transitive FALSE para verificar que ?headchar no es seguidor)
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))

		; Encuentro otro personaje en la compañia (no en la localizacion porque puedo pasarme del limite de la compañia) y verifico que ?headchar tenga influencia para poder con ?tobefollower
		(object (is-a CHARACTER) (player ?p) (mind ?mind&:(<= ?mind ?influence))
			(name ?tobefollower&:(neq ?headchar ?tobefollower)))
		(in (over ?fell) (under ?tobefollower))

		; Verifico que es otro personaje no tenga a su vez seguidores
		(not (exists
			(object (is-a CHARACTER) (name ?underchar) (player ?p))
			(in (over ?tobefollower) (under ?underchar))
		))
	)
	=>
	; Asertar la acción "Hacer personaje seguidor"
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Make " ?tobefollower " a follower of " ?headchar))
		(identifier ?tobefollower ?headchar)
		(data (create$ ?tobefollower position ?headchar
			FOLLOW P111::a-char-follow))
	))
)


; ACCIÓN: PASAR DE SEGUIDOR A PERSONAJE
; Siempre que el jugador tenga suficiente influencia general y que haya espacio en la compañía puedo bajarlo
(defrule a-char-unfollow (declare (salience ?*a-population*))
	(logical 
		(object (is-a E-phase) (state EXEC) (reason turn $?))
		(object (is-a HAVEN) (name ?loc))
		(player ?p)

		;Compruebo que el jugador tenga influencia general suficiente
		(object (is-a PLAYER) (name ?p) (general-influence ?gen-inf))

		;Dado un personaje en la localizacion que sea seguidor (bajo otro personaje)
		(object (is-a CHARACTER) (name ?followed) (player ?p))
		(in (over ?loc) (under ?followed))

		;Compruebo que sea seguidor
		(object (is-a CHARACTER) (name ?follower) (player ?p) (mind ?mind&:(<= ?mind ?gen-inf)))
		(in (over ?followed) (under ?follower))

		;Encuentro una compañía con espacio en el lugar
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p) (companions ?comp&:(< ?comp 7)) (position ?loc))
	)
	=>
	; Asertar la acción "Hacer seguidor un personaje en cierta compañía"
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Make the follower " ?follower " a normal character in " ?fell))
		(identifier ?follower ?fell)
		(data (create$ ?follower position ?fell
			UNFOLLOW P111::a-char-unfollow))
	))
)