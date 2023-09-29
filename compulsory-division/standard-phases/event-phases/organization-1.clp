;/////////////////// ORGANIZATION 1: EJECUCION FASE ORGANIZACION ////////////////////////
(defmodule loc-organize-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Ejecucion fase organizacion))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))


; ACCIÓN: MOVER PERSONAJE DE UNA COMPAÑÍA A OTRA
; Siempre puedes mover a un personaje a otra compañia del lugar a menos que ya tenga 7 integrantes
(defrule action-char-change-fell (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase loc-organize-1))
        (object (is-a EP-loc-organize) (type ONGOING) (player ?p) (loc ?loc))

		; Dado un personaje directamente bajo una compañía del lugar (no es seguidor), y otra compañía del lugar
        (object (is-a FELLOWSHIP) (name ?ini-fell) (player ?p))
		(in (transitive FALSE) (over ?loc) (under ?ini-fell))

		(object (is-a CHARACTER) (name ?char) (player ?p))
		(in (transitive FALSE) (over ?ini-fell) (under ?char))

        (object (is-a FELLOWSHIP) (name ?fell&:(neq ?ini-fell ?fell)))
		(in (transitive FALSE) (over ?loc) (under ?fell))

        ;TODO: Testear que la compañía no tenga 7 o más integrantes
	)
	=>
	; Asertar la acción "Mover personaje de una compañia a otra"
	(assert (action 
		(player ?p)
		(event-def char-move)
		(description (sym-cat "Move " ?char " from " ?ini-fell " to " ?fell))
		(data (create$ 
		"( char [" ?char "])" 
		"( to [" ?fell "])"))
	))
)


; ACCIÓN: HACER PERSONAJE UN SEGUIDOR
; Siempre que un personaje tenga suficiente influencia puedes jugar el seguidor
(defrule action-char-change-fell (declare (salience ?*action-population-salience*))
	(logical 
		(only-actions (phase loc-organize-1))
        (object (is-a EP-loc-organize) (type ONGOING) (player ?p) (loc ?loc))

		;Dado un personaje en la localizacion con mente inferior a la influencia de otro en juego (que no es seguidor)
		(object (is-a CHARACTER) (name ?char) (player ?p))
		(in (over ?loc) (under ?char))

		; Verifico que ?char no sea un seguidor
		(not (exists
			(object (is-a CHARACTER) (name ?over-char) (player ?p))
			(in (over ?over-char) (under ?char))
		))

		; Encuentro otro personaje en la localizacion
		((object (is-a CHARACTER) (name ?follower) (player ?p))
		(in (over ?loc) (under ?follower)))

		; Verifico que es otro personaje no tenga a su vez seguidores
		(not (exists
			(object (is-a CHARACTER) (name ?under-char) (player ?p))
			(in (over ?follower) (under ?under-char))
		))

		;TODO: verificar que ?char tenga influencia para poder con ?follower
		(test (<= (send ?follower get-mind) (send ?char get-influence)))
	)
	=>
	; Asertar la acción "Hacer personaje seguidor"
	; TODO
)