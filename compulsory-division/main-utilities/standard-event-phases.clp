; EP-corruption-check
(defclass MAIN::EP-corruption-check (is-a EVENT-PHASE)
	(slot character (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
	(slot dices (type INTEGER) (default 0))
)


; EP-loc-organize
(defclass MAIN::EP-loc-organize (is-a EVENT-PHASE)
	(slot player (type INSTANCE-NAME) (default ?NONE) (allowed-classes PLAYER))
    (slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)


; EP-fell-move
(defclass MAIN::EP-fell-move (is-a EVENT-PHASE)
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
(defclass MAIN::EP-both-players-draw (is-a EVENT-PHASE))


; EP-loc-phase
(defclass MAIN::EP-loc-phase (is-a EVENT-PHASE)
	(slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
	(slot fell (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
)


; EP-faction-play
(defclass MAIN::EP-faction-play (is-a EVENT-PHASE)
	(slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
	(slot char (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
	(slot faction (type INSTANCE-NAME) (default ?NONE) (allowed-classes FACTION))
	
	(slot dices (type INTEGER) (default 0))
)


; EP-free-council
(defclass MAIN::EP-free-council (is-a EVENT-PHASE))


; EP-attack
(defclass MAIN::EP-attack (is-a EVENT-PHASE)
	(slot fell (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
	(slot attackable (type INSTANCE-NAME) (default ?NONE) (allowed-classes ATTACKABLE))
	(slot state (type SYMBOL) (default UNKNOWN) (allowed-symbols UNKNOWN DEFEATED UNDEFEATED))
)


; EP-strike
(defclass MAIN::EP-strike (is-a EVENT-PHASE)
	(slot char (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
	(slot attackable (type INSTANCE-NAME) (default ?NONE) (allowed-classes ATTACKABLE))
	(slot state (type SYMBOL) (default UNKNOWN) (allowed-symbols UNKNOWN DEFEATED UNDEFEATED SUCCESSFUL))

	(slot hindered (type SYMBOL) (default FALSE) (allowed-values TRUE FALSE))
	(slot dices (type INTEGER) (default 0))
)


; EP-resistance-check
(defclass MAIN::EP-resistance-check (is-a EVENT-PHASE)
	(slot attacker (type INSTANCE-NAME) (default ?NONE) (allowed-classes ATTACKABLE))
	(slot assaulted (type INSTANCE-NAME) (default ?NONE) (allowed-classes ATTACKABLE))

	(slot dices (type INTEGER) (default 0))
	(slot result (type SYMBOL) (default UNKNOWN) (allowed-symbols PASSED NOT-PASSED UNKNOWN))
)



;/////////////////// UNIFIED HANDLER //////////////////
(defrule MAIN::ep-start (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
	(object (is-a EVENT-PHASE) (name ?ep) (type IN))
	(object (is-a ?class) (name ?ep) (type IN))
	(not (object (is-a ?class) (type ONGOING)))
	; Por defecto, pone a la espera cualquier otra fase eventual, por lo que se comporta bien con el
	;  listado paralelo de 2 fases eventuales similares: Primero inicia y acaba una, luego inicia y acaba
	;  la siguiente. En principio, de hacerse con más de 2 o con varias distintas, el comportamiento es
	;  el de apilado de fases eventuales
	=>
	(pop-focus)
	(jump (sym-cat START (sub-string 3 (str-length ?class) ?class)))
	(focus MAIN)
	(send ?ep put-type ONGOING)
)