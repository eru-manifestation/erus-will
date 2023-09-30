(defclass MAIN::data-item (is-a NUMERABLE)
    (slot instance-# (source composite))
    (slot active (type SYMBOL) (default TRUE) (allowed-symbols TRUE FALSE))
    (slot target (type SYMBOL) (default ?NONE))
    (slot target-slot (type SYMBOL) (default ?NONE))
    (slot value (type INTEGER) (default ?NONE))
)
(defmessage-handler data-item init after ()
    (eval (str-cat 
        "(send [" ?self:target "] put-" ?self:target-slot " (+ (send [" ?self:target"] get-" ?self:target-slot ") " ?self:value "))" ))
)
(defmessage-handler data-item delete before ()
    (eval (str-cat 
        "(send [" ?self:target "] put-" ?self:target-slot " (- (send [" ?self:target"] get-" ?self:target-slot ") " ?self:value "))" ))
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
        (object (is-a CARD) (player ?p) (state HAND) (name ?c))
    )
    =>
    (debug Se crea el hand item por ?c para el jugador ?p)
    (make-instance (gen-name data-item) of data-item (target-slot hand) (target ?p) (value 1))
)