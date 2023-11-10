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
	(do-for-all-facts ((?action action)) (eq ?p ?action:player)
		(choose ?p ?action:identifier -- ?action:description)
	)
	(if (not (any-factp ((?action action)) (and (eq ?p ?action:player) ?action:blocking))) then
		(bind ?description "Pass")
		(bind ?identifier PASS)
		(bind ?event-def nil)
		(bind ?blocking TRUE)
		(assert (action (player ?p) (identifier ?identifier) (description ?description) (event-def ?event-def) (blocking ?blocking)))
		(choose ?p ?identifier -- ?description)
	)

	(if ?*debug-state* then
		(print-content ?*debug*)
		(bind ?*debug* (create$))
		(print-content ?*announce-p1*)
		(bind ?*announce-p1* (create$))
		(print-content ?*announce-p2*)
		(bind ?*announce-p2* (create$))
		(print-content ?*choose-p1*)
		(bind ?*choose-p1* (create$))
		(print-content ?*choose-p2*)
		(bind ?*choose-p2* (create$))
	)
	(halt)
)

; Jugar la acción deseada
(deffunction MAIN::play-action (?p $?identifier)
	(bind ?pass-identifier (create$ PASS))
	;TODO: controlar cuando haya dos acciones con el mismo identificador
	(bind ?p (symbol-to-instance-name ?p))
	(do-for-fact ((?action action)) (and (eq ?p ?action:player) (eq $?identifier ?action:identifier))
		(debug ?p Se ha seleccionado: ?action:description)
		(if (eq ?identifier ?pass-identifier) then
			; La elección ha sido pasar
			(do-for-all-facts ((?a action)) (eq ?p ?a:player) (retract ?a))
			(retract ?action)
		else
			(eval (str-cat "(make-instance (gen-name E-" ?action:event-def ") of E-" ?action:event-def " " (str-cat (expand$ ?action:data)) ")"))
		)
		(do-for-fact ((?a action)) (and (eq ?a:identifier ?pass-identifier) (eq ?p ?a:player))
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