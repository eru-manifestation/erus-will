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
(defrule MAIN::corruption-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CORRUPTION) (name ?corr) (position ?char)
            (corruption ?corruption-value&:(<> ?corruption-value 0)))
        (object (is-a CHARACTER) (name ?char))
    )
    =>
    (message Se crea el corruption data item de ?corr para ?char)
    (make-instance (gen-name data-item) of data-item (target-slot corruption) (target ?char) (value ?corruption-value))
)

; INFO ITEM DE CANTIDAD DE COMPAÑEROS EN UNA COMPAÑIA 1
(defrule MAIN::companion-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a FELLOWSHIP) (name ?fell))
        (object (is-a CHARACTER) (race HOBBIT) (name ?char))
        (in (over ?fell) (under ?char))
    )
    =>
    (message Se crea el companion data item de ?char para ?fell)
    (make-instance (gen-name data-item) of data-item (target-slot companions) (target ?fell) (value 0.5))
)

; INFO ITEM DE CANTIDAD DE COMPAÑEROS EN UNA COMPAÑIA 2
(defrule MAIN::companion-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a FELLOWSHIP) (name ?fell))
        (object (is-a CHARACTER) (race ?r&~HOBBIT) (name ?char))
        (in (over ?fell) (under ?char))
    )
    =>
    (message Se crea el companion data item de ?char para ?fell)
    (make-instance (gen-name data-item) of data-item (target-slot companions) (target ?fell) (value 1))
)


; INFO ITEM PARA INFLUENCE DE CHARACTER
(defrule MAIN::influence-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CHARACTER) (name ?char))
        (object (is-a CHARACTER) (name ?follower) (position ?char) (mind ?mind))
    )
    =>
    (message Se crea el influence item por ?follower para ?char)
    (make-instance (gen-name data-item) of data-item (target-slot influence) (target ?char) (value (- 0 ?mind)))
)


; INFO ITEM PARA GENERAL INFLUENCE DE PLAYER
(defrule MAIN::general-influence-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a PLAYER) (name ?p))
        (object (is-a CHARACTER) (name ?char) (position ?fell) (mind ?mind) (player ?p))
        (exists
            (object (is-a FELLOWSHIP) (player ?p) (name ?fell))
        )
    )
    =>
    (message Se crea el general influence item por ?char para el jugador ?p)
    (make-instance (gen-name data-item) of data-item (target-slot general-influence) (target ?p) (value (- 0 ?mind)))
)


; INFO ITEM PARA HAND DE PLAYER
(defrule MAIN::hand-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a PLAYER) (name ?p))
        (object (is-a CARD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?c))
    )
    =>
    (message Se crea el hand item por ?c para el jugador ?p)
    (make-instance (gen-name data-item) of data-item (target-slot hand) (target ?p) (value 1))
)


; INFO ITEM PARA MP DE PLAYER DESDE CHARACTER
(defrule MAIN::mp-player-data-item-population#character (declare (auto-focus TRUE) (salience ?*universal-rules*))
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
    (message Se crea el mp item por ?char para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp))
)


; INFO ITEM PARA MP DE PLAYER DESDE FACTION
(defrule MAIN::mp-player-data-item-population#faction (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a FACTION) (player ?p)
            (position ?pos&:(eq ?pos (mpsymbol ?p))) 
            (mp ?mp&:(<> 0 ?mp)) (name ?f))
    )
    =>
    (message Se crea el mp item por ?f para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp))
)


; INFO ITEM PARA MP DE PLAYER DESDE ITEM
(defrule MAIN::mp-player-data-item-population#item (declare (auto-focus TRUE) (salience ?*universal-rules*))
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
    (message Se crea el mp item por ?i para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp))
)


; INFO ITEM PARA MP DE PLAYER DESDE ALLY
(defrule MAIN::mp-player-data-item-population#ally (declare (auto-focus TRUE) (salience ?*universal-rules*))
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
    (message Se crea el mp item por ?a para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value ?mp))
)


; INFO ITEM PARA MP DE PLAYER DESDE CREATURE
(defrule MAIN::mp-player-data-item-population#creature (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CREATURE) (mp ?mp&:(<> 0 ?mp)) (player ?p)
            ;   TODO: queda por ver donde poner esta criatura cuando cuente para los ptos de victoria
            (position ?pos&:(eq ?pos (mpsymbol ?p)))  
            (name ?c))
    )
    =>
    (message Se crea el mp item por ?c para ?p)
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target (enemy ?p)) (value ?mp))
)




; INFO ITEM PARA DICES DE RESISTANCE-CHECK
; (defrule MAIN::dices-resistance-check-data-item-population#hurt (declare (auto-focus TRUE) (salience ?*universal-rules*))
;     (logical
; 	    (object (is-a EP-resistance-check) (name ?ep) (type ONGOING) (assaulted ?as))
;         (object (is-a CHARACTER) (name ?as) (state WOUNDED))
;     )
;     =>
;     (message Se crea el dices item por hurt para ?ep)
;     (make-instance (gen-name data-item) of data-item (target-slot dices) (target ?ep) (value -1))
; )