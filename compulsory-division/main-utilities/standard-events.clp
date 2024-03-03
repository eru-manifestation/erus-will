(defrule MAIN::EI-tap-owner (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state EXEC) (new ?owner)
        (reason $? PLAY ?res&ITEM|ALLY|FACTION $? ?fr))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-tap-owner)))
    (test (and
        (neq start-game-0::initial-items ?fr)
        (neq loc-phase-3-1::play-additional-minor-item ?fr)
    ))
    =>
    (E-modify ?owner state TAPPED MAIN::EI-tap-owner)
    (message "Girar el personaje " ?owner " al obtener un objeto o aliado")
)


(defrule MAIN::EI-tap-location (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state EXEC) (new ?owner)
        (reason $? PLAY ?res&ITEM|ALLY|FACTION $? ?fr))
    (object (is-a LOCATION) (name ?loc))
    (in (over ?loc) (under ?owner))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-tap-location)))
    (test (and
        (neq start-game-0::initial-items ?fr)
        (neq loc-phase-3-1::play-additional-minor-item ?fr)
    ))
    =>
    (E-modify ?loc state TAPPED MAIN::EI-tap-location)
    (message "Girar la localizacion " ?loc " al jugar un objeto, faccion o aliado")
)


(defrule MAIN::EI-move-corruption (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state EXEC) (target ?item) (old ?oldOwner)
        (reason $? ?op&TRANSFER|STORE ITEM $? ?fr&~MAIN::EI-action-reassign-objects))
    (object (name ?item) (position ?owner) (corruption ?c&:(< 0 ?c)))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-move-corruption)))
    =>
    (make-instance (gen-name E-phase) of E-phase 
        (reason corruption-check MAIN::EI-move-corruption) 
        (data target ?owner))
    (message ?oldOwner " debe realizar un chequeo de corrupcion antes de transferir o almacenar objetos que den corrupcion")
)

(defrule MAIN::EI-unfollow (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state EXEC) (target ?char)
        (reason $? DISCARD CHARACTER $?))
	(object (is-a CHARACTER) (name ?char) (position ?fell))
	(object (is-a CHARACTER) (position ?char) (name ?follower))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-unfollow)))
	=>
	(E-modify ?follower position ?fell UNFOLLOW MAIN::EI-unfollow)
	(message "Bajar seguidor " ?follower " antes de descartar el personaje")
)

;   TODO: manejo de elecciones en intercepcion
(defrule MAIN::EI-action-reassign-objects (declare (auto-focus TRUE) (salience ?*E-intercept*))
	(logical
        ; En el caso de los EI's, la constriccion E-modify con EXEC funciona como only-actions
		?e <- (object (is-a E-modify) (state EXEC) (target ?char)
            (reason $? DISCARD CHARACTER $?))
		(object (is-a ITEM) (position ?char) (name ?item))

;   TODO: revisar las condiciones
		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
		(in (over ?fell) (under ?char))

		(object (is-a CHARACTER) (name ?newOwner&:(neq ?char ?newOwner))
			(state UNTAPPED | TAPPED) (player ?p)
		)
		(in (over ?fell) (under ?newOwner))

        (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-action-reassign-objects)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Transfer item " ?item " from " ?char " to " ?newOwner " before discarding it"))
		(identifier ?item ?newOwner)
		(data (create$ ?item position ?newOwner
			TRANSFER ITEM MAIN::EI-action-reassign-objects))
	))
)


;TODO: Manejar objetos al destruir un personaje

(defrule MAIN::EI-creature-attack (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state OUT)
        (reason $? PLAY CREATURE $?) (target ?creature) (new ?fell))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-creature-attack)))
	=>
	(make-instance (gen-name E-phase) of E-phase 
        (reason attack CREATURE MAIN::EI-creature-attack)
        (data fellowship ?fell / attackable ?creature))
	(message "Se inicia el ataque de " ?creature " a " ?fell)
)


(defrule MAIN::EI-manage-tapped-loc (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state OUT) (slot position))
    (object (is-a LOCATION) (name ?loc) (state TAPPED))
    (player ?p)
    (not (exists
        (object (is-a CHARACTER) (name ?char))
        (in (over ?loc) (under ?char))
    ))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-manage-tapped-loc)))
    =>
    (if (member$ HAVEN (class-subclasses (class ?loc))) then
        (E-modify ?loc state UNTAPPED MAIN::EI-manage-tapped-loc)
        (message "Se devuelve " ?loc " al estado inicial")
    else
        (E-modify ?loc position (discardsymbol ?p) DISCARD LOCATION MAIN::EI-manage-tapped-loc)
        (message "Se descarta " ?loc " al no tener personajes, no ser refugio y estar girada")
    )
)

