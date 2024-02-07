(defmessage-handler data-item init after ()
    (send ?self put-position ?self:target)
    (eval (str-cat 
        "(send [" ?self:target "] modify " ?self:target-slot " (+ (send [" ?self:target"] get-" ?self:target-slot ") " ?self:value "))" ))
)
(defmessage-handler data-item delete before ()
    (eval (str-cat 
        "(send [" ?self:target "] modify " ?self:target-slot " (- (send [" ?self:target"] get-" ?self:target-slot ") " ?self:value "))" ))
)

; INFO ITEM DE CORRUPTION PARA CHARACTER
(defrule MAIN::corruption-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a CORRUPTION) (name ?corr) (corruption ?corruption-value&:(<> ?corruption-value 0)))
        (object (is-a CHARACTER) (name ?char))
        (in (transitive FALSE) (over ?char) (under ?corr))
    )
    =>
    (debug Se crea el corruption data item de ?corr para ?char)
    (make-instance (gen-name data-item) of data-item (target-slot corruption) (target ?char) (value ?corruption-value))
)

; INFO ITEM DE CANTIDAD DE COMPAÑEROS EN UNA COMPAÑIA
(defrule MAIN::companion-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a FELLOWSHIP) (name ?fell))
        (object (is-a CHARACTER) (name ?char))
        (in (over ?fell) (under ?char))
    )
    =>
    (debug Se crea el companion data item de ?char para ?fell)
    (make-instance (gen-name data-item) of data-item (target-slot companions) (target ?fell) (value 1))
)


; INFO ITEM PARA INFLUENCE DE CHARACTER
(defrule MAIN::influence-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a CHARACTER) (name ?char))
        (object (is-a CHARACTER) (name ?follower) (mind ?mind))
        (in (transitive FALSE) (over ?char) (under ?follower))
    )
    =>
    (debug Se crea el influence item por ?follower para ?char)
    (make-instance (gen-name data-item) of data-item (target-slot influence) (target ?char) (value (- 0 ?mind)))
)


; INFO ITEM PARA GENERAL INFLUENCE DE PLAYER
(defrule MAIN::general-influence-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a PLAYER) (name ?p))
        (object (is-a CHARACTER) (name ?char) (mind ?mind) (player ?p))
        (exists
            (object (is-a FELLOWSHIP) (player ?p) (name ?fell))
            (in (transitive FALSE) (over ?fell) (under ?char))
        )
    )
    =>
    (debug Se crea el general influence item por ?char para el jugador ?p)
    (make-instance (gen-name data-item) of data-item (target-slot general-influence) (target ?p) (value (- 0 ?mind)))
)


; INFO ITEM PARA HAND DE PLAYER
(defrule MAIN::hand-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a PLAYER) (name ?p))
        (object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
    )
    =>
    (debug Se crea el hand item por ?c para el jugador ?p)
    (make-instance (gen-name data-item) of data-item (target-slot hand) (target ?p) (value 1))
)


; INFO ITEM PARA DICES DE INFLUENCE-CHECK EN LOC PHASE
(defrule MAIN::faction-play-dices-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a EP-faction-play) (name ?ep-loc-phase) (faction ?faction) (char ?char))
        (object (is-a CHARACTER) (name ?char) (race ?race))
        (object (is-a FACTION) (name ?faction) (influence-modifiers $? ?race ?value $?))
    )
    =>
    (debug Se crea el dices item por ?char y ?faction)
    (make-instance (gen-name data-item) of data-item (target-slot dices) (target ?ep-loc-phase) (value ?value))
)


; INFO ITEM PARA MP DE PLAYER DESDE CHARACTER
(defrule MAIN::mp-player-data-item-population#character (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a CHARACTER) (name ?char) (state WOUNDED | TAPPED | UNTAPPED) (player ?p) (mp ?mp&:(<> 0 ?mp)))
    )
    =>
    (debug Se crea el mp item por ?char para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp))
)


