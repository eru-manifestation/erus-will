(defrule MAIN::EI-tap-owner (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-play) (state EXEC) (target ?res) (new ?owner)
        (reason ?fr))
    (object (is-a ITEM|ALLY) (name ?res))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-tap-owner)))
    (test (and
        (neq start-game-0::initial-items ?fr)
        (neq loc-phase-3-1::play-additional-minor-item ?fr)
    ))
    =>
    (E-modify ?owner state TAPPED MAIN::EI-tap-owner)
    (message "Girar el personaje " ?owner " al obtener un objeto o aliado")
)


(defrule MAIN::EI-tap-location (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-play) (state EXEC) (target ?res) (new ?owner)
        (reason ?fr))
    (object (is-a ITEM|ALLY|FACTION) (name ?res))
    (object (is-a LOCATION) (name ?loc))
    (in (over ?loc) (under ?owner))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-tap-location)))
    (test (and
        (neq start-game-0::initial-items ?fr)
        (neq loc-phase-3-1::play-additional-minor-item ?fr)
    ))
    =>
    (message "Girar la localizacion " ?loc " al jugar un objeto, faccion o aliado")
    (E-modify ?loc state TAPPED MAIN::EI-tap-location)
)


(defrule MAIN::EI-move-corruption (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state EXEC) (target ?item) (old ?oldOwner)
        (reason ?fr&~MAIN::EI-a-reassign-objects))
    (object (name ?item) (position ?owner) (corruption ?c&:(< 0 ?c)))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-move-corruption)))
    (test (or 
        (eq ?fr P-1-1-1::a-item-store)
        (eq ?fr P-1-1-1::a-item-transfer)
    ))
    =>
    (make-instance (gen-name EP-corruption-check) of EP-corruption-check 
        (reason MAIN::EI-move-corruption) 
        (target ?owner))
    (message ?oldOwner " debe realizar un chequeo de corrupcion antes de transferir o almacenar objetos que den corrupcion")
)

(defrule MAIN::EI-unfollow (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-discard) (state EXEC) (target ?char))
	(object (is-a CHARACTER) (name ?char) (position ?fell))
	(object (is-a CHARACTER) (position ?char) (name ?follower))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-unfollow)))
	=>
	(E-modify ?follower position ?fell MAIN::EI-unfollow)
	(message "Bajar seguidor " ?follower " antes de descartar el personaje")
)

;   TODO: manejo de elecciones en intercepcion
; (defrule MAIN::EI-a-reassign-objects (declare (auto-focus TRUE) (salience ?*E-intercept*))
; 	(logical
;         En el caso de los EI's, la constriccion E-modify con EXEC funciona como only-actions
; 		?e <- (object (is-a E-discard) (state EXEC) (target ?char))
;         (object (is-a CHARACTER) (name ?char))
; 		(object (is-a ITEM) (position ?char) (name ?item))

;   TODO: revisar las condiciones
; 		(object (is-a FELLOWSHIP) (name ?fell) (player ?p))
; 		(in (over ?fell) (under ?char))

; 		(object (is-a CHARACTER) (name ?newOwner&:(neq ?char ?newOwner))
; 			(state UNTAPPED | TAPPED) (player ?p)
; 		)
; 		(in (over ?fell) (under ?newOwner))

;         (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-a-reassign-objects)))
; 	)
; 	=>; TODO: ACTUALIZAR
; 	(assert (action 
; 		(player ?p)
; 		(event-def modify)
; 		(description (sym-cat "Transfer item " ?item " from " ?char " to " ?newOwner " before discarding it"))
; 		(identifier ?item ?newOwner)
; 		(data ?item position ?newOwner)
; 		(reason MAIN::EI-a-reassign-objects)
; 	))
; )


(defrule MAIN::EI-creature-combat (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-play) (state OUT) (target ?creature) (new ?fell))
    (object (is-a CREATURE) (name ?creature))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-creature-combat)))
	=>
	(make-instance (gen-name EP-combat) of EP-combat
        (reason MAIN::EI-creature-combat)
        (attackables ?creature)
        (target ?fell))
	(message "Se inicia el ataque de " ?creature " a " ?fell)
)

; TODO: rediseñar
(defrule MAIN::EI-manage-tapped-loc (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state OUT) (slot position))
    (object (is-a LOCATION) (name ?loc) (state TAPPED))
    (player ?p)
    (not (exists
        (object (is-a CHARACTER) (name ?char))
        (in (over ?loc) (under ?char))
    ))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-manage-tapped-loc)))
    =>
    (if (member$ HAVEN (class-subclasses (class ?loc))) then
        (E-modify ?loc state UNTAPPED MAIN::EI-manage-tapped-loc)
        (message "Se devuelve " ?loc " al estado inicial")
    else
        (E-discard ?loc MAIN::EI-manage-tapped-loc)
        (message "Se descarta " ?loc " al no tener personajes, no ser refugio y estar girada")
    )
)

(defrule MAIN::EI-standarize-hand-after-mov (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a EP-fell-move) (state OUT))
    (object (is-a PLAYER) (name ?p))
    (not (object (is-a EVENT) (position ?e) 
        (reason MAIN::EI-standarize-hand-after-mov)
        (target ?p)))
    =>
    (message ?p " repone su mano tras la fase de movimiento")
    (make-instance (gen-name EP-standarize-hand) of EP-standarize-hand 
        (reason MAIN::EI-standarize-hand-after-mov) 
        (target ?p))
)

