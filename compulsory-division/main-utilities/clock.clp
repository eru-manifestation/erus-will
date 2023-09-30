(defglobal MAIN ?*phase-list* = (create$ 

P-0-1-1
P-0-2-1
P-1-1-1
P-2-1-1
P-2-2-1
P-2-3-1
;P-3-1-0
P-3-1-1
FALSE
corruption-check-1-1-1
corruption-check-1-2
corruption-check-2
FALSE
loc-organize-1
loc-organize-2
FALSE

)
	?*jumps* = 0
)

(deftemplate only-actions (slot phase (type SYMBOL) (default ?NONE)))

(deffunction update-only-actions (?jump-stage)
	(do-for-fact ((?only-actions only-actions)) TRUE (modify ?only-actions (phase ?jump-stage)))
)

(deffunction MAIN::jump (?jump-stage)
    (focus ?jump-stage)
	(assert (ini))
	(bind ?*jumps* (+ 1 ?*jumps*))
	(update-only-actions ?jump-stage)
)

; REGLA DE INICIO DE JUEGO
(defrule MAIN::start =>
	(assert (only-actions (phase FALSE)))
	(jump P-0-1-1) 
	(assert (post-draw))
	(assert (infinite))
)


; RECUPERA EL FOCO ACTUAL Y LO COMPARA EN LA LISTA PARA DEVOLVER EL FOCO SIGUIENTE
(deffunction MAIN::stage-guide (?stage)
	(bind ?i (member$ ?stage $?*phase-list*))
	(nth$ (+ 1 ?i) $?*phase-list*)
)

; FUNCION DE CAMBIO DE FASE
(deffunction MAIN::tic (?stage)
	(bind ?jump-stage (stage-guide ?stage))
	(if ?jump-stage then
		(pop-focus)
		(jump ?jump-stage)
		else
		(if (eq (nth$ 2 (get-focus-stack)) MAIN) then
			(if (< (length$ (get-focus-stack)) 3) then 
				(debug Fin de la partida)
				else
				(update-only-actions (nth$ 3 (get-focus-stack)))
			)
			else 
			(update-only-actions (nth$ 2 (get-focus-stack)))
		)
	)
)