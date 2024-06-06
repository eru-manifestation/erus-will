; PLANTILLA DE ACCIÓN
(deftemplate action
	; Plantilla básica de acción
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
	(multislot identifier (type ?VARIABLE) (default ?NONE))
	(slot description (type STRING) (default ?NONE))
	(slot event-def (type SYMBOL) (default ?NONE))
	(multislot data (type ?VARIABLE) (default ?NONE))
	(slot reason (type SYMBOL) (default ?NONE))
	(slot blocking (type SYMBOL) (default FALSE) (allowed-values TRUE FALSE))
)


(defrule MAIN::a-pass (declare (auto-focus TRUE) (salience ?*a-population*))
	(logical
		(object (is-a PLAYER) (name ?p))
		(exists (action (event-def ~pass) (player ?p)))
		(not (action (player ?p) (blocking TRUE)))
	)
	=>
	(assert (action 
		(player ?p) 
		(identifier [PASS]) 
		(description "Pass") 
		(event-def pass) 
		(data)
		(reason MAIN::a-pass)))
)


; Parar la ejecución y mostrar las posibilidades
(deffunction MAIN::collect-actions (?p)
	(do-for-all-facts ((?action action)) (eq ?p ?action:player)
		(if (eq (length$ ?action:identifier) 1) then
			(choose ?p { 
				"vector" : [ (JSONformat ?action:identifier) ] , 
				"description" : (JSONformat ?action:description) })
			else
			(choose ?p { 
				"vector" : [ (JSONformat (nth$ 1 ?action:identifier)) , (JSONformat (nth$ 2 ?action:identifier)) ] ,
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
		(switch ?action:event-def
			(case ?pass-evdef then
				; La elección ha sido pasar, se eliminan todos los action, lo que emplica que se retracte PASS
				(do-for-all-facts ((?a action)) (eq ?p ?a:player) (retract ?a))
				(retract ?action)
			)
			(case modify then
				; Permite introducir una lista final en data
				(E-modify (nth$ 1 ?action:data) (nth$ 2 ?action:data) (subseq$ ?action:data 3 100) ?action:reason)
			)
			(case play then
				(E-play (nth$ 1 ?action:data) (nth$ 2 ?action:data) ?action:reason)
			)
			(case discard then
				(E-discard (nth$ 1 ?action:data) ?action:reason)
			)
			(case play-by-region then
				(E-play-by-region (nth$ 1 ?action:data) (nth$ 2 ?action:data) (nth$ 3 ?action:data) ?action:reason)
			)
			(case play-by-place then
				(E-play-by-place (nth$ 1 ?action:data) (nth$ 2 ?action:data) (nth$ 3 ?action:data) ?action:reason)
			)
			(default
				(eval (str-cat "(make-instance (gen-name EP-" ?action:event-def 
					") of EP-" ?action:event-def " " (expand$ ?action:data) " (reason " ?action:reason "))"))
			)
		)
		(set-current-module ?m)
		(run)
		(return TRUE)
	)
)