(defrule MAIN::EI-movement-phase (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN) (reason P-3-1-1::a-fell-move)
        (target ?fell) (new ?to))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-movement-phase)))
    =>
    (message "Se ejecuta la fase de movimiento para mover la copañia")
    (make-instance (gen-name EP-fell-move) of EP-fell-move
        (reason MAIN::EI-movement-phase)
        (fellowship ?fell)
        (to ?to)
    )
)

(defrule MAIN::EI-check-mov-phase (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN) (reason P-3-1-1::a-fell-move))
    (or (object (is-a EP-fell-move) (position ?e) (state DEFUSED))
        (object (is-a EP-fell-move) (position ?e) (state OUT) (res UNSUCCESSFUL)))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-check-mov-phase)))
    =>
    (E-cancel MAIN::EI-check-mov-phase)
)


(defrule MAIN::EI-creature-combat#defeated (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a EP-combat) (state OUT) 
        (position ?pos) (res DEFEATED))
    (object (is-a EP-attack) (position ?e) (attackable ?creature))
    (object (is-a CREATURE) (name ?creature)) ; TODO: Informarse si es correcto, que compone un combate
    ;(object (is-a E-modify) (name ?pos) (target ?creature))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-creature-combat#defeated)))
    =>
    ;   TODO: es el mp correcto?
    (E-modify ?creature position (mpsymbol (send ?creature get-player))
        MAIN::EI-creature-combat#defeated)
    (message "La criatura " ?creature " ha sido derrotada, se añade a la pila de puntos de victoria")
)

(defrule MAIN::E-creature-combat-fell#undefeated (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a EP-combat) (state OUT) 
        (position ?pos) (res UNDEFEATED|UNDEFINED))
    (object (is-a EP-attack) (position ?e) (attackable ?creature))
    (object (is-a CREATURE) (name ?creature)) ; TODO: Informarse si es correcto, que compone un combate
    ;(object (is-a E-modify) (name ?pos) (target ?creature))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::E-creature-combat-fell#undefeated)))
    =>
    (E-discard ?creature MAIN::E-creature-combat-fell#undefeated)
    (message "La criatura " ?creature " no ha sido derrotada, se mueve al descarte enemigo")
)


(defrule MAIN::EI-tap-unhindered (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a EP-strike) (state OUT) (res DEFEATED|PARTIALLY-UNDEFEATED) (target ?t) (hindered FALSE))
    (object (name ?t) (state UNTAPPED))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-tap-unhindered)))
	=>
	(E-modify ?t state TAPPED MAIN::EI-tap-unhindered)
)


(defrule MAIN::EI-wound (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a EP-strike) (state OUT) (res UNDEFEATED) (target ?t))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-wound)))
	=>
	(E-modify ?t state WOUNDED MAIN::EI-wound)
)


(defrule MAIN::EI-gain-faction (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a EP-faction-play) (state OUT) (res SUCCESSFUL)
        (character ?char) (faction ?faction) (name ?en))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-gain-faction)))
    =>
    (E-play ?faction (mpsymbol (send ?faction get-player)) MAIN::EI-gain-faction)
    (message "La faccion " ?faction " influenciada por " ?char " se mueve a la pila de puntos de victoria")
)


(defrule MAIN::EI-discard-faction (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a EP-faction-play) (state OUT|DEFUSED) (res ~SUCCESSFUL)
        (character ?char) (faction ?faction) (name ?en))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-discard-faction)))
    =>
    (E-discard ?faction MAIN::EI-discard-faction)
    (message "La faccion " ?faction " no ha sido influenciada por " ?char " se mueve a la pila de descarte")
)


(defrule MAIN::EI-failed-res-check (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (object (is-a EP-resistance-check) (state OUT) (res NOT-PASSED)
        (target ?t))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-failed-res-check)))
    =>
    (E-modify ?t position (outofgamesymbol (send ?t get-player))
        MAIN::EI-failed-res-check)
    (message ?t "se elimina del juego por haber fallado el chequeo de resistencia")
)


(defrule MAIN::EI-failed-corr-check (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (object (is-a EP-corruption-check) (state OUT) (res NOT-PASSED)
        (target ?t))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-failed-corr-check)))
    =>
    (message ?t " se descarta por no haber superado el chequeo de resistencia")
    (E-discard ?t MAIN::EI-failed-corr-check)
)


(defrule MAIN::EI-corrupted-corr-check (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (object (is-a EP-corruption-check) (state OUT) (res CORRUPTED)
        (target ?t))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-corrupted-corr-check)))
    =>
    (E-modify ?t position (outofgamesymbol (send ?t get-player))
        MAIN::EI-corrupted-corr-check)
    (message ?t " abandona la partida por haberse dejado dominar por la corrupcion")
)


(defrule MAIN::EI-unique (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-play) (state IN) (target ?t))
    (object (is-a CARD) (name ?t) (unique TRUE))
    (exists 
        (object (is-a STACK) (player ?p) (name ?hand&:(eq ?hand (handsymbol ?p))))
        (object (is-a STACK) (player ?p) (name ?draw&:(eq ?draw (drawsymbol ?p))))
        (object (is-a STACK) (player ?p) (name ?discard&:(eq ?discard (discardsymbol ?p))))
        (object (is-a E-play) (state DONE) (target ?c2))
        (object (is-a CARD) (unique TRUE) (name ?c2&:(eq (class ?c2) (class ?t)))
            (position ~?hand&~?draw&~?discard))
    )
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-unique)))
    =>
    (E-cancel MAIN::EI-unique)
    (message ?t " no se puede volver a jugar, es una carta unica que ya ha aparecido")
)

;TODO: Manejar objetos al destruir un personaje