(defmessage-handler data-item-add init after ()
    (send ?self put-position ?self:target)
    (bind ?value (+ (send ?self:target (sym-cat get- ?self:target-slot)) ?self:value))
    (message "Se modifica " ?self:target-slot " de " ?self:target " por " ?self:motive " (" ?value ")")
    (send ?self:target modify ?self:target-slot ?value)
)
(defmessage-handler data-item-add delete before ()
    (bind ?value (- (send ?self:target (sym-cat get- ?self:target-slot)) ?self:value))
    (message "Se desactiva la modificacion de " ?self:target-slot " de " ?self:target " por " ?self:motive " (" ?value ")")
    (send ?self:target modify ?self:target-slot ?value)
)

(defmessage-handler data-item-remove init after ()
    (send ?self put-position ?self:target)
    (message "Se modifica " ?self:target-slot " de " ?self:target " por " ?self:motive)
    (bind ?index (member$ ?self:value (send ?self:target (sym-cat get- ?self:target-slot))))
    (slot-delete$ ?self:target ?self:target-slot ?index ?index)
)
(defmessage-handler data-item-remove delete before ()
    (message "Se desactiva la modificacion de " ?self:target-slot " de " ?self:target " por " ?self:motive)
    (slot-insert$ ?self:target ?self:target-slot 1 ?self:value)
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot corruption) (target ?char) (value ?corruption-value)
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot companions) (target ?fell) (value 0.5)
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot companions) (target ?fell) (value 1)
        (motive "el personaje " ?char))
)


; INFO ITEM PARA INFLUENCE DE CHARACTER
(defrule MAIN::DIP-influence (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CHARACTER) (name ?char))
        (object (is-a CHARACTER) (name ?follower) (position ?char) (mind ?mind))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot influence) (target ?char) (value (- 0 ?mind))
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot general-influence) (target ?p) (value (- 0 ?mind))
        (motive "el personaje " ?char))
)


; INFO ITEM PARA HAND DE PLAYER
(defrule MAIN::DIP-hand (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a PLAYER) (name ?p))
        (object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot hand) (target ?p) (value 1)
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot mp) (target ?p) (value ?mp)
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot mp) (target ?p) (value ?mp)
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot mp) (target ?p) (value ?mp)
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot prowess) (target ?char) 
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot body) (target ?char) 
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot mp) (target ?p) (value ?mp)
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
    (make-instance (gen-name data-item-add) of data-item-add (target-slot mp) (target (enemy ?p)) (value ?mp)
        (motive "la criatura derrotada " ?c))
)


; strike-5
(defrule MAIN::DIP-strike-hindered (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-strike) (active TRUE) (hindered TRUE))
	    (object (is-a EP-strike-roll) (position ?e) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot res) (target ?d) (value -3)
        (motive "reservarse fuerzas en el golpe"))
)

; strike-5
(defrule MAIN::DIP-strike-tapped (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-strike) (active TRUE) (target ?char))
        (object (name ?char) (state TAPPED))
	    (object (is-a EP-strike-roll) (position ?e) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot res) (target ?d) (value -1)
        (motive "estar agotado"))
)

; strike-5
(defrule MAIN::DIP-strike-wounded (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-strike) (active TRUE) (target ?char))
        (object (name ?char) (state WOUNDED))
	    (object (is-a EP-strike-roll) (position ?e) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot res) (target ?d) (value -2)
        (motive "estar herido"))
)

; strike-5
(defrule MAIN::DIP-strike-spare (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-strike) (active TRUE) (spare-strike TRUE))
	    (object (is-a EP-strike-roll) (position ?e) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot res) (target ?d) (value -1)
        (motive "haber asignado un golpe extra como modificador"))
)


; resistance-check-1
(defrule MAIN::DIP-res-check-wounded (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-resistance-check) (active TRUE) (target ?char))
	    (object (is-a EP-resistance-roll) (position ?e) (state DONE) (name ?d))
        (object (name ?char) (state WOUNDED))
    )
	=>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot res) (target ?d) (value 1)
        (motive "estar herido"))
)


; faction-play-1
(defrule MAIN::DIP-influence-faction-race (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-faction-play) (active TRUE) (faction ?faction) (character ?char))
        (object (is-a EP-faction-influence-roll) (position ?e) (state DONE) (name ?d))
        (object (name ?char) (race ?race))
        (object (name ?faction) (influence-modifiers $? ?race ?value $?))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot res) (target ?d) (value ?value)
        (motive "ser de raza " ?race))
)


(defrule MAIN::DIP-asigned-strike (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-attack) (active TRUE) (attackable ?at) (name ?attack))
        (or
            (object (is-a EP-attack) (name ?attack) (strikes $? ? $?))
            (object (is-a EP-strike) (position ?e) (reason attack-4::a-strike))
        )
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot strikes) (target ?at) (value -1)
        (motive "el golpe asignado"))
)


(defrule MAIN::DIP-executed-strike (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-attack) (active TRUE) (name ?attack))
        (object (is-a EP-strike) (position ?e) (reason attack-4::a-strike) (target ?char))
    )
    =>
    (make-instance (gen-name data-item-remove) of data-item-remove (target-slot strikes) (target ?attack) (value ?char)
        (motive "la ejecucion del golpe a " ?char))
)


(defrule MAIN::DIP-executed-attack (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-combat) (active TRUE) (name ?combat))
        (object (is-a EP-attack) (position ?e) (reason combat-1::attack) (attackable ?at))
    )
    =>
    (make-instance (gen-name data-item-remove) of data-item-remove (target-slot attackables) (target ?combat) (value ?at)
        (motive "la ejecucion del ataque de " ?at))
)

(defrule MAIN::DIP-card-drawn (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a EP-draw) (active TRUE) (name ?draw))
        (object (is-a E-modify) (position ?e) (reason draw-0::card-draw))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot ammount) (target ?draw) (value -1)
        (motive "haber robado"))
)


(defrule MAIN::DIP-fell-move-draw#enemy (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (enemy ?enemy)
        ?e <- (object (is-a EP-fell-move) (active TRUE) (name ?fm))
        (object (is-a EP-draw) (position ?e) (state DONE) (target ?enemy) (ammount ?ammount))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot enemy-draw) (target ?fm) (value (- 0 ?ammount))
        (motive "haber robado " ?ammount))
)

(defrule MAIN::DIP-fell-move-draw#player (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (player ?p)
        ?e <- (object (is-a EP-fell-move) (active TRUE) (name ?fm))
        (object (is-a EP-draw) (position ?e) (state DONE) (target ?p) (ammount ?ammount))
    )
    =>
    (make-instance (gen-name data-item-add) of data-item-add (target-slot player-draw) (target ?fm) (value (- 0 ?ammount))
        (motive "haber robado " ?ammount))
)
