(defglobal MAIN ?*phase-list* = (create$ 

START-start-game
start-game
START
P-0-1-1
P-0-2-1
P-1-1-1
P-1-1-2-0
P-1-1-2-1
P-2-1-1
P-2-2-1
P-2-3-1
P-3-1-1
P-4
FALSE

START-both-players-draw
both-players-draw
both-players-draw-0
FALSE

START-corruption-check
corruption-check-1-1-1
corruption-check-1-2
corruption-check-2
FALSE

START-loc-organize
loc-organize-1
loc-organize-2
FALSE

START-fell-move
fell-move-1
fell-move-2
fell-move-3-1
fell-move-3-2
fell-move-3-3
fell-move-4-0
fell-move-4-1
fell-move-4-2
fell-move-5-0
fell-move-5-1
fell-move-6
fell-move-7
FALSE

START-loc-phase
loc-phase-1-1
loc-phase-1-2
FALSE

)
	?*jumps* = 0
)

(deftemplate only-actions (slot phase (type SYMBOL) (default ?NONE)))

(deffunction update-only-actions (?jump-stage)
	(do-for-fact ((?only-actions only-actions)) TRUE (modify ?only-actions (phase ?jump-stage)))
)


; RECUPERA EL FOCO ACTUAL Y LO COMPARA EN LA LISTA PARA DEVOLVER EL FOCO SIGUIENTE
(deffunction MAIN::stage-guide (?stage)
	(bind ?i (member$ ?stage $?*phase-list*))
	(nth$ (+ 1 ?i) $?*phase-list*)
)

(deffunction MAIN::jump (?jump-stage)
	; Comportamiento inesperado si una fase tiene el FALSE justo despues de su START
	(if (str-index START ?jump-stage) then (bind ?jump-stage (stage-guide ?jump-stage)))
    (focus ?jump-stage)
	(assert (ini))
	(bind ?*jumps* (+ 1 ?*jumps*))
	(update-only-actions ?jump-stage)
)

; REGLA DE INICIO DE JUEGO
(defrule MAIN::start =>
	(assert (only-actions (phase FALSE)))
	(jump START-start-game) 
	(assert (post-drawS))
	(assert (post-drawG))
	(assert (infinite))
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