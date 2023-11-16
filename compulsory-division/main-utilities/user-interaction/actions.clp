;(defclass PLAYER (is-a USER))
;(make-instance [p1] of PLAYER)

; PLANTILLA DE ACCIÓN
(deftemplate MAIN::action
	; Plantilla básica de acción
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
	(slot description (type STRING) (default ?NONE))
	(slot event-def (type SYMBOL) (default ?NONE))
	(multislot data (type STRING) (default ""))
)

; FUNCIÓN GENERADORA DE ACCIONES
;(deffunction MAIN::gen-action (?player ?event-def $?data)
	; Formato de uso: (gen-action <player-name> <generated-event-definitor> <data>*)
	; Ex: (gen-action [player1] CHARACTER-play ?char ?fell)
;	(assert (action 
;		(player ?player)
;		(description ?desc)
;		(action-fact (str-cat 
;			"(make-instance (gen-name E-" ?event-def ") of E-" ?event-def " "(implode$ ?data) ")" ))
;	))
;)

; Jugar la acción deseada
(deffunction MAIN::play-actions (?p)
	(bind ?event-defs (create$))
	(bind ?datas (create$))
	(bind ?total 0)
	
	(announce ?p Possible actions:)
	;TODO: verificar si la accion elegida es (pass) o asi?
	(announce ?p 0 .- Pass actions)
	(do-for-all-facts ((?action action)) (eq ?p ?action:player)
		(bind ?total (+ 1 ?total))
		(announce ?p ?total .- ?action:description)
		(bind ?event-defs (insert$ ?event-defs 1 ?action:event-def))
		(bind ?datas (insert$ ?datas 1 (str-cat (expand$ ?action:data))))
	)
	(bind ?choice (obtain-number ?p))
	(if (= 0 ?choice) then
		(do-for-all-facts ((?action action)) (eq ?p ?action:player)
			(retract ?action))
		else
		(bind ?choice (- ?total (- ?choice 1)))
		(while (not (and (<= 1 ?choice) (>= ?total ?choice)))
			(bind ?choice (obtain-number ?p "Invalid action, choose a correct action:")))
		(bind ?event-def (nth$ ?choice ?event-defs))
		(bind ?data (nth$ ?choice ?datas))

		(bind ?command (str-cat "(make-instance (gen-name E-" ?event-def ") of E-" ?event-def " " ?data ")"))
		(eval ?command)
	)
)

; REGLA PARA QUE EL FLUJO DE EJECUCIÓN DEL PROGRAMA REQUIERA LA ATENCIÓN DEL JUGADOR
;(defrule MAIN::require-player-attention (declare (auto-focus TRUE) (salience ?*action-selection-salience*))
	; TODO: Debe tener saliencia inferior a todas las reglas que creen 
    ; o cambien acciones, si no, se activará con la primera acción y mostrará solo esa 
    ; en cada activación: n activaciones de 1 acción, en vez de 1 activación de n acciones
	
	;DEBO ESCRIBIR ESTO EN CADA MÓDULO, PORQUE AL ACTIVARSE ESTA REGLA (NO DISPARARSE), EL AUTO-FOCUS
	; HACE UN FOCUS MAIN A LA QUE EXISTE LA PRIMERA ACCIÓN Y ECLIPSA LOS DISPAROS DE LAS DEMÁS, YA QUE
	; NO PUEDEN DISPARARSE EN EL MÓDULO MAIN
	
;	(object (is-a PLAYER) (name ?p))
;	(exists (action (player ?p)))
;	=>
;	(play-actions ?p)
;)

;(assert (action (player [p1]) (description "Curar a un personaje") (event-def "cure") (data (create$ "(" agendAAa ")"))))
;(assert (action (player [p1]) (description "Girar") (event-def "twist") (data (create$ "(" agendAAa ")"))))
;(assert (action (player [p1]) (description "daklfd") (event-def "daffd") (data (create$ "(" agendAAa ")"))))
;(play-actions [p1])