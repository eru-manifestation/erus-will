; PLANTILLA DE ACCIÓN
(deftemplate action
	; Plantilla básica de acción
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
	(slot initiator (default FALSE))
	(multislot identifier (type ?VARIABLE) (default ?NONE))
	(slot description (type STRING) (default ?NONE))
	(slot event-def (type SYMBOL) (default ?NONE))
	(multislot data (type ?VARIABLE) (default ?NONE))
	(slot blocking (type SYMBOL) (default FALSE) (allowed-values TRUE FALSE))
)


(defrule MAIN::action-pass (declare (auto-focus TRUE) (salience ?*action-population*))
	(logical
		(object (is-a PLAYER) (name ?p))
		(exists (action (event-def ~pass) (player ?p)))
		(not (action (player ?p) (blocking TRUE)))
	)
	=>
	(assert (action 
		(player ?p) 
		(identifier PASS) 
		(description "Pass") 
		(event-def pass) 
		(data (create$))))
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
		(bind ?m (set-current-module (get-focus))) ;TODO: probar si es necesario
		(bind ?initiator ?action:initiator)
		(switch ?action:event-def
			(case ?pass-evdef then
				; La elección ha sido pasar, se eliminan todos los action, lo que emplica que se retracte PASS
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
				(assert (data (phase (nth$ 1 (send ?*active-event* get-reason))) (data ?action:data)))
			)
		)

		(if ?initiator then (retract ?initiator))
		(set-current-module ?m)
		(run)
		(return TRUE)
	)
)