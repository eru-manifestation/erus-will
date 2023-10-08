; EP-corruption-check
(defclass MAIN::EP-corruption-check (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-corruption-check))

    (slot character (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
	(slot dices (type INTEGER) (default 0))
)


; EP-loc-organize
(defclass MAIN::EP-loc-organize (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-loc-organize))

    (slot player (type INSTANCE-NAME) (default ?NONE) (allowed-classes PLAYER))
    (slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)


; EP-fell-move
(defclass MAIN::EP-fell-move (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-fell-move))

	; Cuando la compañía quiera permanecer, from será igual a to
    (slot fell (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot from (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
    (slot to (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))

	(slot adversity-limit (type FLOAT) (default 0.0))
	(slot player-draw (type INTEGER) (default 0))
	(slot enemy-draw (type INTEGER) (default 0))
	(multislot route (type ?VARIABLE) (default (create$)))
)


; EP-both-players-draw
(defclass MAIN::EP-both-players-draw (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-both-players-draw))
)


; EP-loc-phase
(defclass MAIN::EP-loc-phase (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-loc-phase))

	(slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
	(slot fell (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
)


; EP-faction-play
(defclass MAIN::EP-faction-play (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-faction-play))

	(slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
	(slot char (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
	(slot faction (type INSTANCE-NAME) (default ?NONE) (allowed-classes FACTION))
	
	(slot dices (type INTEGER) (default 0))
)


; EP-free-council
(defclass MAIN::EP-free-council (is-a EVENT-PHASE)
	(slot ep-name (type SYMBOL) (default START-free-council))
)



;/////////////////// UNIFIED HANDLER //////////////////
(defrule MAIN::ep-start (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
	?ep <- (object (is-a EVENT-PHASE) (type IN) (ep-name ?ep-name))
	(not (object (is-a EVENT-PHASE) (type ONGOING) (ep-name ?ep-name)))
	; Por defecto, pone a la espera cualquier otra fase eventual, por lo que se comporta bien con el
	;  listado paralelo de 2 fases eventuales similares: Primero inicia y acaba una, luego inicia y acaba
	;  la siguiente. En principio, de hacerse con más de 2 o con varias distintas, el comportamiento es
	;  el de apilado de fases eventuales
	=>
	(jump ?ep-name)
	(send ?ep put-type ONGOING)
)