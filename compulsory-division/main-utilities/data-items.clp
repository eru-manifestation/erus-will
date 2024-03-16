(defmessage-handler data-item init after ()
    (send ?self put-position ?self:target)
    (message "Se modifica " ?self:target-slot " de " ?self:target " por " ?self:motive)
    (eval (str-cat 
        "(send [" ?self:target "] modify " ?self:target-slot " (+ (send [" ?self:target"] get-" ?self:target-slot ") " ?self:value "))" ))
)
(defmessage-handler data-item delete before ()
    (message "Se desactiva la modificacion de " ?self:target-slot " de " ?self:target " por " ?self:motive)
    (eval (str-cat 
        "(send [" ?self:target "] modify " ?self:target-slot " (- (send [" ?self:target"] get-" ?self:target-slot ") " ?self:value "))" ))
)


;//////////// DATA ITEM POPULATIONS

; INFO ITEM DE CORRUPTION PARA CHARACTER
(defrule MAIN::DIP-corruption (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CORRUPTION) (name ?corr) (position ?char)
            (corruption ?corruption-value&:(<> ?corruption-value 0)))
        (object (is-a CHARACTER) (name ?char))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot corruption) (target ?char) (value ?corruption-value)
        (motive "el elemento de corrupcion " ?corr))
)

; INFO ITEM DE CANTIDAD DE COMPAÑEROS EN UNA COMPAÑIA 1
(defrule MAIN::DIP-companion (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a FELLOWSHIP) (name ?fell))
        (object (is-a CHARACTER) (race HOBBIT) (name ?char))
        (in (over ?fell) (under ?char))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot companions) (target ?fell) (value 0.5)
        (motive "el hobbit " ?char))
)

; INFO ITEM DE CANTIDAD DE COMPAÑEROS EN UNA COMPAÑIA 2
(defrule MAIN::DIP-companion (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a FELLOWSHIP) (name ?fell))
        (object (is-a CHARACTER) (race ?r&~HOBBIT) (name ?char))
        (in (over ?fell) (under ?char))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot companions) (target ?fell) (value 1)
        (motive "el personaje " ?char))
)


; INFO ITEM PARA INFLUENCE DE CHARACTER
(defrule MAIN::DIP-influence (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CHARACTER) (name ?char))
        (object (is-a CHARACTER) (name ?follower) (position ?char) (mind ?mind))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot influence) (target ?char) (value (- 0 ?mind))
        (motive "el seguidor " ?follower))
)


; INFO ITEM PARA GENERAL INFLUENCE DE PLAYER
(defrule MAIN::DIP-general-influence (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a PLAYER) (name ?p))
        (object (is-a CHARACTER) (name ?char) (position ?fell) (mind ?mind) (player ?p))
        (exists
            (object (is-a FELLOWSHIP) (player ?p) (name ?fell))
        )
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot general-influence) (target ?p) (value (- 0 ?mind))
        (motive "el personaje " ?char))
)


; INFO ITEM PARA HAND DE PLAYER
(defrule MAIN::DIP-hand (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a PLAYER) (name ?p))
        (object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot hand) (target ?p) (value 1)
        (motive "la carta " ?c))
)


; INFO ITEM PARA MP DE PLAYER DESDE CHARACTER
(defrule MAIN::DIP-mp-player#character (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CHARACTER) (player ?p) 
            (position ?pos&:
                (or (eq ?pos (mpsymbol ?p)) 
                    (neq (class ?pos) STACK)
                )
            )
            (mp ?mp&:(<> 0 ?mp)) (name ?char))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp)
        (motive "el personaje " ?char))
)


; INFO ITEM PARA MP DE PLAYER DESDE FACTION
(defrule MAIN::DIP-mp-player#faction (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a FACTION) (player ?p)
            (position ?pos&:(eq ?pos (mpsymbol ?p))) 
            (mp ?mp&:(<> 0 ?mp)) (name ?f))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp)
        (motive "la faccion " ?f))
)