; INFO ITEM PARA MP DE PLAYER DESDE FACTION
(defrule MAIN::mp-player-data-item-population#faction (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a FACTION) (name ?f) (player ?p) (position ?pos&:(eq ?pos (mpsymbol ?p))) (mp ?mp&:(<> 0 ?mp)))
    )
    =>
    (debug Se crea el mp item por ?f para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp))
)


; INFO ITEM PARA MP DE PLAYER DESDE ITEM
(defrule MAIN::mp-player-data-item-population#item (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a ITEM) (name ?i) (state TAPPED | UNTAPPED) (player ?p) (mp ?mp&:(<> 0 ?mp)))
    )
    =>
    (debug Se crea el mp item por ?i para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp))
)


; INFO ITEM PARA MP DE PLAYER DESDE ALLY
(defrule MAIN::mp-player-data-item-population#ally (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a ALLY) (name ?a) (state TAPPED | UNTAPPED) (player ?p) (mp ?mp&:(<> 0 ?mp)))
        ;TODO: son los unicos estados?
    )
    =>
    (debug Se crea el mp item por ?a para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp))
)


; INFO ITEM PARA MP DE PLAYER DESDE CREATURE
(defrule MAIN::mp-player-data-item-population#creature (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a CREATURE) (name ?c) (player ?p) (position ?pos&:(eq ?pos (mpsymbol ?p))) (mp ?mp&:(<> 0 ?mp)))
    )
    =>
    (debug Se crea el mp item por ?c para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target (enemy ?p)) (value ?mp))
)


; INFO ITEM PARA STRIKES DE ATTACKABLE
(defrule MAIN::strikes-attackable-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a E-select-strike) (type IN) (char ?char) (attackable ?attackable))
    )
    =>
    (debug Se crea el strike item por ?char para ?attackable)
    (make-instance (gen-name data-item) of data-item (target-slot strikes) (target ?attackable) (value -1))
)


; INFO ITEM PARA DICES DE STRIKE
(defrule MAIN::dices-strike-data-item-population#tapped (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a EP-strike) (name ?ep) (type ONGOING) (char ?char))
        (object (is-a CHARACTER) (name ?char) (state TAPPED))
    )
    =>
    (debug Se crea el dices item por ?char para ?ep)
    (make-instance (gen-name data-item) of data-item (target-slot dices) (target ?ep) (value -1))
)


; INFO ITEM PARA DICES DE STRIKE
(defrule MAIN::dices-strike-data-item-population#wounded (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a EP-strike) (name ?ep) (type ONGOING) (char ?char))
        (object (is-a CHARACTER) (name ?char) (state WOUNDED))
    )
    =>
    (debug Se crea el dices item por ?char para ?ep)
    (make-instance (gen-name data-item) of data-item (target-slot dices) (target ?ep) (value -2))
)


; INFO ITEM PARA DICES DE STRIKE
(defrule MAIN::dices-strike-data-item-population#additional (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a EP-strike) (name ?ep) (type ONGOING) (char ?char))
        (object (is-a EP-strike) (name ?ep1) (type OUT) (char ?char))
    )
    =>
    (debug Se crea el dices item por ?ep1 para ?ep)
    (make-instance (gen-name data-item) of data-item (target-slot dices) (target ?ep) (value -1))
)


; INFO ITEM PARA DICES DE STRIKE
(defrule MAIN::dices-strike-data-item-population#hindered (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a EP-strike) (name ?ep) (type ONGOING) (hindered TRUE))
    )
    =>
    (debug Se crea el dices item por hindered para ?ep)
    (make-instance (gen-name data-item) of data-item (target-slot dices) (target ?ep) (value -3))
)


; INFO ITEM PARA DICES DE RESISTANCE-CHECK
(defrule MAIN::dices-resistance-check-data-item-population#hurt (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
	    (object (is-a EP-resistance-check) (name ?ep) (type ONGOING) (assaulted ?as))
        (object (is-a CHARACTER) (name ?as) (state WOUNDED))
    )
    =>
    (debug Se crea el dices item por hurt para ?ep)
    (make-instance (gen-name data-item) of data-item (target-slot dices) (target ?ep) (value -1))
)