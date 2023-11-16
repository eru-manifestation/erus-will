; INFO ITEM DE CORRUPTION PARA CHARACTER

(deftemplate MAIN::corruption-data-item
    (slot char (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot value (type INTEGER) (default ?NONE))
    (slot id (type SYMBOL) (default-dynamic (gensym)))
)


(defmessage-handler CHARACTER get-corruption()
	(bind ?res (- 0 ?self:corruption))
	(do-for-all-facts ((?data corruption-data-item)) (eq ?data:char (instance-name ?self))
        (bind ?res (+ ?res ?data:value))
    )
    ?res
)

(defrule MAIN::corruption-data-item-population (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    (logical
        (object (is-a CORRUPTION) (name ?corr) (corruption ?corruption-value&:(<> ?corruption-value 0)))
        (object (is-a CHARACTER) (name ?char))
        (in (transitive FALSE) (over ?char) (under ?corr))
    )
    =>
    (debug Se crea el corruption item de ?corr para ?char)
    (assert (corruption-data-item (char ?char) (value ?corruption-value)))
)