; INFO ITEM PARA MP DE PLAYER DESDE ITEM
(defrule MAIN::DIP-mp-player#item (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a ITEM) (player ?p)
            (position ?pos&:
                (or (eq ?pos (mpsymbol ?p)) 
                    (neq (class ?pos) STACK)
                )
            ) 
            (mp ?mp&:(<> 0 ?mp)) (name ?i))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp)
        (motive "el objeto " ?i))
)


; INFO DE PROWESS PARA CHARACTER DE ITEM
(defrule MAIN::DIP-prowess-character#item (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CHARACTER) (name ?char))
        (object (is-a ITEM) (player ?p) (position ?char) (prowess ?prowess&~0)
            (max-prowess ?mp) (name ?i))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot prowess) (target ?char) 
        (value (max 0 (min ?prowess (- ?mp (send ?char get-prowess)))))
        (motive "el objeto " ?i))
)


; INFO DE BODY PARA CHARACTER DE ITEM
(defrule MAIN::DIP-body-character#item (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CHARACTER) (name ?char))
        (object (is-a ITEM) (player ?p) (position ?char) (body ?body&~0)
            (max-body ?mb) (name ?i))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot body) (target ?char) 
        (value (max 0 (min ?body (- ?mb (send ?char get-body)))))
        (motive "el objeto " ?i))
)


; INFO ITEM PARA MP DE PLAYER DESDE ALLY
(defrule MAIN::DIP-mp-player#ally (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a ALLY) (mp ?mp&:(<> 0 ?mp)) (player ?p)
        (position ?pos&:
            (or (eq ?pos (mpsymbol ?p)) 
                (neq (class ?pos) STACK)
            )
        )
        (name ?a))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp)
        (motive "el aliado " ?a))
)


; INFO ITEM PARA MP DE PLAYER DESDE CREATURE
(defrule MAIN::DIP-mp-player#creature (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CREATURE) (mp ?mp&:(<> 0 ?mp)) (player ?p)
            ;   TODO: queda por ver donde poner esta criatura cuando cuente para los ptos de victoria
            (position ?pos&:(eq ?pos (mpsymbol ?p)))  
            (name ?c))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target (enemy ?p)) (value ?mp)
        (motive "la criatura derrotada " ?c))
)


; strike-5
(defrule MAIN::DIP-strike-hindered (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (data (phase strike) (data hindered))
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
	    (object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value -3)
        (motive "reservarse fuerzas en el golpe"))
)

; strike-5
(defrule MAIN::DIP-strike-tapped (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (data (phase strike) (data target ?char))
        (object (name ?char) (state TAPPED))
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
	    (object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value -1)
        (motive "estar agotado"))
)

; strike-5
(defrule MAIN::DIP-strike-wounded (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (data (phase strike) (data target ?char))
        (object (name ?char) (state WOUNDED))
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
	    (object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value -2)
        (motive "estar herido"))
)

; strike-5
(defrule MAIN::DIP-strike-spare (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (data (phase strike) (data spare-strike))
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
	    (object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value -1)
        (motive "haber asignado un golpe extra como modificador"))
)


; resistance-check-1
(defrule MAIN::DIP-res-check-wounded (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason resistance-check $?))
	    (object (is-a E-phase) (position ?e) (reason dices RESISTANCE-ROLL $?) (state DONE) (name ?d))
        (data (phase resistance-check) (data target ?char))
        (object (name ?char) (state WOUNDED))
    )
	=>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 1)
        (motive "estar herido"))
)


; faction-play-1
(defrule MAIN-DIP-influence-faction-race (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason faction-play $?))
        (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE $?) (state DONE) (name ?d))
	
        (data (phase faction-play) (data faction ?faction))
        (data (phase faction-play) (data char ?char))
        (object (name ?char) (race ?race))
        (object (name ?faction) (influence-modifiers $? ?race ?value $?))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value ?value)
        (motive "ser de raza " ?race))
)