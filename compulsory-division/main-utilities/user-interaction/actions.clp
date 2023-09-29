; PLANTILLA DE ACCIÓN
(deftemplate MAIN::action
	; Plantilla básica de acción
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
	(slot description (type STRING) (default ?NONE))
	(slot event-def (type SYMBOL) (default ?NONE))
	(multislot data (type STRING) (default ""))
)

; Jugar la acción deseada
(deffunction MAIN::play-actions (?p)
	(bind ?event-defs (create$))
	(bind ?datas (create$))
	(bind ?total 0)
	
	(announce ?p Possible actions:)
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