(defrule MAIN::EI-standarize-hand-after-mov (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (state OUT) (reason fell-move $?))
    (object (is-a PLAYER) (name ?p))
    (not (object (is-a EVENT) (position ?e) 
        (reason $? MAIN::EI-standarize-hand-after-mov)
        (data $? target ?p $?)))
    =>
    (make-instance (gen-name E-phase) of E-phase 
        (reason standarize-hand MAIN::EI-standarize-hand-after-mov) 
        (data target ?p))
    (message ?p " repone su mano tras la fase de movimiento")
)

(defrule MAIN::EI-movement-phase (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN) (reason $? P311::action-fell-move)
        (target ?fell) (new ?to))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-movement-phase)))
    =>
    (make-instance (gen-name E-phase) of E-phase
        (reason fell-move MAIN::EI-movement-phase)
        (data fellowship ?fell / to ?to)
    )
)

(defrule MAIN::EI-check-mov-phase (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN) (reason $? P311::action-fell-move))
    (object (is-a E-phase) (state DEFUSED) (reason fell-move $?))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-check-mov-phase)))
    =>
    (E-cancel ?e MAIN::EI-check-mov-phase)
)


(defrule MAIN::EI-check-play-faction (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN)
        (reason $? PLAY FACTION $?) (target ?faction) (new ?char))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-check-play-faction)))
    =>
    (make-instance (gen-name E-phase) of E-phase
        (reason faction-play MAIN::EI-check-play-faction)
        (data faction ?faction / character ?char))
    (message ?char " debe realizar un chequeo de influencia al influenciar la faccion " ?faction)
)

(defrule MAIN::EI-failed-play-faction (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (object (is-a E-phase) (state DEFUSED) (reason faction-play $?))
    ?e <- (object (is-a E-modify) (state IN) (reason $? PLAY FACTION $?) (target ?faction))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-failed-play-faction)))
    =>
    (E-cancel ?e MAIN::EI-failed-play-faction)
    (message "Como no se ha llegado a completar el chequeo de influencia, no se puede jugar la faccion " ?faction)
)

(defrule MAIN::EI-mp-move-faction (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state OUT) (slot position) (target ?faction) (new ?char))
    (object (is-a FACTION) (name ?faction))
    (object (is-a CHARACTER) (name ?char))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-mp-move-faction)))
    =>
    (E-modify ?faction position (mpsymbol (send ?faction get-player))
        MP FACTION MAIN::EI-mp-move-faction)
    (message "La faccion " ?faction " influenciada por " ?char " se mueve a la pila de puntos de victoria")
)


(defrule MAIN::EI-creature-attack#defeated (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (state OUT) 
        (reason $? MAIN::EI-creature-attack)
        (position ?pos))
    (object (is-a E-modify) (name ?pos) (target ?creature))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-creature-attack#defeated)))
    =>
    ;   TODO: es el mp correcto?
    (E-modify ?creature position (mpsymbol (send ?creature get-player))
        MP CREATURE MAIN::EI-creature-attack#defeated)
    (message "Creature " ?creature " has been defeated, moving it to the player's MP")
)

(defrule MAIN::E-creature-attack-fell#undefeated (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (state DEFUSED) 
        (reason $? MAIN::EI-creature-attack)
        (position ?pos))
    (object (is-a E-modify) (name ?pos) (target ?creature))
    (not (object (is-a EVENT) (position ?e) (reason $? E-creature-attack-fell#undefeated)))
    =>
    (E-modify ?creature position (discardsymbol (send ?creature get-player))
        DISCARD CREATURE MAIN::E-creature-attack-fell#undefeated)
    (message "Creature " ?creature " has not been defeated, moving it to enemy's DISCARD")
)


; TODO: Cuando un personaje o aliado falla el chequeo de resistencia debera abandonar el juego, que pasa con las adversidades y ataques automaticos?
; (E-modify ?as position (outofgamesymbol (send ?as get-player))
; 			DESTROY resistance-check-2::execute-resistance-check)


; ; RECOLECTOR DE BASURA
; (defrule MAIN::event-garbage-collector (declare (auto-focus TRUE) 
; 		(salience ?*garbage-collector*))
; 	; Destruye los eventos marcados como terminados
; 	?e <- (object (is-a EVENT | EVENT-PHASE) (type OUT))
; 	=>
; 	(send ?e delete)
; )