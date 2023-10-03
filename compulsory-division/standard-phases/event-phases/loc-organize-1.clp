;/////////////////// ORGANIZATION 1: EJECUCION FASE ORGANIZACION ////////////////////////
(defmodule loc-organize-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INIT
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Ejecucion fase organizacion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))


; ACCIÓN: MOVER PERSONAJE DE UNA COMPAÑÍA A OTRA
; Siempre puedes mover a un personaje a otra compañia del lugar a menos que ya tenga 7 integrantes
(defrule action-char-move#change-fell (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase loc-organize-1))
        (object (is-a EP-loc-organize) (type ONGOING) (player ?p) (loc ?loc))

		; Dado un personaje directamente bajo una compañía del lugar (no es seguidor), y otra compañía del lugar
        (object (is-a FELLOWSHIP) (name ?ini-fell) (player ?p))
		(in (transitive FALSE) (over ?loc) (under ?ini-fell))

		(object (is-a CHARACTER) (name ?char) (player ?p))
		(in (transitive FALSE) (over ?ini-fell) (under ?char))

        ;Testear que la compañía destino no tenga 7 o más integrantes
        (object (is-a FELLOWSHIP) (name ?fell&:(neq ?ini-fell ?fell)) (companions ?cn&:(< ?cn 7)) (player ?p))
		(in (transitive FALSE) (over ?loc) (under ?fell))

	)
	=>
	; Asertar la acción "Mover personaje de una compañia a otra"
	(assert (action 
		(player ?p)
		(event-def char-move)
		(description (sym-cat "Move " ?char " from " ?ini-fell " to " ?fell))
		(data (create$ 
		"( char [" ?char "])" 
		"( fell [" ?fell "])"))
	))
)


; ACCIÓN: HACER PERSONAJE UN SEGUIDOR
; Siempre que un personaje tenga suficiente influencia puedes hacer de un personaje seguidor
(defrule action-char-follow (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase loc-organize-1))
        (object (is-a EP-loc-organize) (type ONGOING) (player ?p) (loc ?loc))

		;Dado un personaje en la localizacion con mente inferior a la influencia de otro en juego (que no es seguidor)
		(object (is-a CHARACTER) (name ?char) (player ?p) (influence ?influence))
		(in (over ?loc) (under ?char))

		;Encuentro la compañia del personaje (uso transitive FALSE para verificar que ?char no es seguidor)
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
		(in (transitive FALSE) (over ?fell) (under ?char))

		; Encuentro otro personaje en la compañia (no en la localizacion porque puedo pasarme del
		; limite de la compañia) y verifico que ?char tenga influencia para poder con ?follower
		(object (is-a CHARACTER) (name ?follower) (player ?p) (mind ?mind&:(<= ?mind ?influence)))
		(in (over ?fell) (under ?follower))

		; Verifico que es otro personaje no tenga a su vez seguidores
		(not (exists
			(object (is-a CHARACTER) (name ?under-char) (player ?p))
			(in (over ?follower) (under ?under-char))
		))
	)
	=>
	; Asertar la acción "Hacer personaje seguidor"
	(assert (action 
		(player ?p)
		(event-def char-follow)
		(description (sym-cat "Make " ?follower " a follower of " ?char))
		(data (create$ 
		"( followed [" ?char "])" 
		"( follower [" ?follower "])"))
	))
)


; ACCIÓN: PASAR DE SEGUIDOR A PERSONAJE
; Siempre que el jugador tenga suficiente influencia general y que haya espacio en la compañía
; puedo bajarlo
(defrule action-char-unfollow (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase loc-organize-1))
        (object (is-a EP-loc-organize) (type ONGOING) (player ?p) (loc ?loc))

		;Compruebo que el jugador tenga influencia general suficiente
		(object (is-a PLAYER) (name ?p) (general-influence ?gen-inf))

		;Dado un personaje en la localizacion que sea seguidor (bajo otro personaje)
		(object (is-a CHARACTER) (name ?followed) (player ?p))
		(in (over ?loc) (under ?followed))

		;Compruebo que sea seguidor
		(object (is-a CHARACTER) (name ?follower) (player ?p) (mind ?mind&:(<= ?mind ?gen-inf)))
		(in (over ?followed) (under ?follower))

		;Encuentro una compañía con espacio en el lugar
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p) (companions ?comp&:(< ?comp 7)))
		(in (transitive FALSE) (over ?loc) (under ?fell))
	)
	=>
	; Asertar la acción "Hacer seguidor un personaje en cierta compañía"
	(assert (action 
		(player ?p)
		(event-def char-unfollow)
		(description (sym-cat "Make the follower " ?follower " a normal character in " ?fell))
		(data (create$ 
		"( fell [" ?fell "])" 
		"( follower [" ?follower "])"))
	))
)