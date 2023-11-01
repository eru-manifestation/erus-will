; PLANTILLA DE ACCIÓN
(deftemplate MAIN::action
	; Plantilla básica de acción
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
	(multislot identifier (type ?VARIABLE) (default ?NONE))
	(slot description (type STRING) (default ?NONE))
	(slot event-def (type SYMBOL) (default ?NONE))
	(multislot data (type STRING) (default ""))
	;(slot type (type SYMBOL) (default E) (allowed-values EP E))
	(slot blocking (type SYMBOL) (default FALSE) (allowed-values TRUE FALSE))
)

; Parar la ejecución y mostrar las posibilidades
(deffunction MAIN::collect-actions (?p)
	(announce ?p Possible actions:)
	(do-for-all-facts ((?action action)) (eq ?p ?action:player)
		(announce ?p ?action:description)
		(choose ?p ?action:identifier -- ?action:description)
	)
	(if (not (any-factp ((?action action)) (and (eq ?p ?action:player) ?action:blocking))) then
		(announce ?p Pass)
		(choose ?p (create$) -- Pass)
		(assert (action (player ?p) (identifier (create$)) (description "Pass") (event-def nil) (blocking TRUE)))
	)
	(announce ?p No more actions)
	(if ?*debug-state* then
		(print-content ?*debug*)
		(bind ?*debug* (create$))
		(print-content ?*announce*)
		(bind ?*announce* (create$))
		(print-content ?*choose*)
		(bind ?*choose* (create$))
	)
	(halt)
)

; Jugar la acción deseada
(deffunction MAIN::play-action (?p $?identifier)
	;TODO: controlar cuando haya dos acciones con el mismo identificador
	(bind ?p (symbol-to-instance-name ?p))
	(do-for-fact ((?action action)) (and (eq ?p ?action:player) (eq $?identifier ?action:identifier))
		(debug ?p Se ha seleccionado: ?action:description)
		(if (eq ?action:identifier (create$)) then
			(do-for-all-facts ((?a action)) (eq ?p ?a:player) (retract ?a))
			(retract ?action)
		else
			(eval (str-cat "(make-instance (gen-name E-" ?action:event-def ") of E-" ?action:event-def " " (str-cat (expand$ ?action:data)) ")"))
			(retract ?action)
		)
		(do-for-fact ((?a action)) (and (eq ?a:identifier (create$)) (eq ?p ?a:player))
			(retract ?a)
		)
		(run)
		(return TRUE)
	)
)

; (load-all)
; (bind ?*debug-state* TRUE)
; (run)
; (play-action player1 "[elven-cloak1] [aragorn-ii1]")
;(play-action player1 "[rivendell]")