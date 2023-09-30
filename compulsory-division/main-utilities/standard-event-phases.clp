; EP-corruption-check
(defclass MAIN::EP-corruption-check (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-corruption-check))

    (slot character (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
	(slot dices (type INTEGER) (default 0))
)


; E-loc-organize
(defclass MAIN::EP-loc-organize (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-loc-organize))

    (slot player (type INSTANCE-NAME) (default ?NONE) (allowed-classes PLAYER))
    (slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)


; E-fell-move
(defclass MAIN::EP-fell-move (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-fell-move))

    (slot fell (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot from (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
    (slot to (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)


; E-fell-remain
(defclass MAIN::EP-fell-remain (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-fell-remain))

    (slot fell (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
); TODO MODULO REMAIN Y MODULO MOVE



;/////////////////// UNIFIED HANDLER //////////////////
(defrule MAIN::ep-start (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
	?ep <- (object (is-a EVENT-PHASE) (type IN) (ep-name ?ep-name))
	(not (object (is-a EVENT-PHASE) (type ONGOING) (ep-name ?ep-name)))
	=>
	(jump ?ep-name)
	(send ?ep put-type ONGOING)
)