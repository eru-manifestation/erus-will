(defrule MAIN::EI-tap-owner (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state EXEC) (new ?owner)
        (reason $? PLAY ?res&ITEM|ALLY $? ?fr))
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
        (reason $? ?op&TRANSFER|STORE ITEM $? ?fr&~MAIN::EI-a-reassign-objects))
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

; ;   TODO: manejo de elecciones en intercepcion
; (defrule MAIN::EI-a-reassign-objects (declare (auto-focus TRUE) (salience ?*E-intercept*))
; 	(logical
;         ; En el caso de los EI's, la constriccion E-modify con EXEC funciona como only-actions
; 		?e <- (object (is-a E-modify) (state EXEC) (target ?char)
;             (reason $? DISCARD CHARACTER $?))
; 		(object (is-a ITEM) (position ?char) (name ?item))

; ;   TODO: revisar las condiciones
; 		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
; 		(in (over ?fell) (under ?char))

; 		(object (is-a CHARACTER) (name ?newOwner&:(neq ?char ?newOwner))
; 			(state UNTAPPED | TAPPED) (player ?p)
; 		)
; 		(in (over ?fell) (under ?newOwner))

;         (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-a-reassign-objects)))
; 	)
; 	=>; TODO: ACTUALIZAR
; 	(assert (action 
; 		(player ?p)
; 		(event-def modify)
; 		(description (sym-cat "Transfer item " ?item " from " ?char " to " ?newOwner " before discarding it"))
; 		(identifier ?item ?newOwner)
; 		(data (create$ ?item position ?newOwner
; 			TRANSFER ITEM MAIN::EI-a-reassign-objects))
; 	))
; )


(defrule MAIN::EI-creature-combat (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state OUT)
        (reason $? PLAY CREATURE $?) (target ?creature) (new ?fell))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-creature-combat)))
	=>
	(make-instance (gen-name E-phase) of E-phase 
        (reason combat CREATURE MAIN::EI-creature-combat)
        (data attack 1 ?fell ?creature))
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
    (message ?p " repone su mano tras la fase de movimiento")
    (make-instance (gen-name E-phase) of E-phase 
        (reason standarize-hand MAIN::EI-standarize-hand-after-mov) 
        (data target ?p))
)

(defrule MAIN::EI-movement-phase (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN) (reason $? P311::a-fell-move)
        (target ?fell) (new ?to))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-movement-phase)))
    =>
    (message "Se ejecuta la fase de movimiento para mover la copañia")
    (make-instance (gen-name E-phase) of E-phase
        (reason fell-move MAIN::EI-movement-phase)
        (data fellowship ?fell / to ?to)
    )
)

(defrule MAIN::EI-check-mov-phase (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN) (reason $? P311::a-fell-move))
    (or (object (is-a E-phase) (position ?e) (state DEFUSED) (reason fell-move $?))
        (object (is-a E-phase) (position ?e) (state OUT) (res UNSUCCESSFUL) (reason fell-move $?)))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-check-mov-phase)))
    =>
    (E-cancel MAIN::EI-check-mov-phase)
)


(defrule MAIN::EI-creature-combat#defeated (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (state OUT) 
        (position ?pos)
        (reason combat $? CREATURE $?) (res DEFEATED))
    (object (is-a E-modify) (name ?pos) (target ?creature))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-creature-combat#defeated)))
    =>
    ;   TODO: es el mp correcto?
    (E-modify ?creature position (mpsymbol (send ?creature get-player))
        MP CREATURE MAIN::EI-creature-combat#defeated)
    (message "La criatura " ?creature " ha sido derrotada, se añade a la pila de puntos de victoria")
)

(defrule MAIN::E-creature-combat-fell#undefeated (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (state OUT|DEFUSED) 
        (position ?pos)
        (reason combat $? CREATURE $?) (res UNDEFEATED|UNDEFINED))
    (object (is-a E-modify) (name ?pos) (target ?creature))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::E-creature-combat-fell#undefeated)))
    =>
    (E-modify ?creature position (discardsymbol (send ?creature get-player))
        DISCARD CREATURE MAIN::E-creature-combat-fell#undefeated)
    (message "La criatura " ?creature " no ha sido derrotada, se mueve al descarte enemigo")
)


(defrule MAIN::EI-tap-unhindered (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (reason strike $?) (state OUT) (res DEFEATED|PARTIALLY-UNDEFEATED))
	(data (phase strike) (data target ?t))
    (object (name ?t) (state UNTAPPED))
    (not (data (phase strike) (data hindered)))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-tap-unhindered)))
	=>
	(E-modify ?t state TAPPED MAIN::EI-tap-unhindered)
)


(defrule MAIN::EI-wound (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (reason strike $?) (state OUT) (res UNDEFEATED))
	(data (phase strike) (data target ?t))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-tap-unhindered)))
	=>
	(E-modify ?t state WOUNDED MAIN::EI-wound)
)


(defrule MAIN::EI-gain-faction (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (reason faction-play $?) (state OUT) (res SUCCESSFUL)
        (data $? character ?char $?) (name ?en))
    (object (name ?en) (data $? faction ?faction $?))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-gain-faction)))
    =>
    (E-modify ?faction position (mpsymbol (send ?faction get-player))
        PLAY FACTION MP FACTION MAIN::EI-gain-faction)
    (message "La faccion " ?faction " influenciada por " ?char " se mueve a la pila de puntos de victoria")
)


(defrule MAIN::EI-discard-faction (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (reason faction-play $?) (state OUT|DEFUSED) (res ~SUCCESSFUL)
        (data $? character ?char $?) (name ?en))
    (object (name ?en) (data $? faction ?faction $?))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-discard-faction)))
    =>
    (E-modify ?faction position (discardsymbol (send ?faction get-player))
        DISCARD MAIN::EI-discard-faction)
    (message "La faccion " ?faction " no ha sido influenciada por " ?char " se mueve a la pila de descarte")
)


(defrule MAIN::EI-failed-res-check (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (object (is-a E-phase) (state OUT) (reason resistance-check $?) (res NOT-PASSED)
        (data $? target ?t $?))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-failed-res-check)))
    =>
    (E-modify ?t position (outofgamesymbol (send ?t get-player))
        OUT-OF-GAME MAIN::EI-failed-res-check)
    (message ?t "se elimina del juego por haber fallado el chequeo de resistencia")
)


(defrule MAIN::EI-failed-corr-check (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (object (is-a E-phase) (state OUT) (reason corruption-check $?) (res NOT-PASSED)
        (data $? target ?t $?))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-failed-corr-check)))
    =>
    (E-modify ?t position (discardsymbol (send ?t get-player))
        DISCARD CHARACTER MAIN::EI-failed-corr-check)
    (message ?t " se descarta por no haber superado el chequeo de resistencia")
)


(defrule MAIN::EI-corrupted-corr-check (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (object (is-a E-phase) (state OUT) (reason corruption-check $?) (res CORRUPTED)
        (data $? target ?t $?))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-corrupted-corr-check)))
    =>
    (E-modify ?t position (outofgamesymbol (send ?t get-player))
        OUT-OF-GAME CHARACTER MAIN::EI-corrupted-corr-check)
    (message ?t " abandona la partida por haberse dejado dominar por la corrupcion")
)

;TODO: Manejar objetos al destruir un personaje