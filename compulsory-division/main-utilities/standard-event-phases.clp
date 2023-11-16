; EP-corruption-check
(defclass MAIN::EP-corruption-check (is-a EVENT-PHASE)
    (slot ini (type SYMBOL) (default CORRUPTION-CHECK))
	(slot ep-name (type SYMBOL) (default corruption-check-1-1-1))

    (slot character (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
	(slot dices (type INTEGER) (default 0))
)



;/////////////////// UNIFIED HANDLER //////////////////
(defrule MAIN::ep-start (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
	?ep <- (object (is-a EVENT-PHASE) (type IN) (ep-name ?ep-name) (ini ?ini))
	(not (object (is-a EVENT-PHASE) (type ONGOING) (ep-name ?ep-name)))
	=>
	(jump ?ep-name)
	(send ?ep put-type ONGOING)
)