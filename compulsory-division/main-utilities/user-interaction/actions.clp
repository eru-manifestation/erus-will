; PLANTILLA DE ACCIÓN
(deftemplate MAIN::action
	; Plantilla básica de acción
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
	(slot action-fact (type STRING) (default ?NONE))
)

; FUNCIÓN GENERADORA DE ACCIONES
(deffunction MAIN::gen-action (?player ?event-def $?data)
	; Formato de uso: (gen-action <player-name> <generated-event-definitor> <data>*)
	; Ex: (gen-action [player1] CHARACTER-play ?char ?fell)
	(assert (action 
		(player ?player) 
		(action-fact (str-cat 
			"(make-instance (gen-name E-" ?event-def ") of E-" ?event-def " "(implode$ ?data) ")" ))
	))
)

; Jugar la acción deseada
(deffunction MAIN::play-actions (?p)
	(bind ?acc (create$))
	; Acumular en ?acc las cadenas "action-fact" de las acciones del jugador ?p
	(do-for-all-facts ((?action action)) (eq ?p ?action:player)
		(bind ?acc (insert$ ?acc 1 ?action:action-fact))
	)
	(bind ?command (obtain ?p Acciones posibles: ?acc))
	(while (not (member$ ?command ?acc))
		(bind ?command (obtain ?p Accion invalida, acciones posibles: ?acc))
	)
	;Idea loca: verificar si la accion elegida es (pass) o asi?
	(eval ?command)
)

; REGLA PARA QUE EL FLUJO DE EJECUCIÓN DEL PROGRAMA REQUIERA LA ATENCIÓN DEL JUGADOR
(defrule MAIN::require-player-attention (declare (salience ?*action-selection-salience*))
	; TODO: Debe tener saliencia inferior a todas las reglas que creen 
    ; o cambien acciones, si no, se activará con la primera acción y mostrará solo esa 
    ; en cada activación: n activaciones de 1 acción, en vez de 1 activación de n acciones
	
	(object (is-a PLAYER) (name ?p));OPTIMIZAR: esta instrucción es innecesaria dada la sig
	(exists (action (player ?p)))
	=>
	(play-actions ?p)
)
