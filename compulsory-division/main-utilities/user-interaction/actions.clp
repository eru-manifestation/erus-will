; PLANTILLA DE ACCIÓN
(deftemplate MAIN::action
	; Plantilla básica de acción
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
	(slot type (type SYMBOL) (default E) (allowed-values EP E))
	(multislot identifier (type ?VARIABLE) (default ?NONE))
	(slot description (type STRING) (default ?NONE))
	(slot event-def (type SYMBOL) (default ?NONE))
	(multislot data (type ?VARIABLE) (default ?NONE))
	(slot blocking (type SYMBOL) (default FALSE) (allowed-values TRUE FALSE))
)

; Parar la ejecución y mostrar las posibilidades
(deffunction MAIN::collect-actions (?p)
	(do-for-all-facts ((?action action)) (eq ?p ?action:player)
		(if (eq (length$ ?action:identifier) 1) then
			(choose ?p { 
				"vector" : [ (implode$ ?action:identifier) ] , 
				"description" : (JSONformat ?action:description) })
			else
			(choose ?p { 
				"vector" : [ (str-cat "[" (nth$ 1 ?action:identifier) "]") , (str-cat "[" (nth$ 2 ?action:identifier)"]" ) ] ,
				"description" : (JSONformat ?action:description) })
		)
	)
	(if (not (any-factp ((?action action)) (and (eq ?p ?action:player) ?action:blocking))) then
		(bind ?description "Pass")
		(bind ?identifier PASS)
		(bind ?event-def pass)
		(bind ?blocking TRUE)
		(assert (action 
			(player ?p) 
			(identifier ?identifier) 
			(description ?description) 
			(event-def ?event-def) 
			(data (create$))
			(blocking ?blocking)))
		(choose ?p { 
			"vector" : [ (str-cat ?identifier) ] , 
			"description" : (JSONformat ?description) })
	)

	(if ?*print-message* then
		(print-content ?*choose-p1*)
		(bind ?*choose-p1* (create$))
		(print-content ?*choose-p2*)
		(bind ?*choose-p2* (create$))
	)
	(halt)
)

; Jugar la acción deseada
(deffunction MAIN::play-action (?p $?identifier)
	(bind ?pass-evdef pass)
	;TODO: controlar cuando haya dos acciones con el mismo identificador
	(bind ?p (symbol-to-instance-name ?p))
	(do-for-fact ((?action action)) (and (eq ?p ?action:player) (eq $?identifier ?action:identifier))
		(message ?p "Se ha seleccionado: " ?action:description)
		(switch ?action:event-def
			(case ?pass-evdef then
				; La elección ha sido pasar
				(do-for-all-facts ((?a action)) (eq ?p ?a:player) (retract ?a))
				(retract ?action)
			)
			(case modify then
				(E-modify (expand$ ?action:data))
			)
			(case phase then
				(make-instance (gen-name E-phase) of E-phase 
					(reason (explode$ (nth$ 1 ?action:data)))
					(data (rest$ ?action:data))
				)
			)
			(case variable then
				(bind ?m (set-current-module (get-focus)))
				(assert-string (str-cat "(data (data " (implode$ ?action:data) "))"))
				(set-current-module ?m)
			)
			(case varswap then
				(bind ?m (set-current-module (get-focus)))
				(retract (nth$ 1 ?action:data))
				(assert-string (str-cat "(data (data " (implode$ (rest$ ?action:data)) "))"))
				(set-current-module ?m)
			)
			; (default 
			; 	;	TODO: eliminar esta alternativa
			; 	(eval (str-cat "(make-instance (gen-name " ?action:type "-" ?action:event-def ") of " ?action:type "-" ?action:event-def " " (str-cat (expand$ ?action:data)) ")"))
			; )
		)
	
		; TODO: verificar si es posible eliminar esta instruccion por redundancia
		(do-for-fact ((?a action)) (and (eq ?a:event-def ?pass-evdef) (eq ?p ?a:player))
			(retract ?a)
		)
		(run)
		(return TRUE)
	)
)