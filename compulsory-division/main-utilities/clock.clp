(defglobal MAIN ?*phase-list* = (create$ 
MAIN
START-start-game
start-game-0
start-game-1
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
P-5-1-1
P-5-2-1
P-5-3
P-5-4
P-5-5
FALSE

START-both-players-draw
both-players-draw-0
both-players-draw-1
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
loc-phase-2-1
loc-phase-3-1
loc-phase-4
FALSE

START-faction-play
faction-play-1-1
faction-play-2-1
FALSE

START-free-council
free-council-1-0
free-council-1-1
free-council-2-1
FALSE

START-attack
attack-0
attack-1
attack-2-0
attack-2-1
attack-2-2
attack-2-3
attack-3
attack-4
attack-5
FALSE

START-strike
strike-1-1
strike-2
strike-3-1
strike-3-2
strike-4
FALSE

START-resistance-check
resistance-check-0
resistance-check-1
resistance-check-2
resistance-check-3
FALSE

)
	?*jumps* = 0
)

(deftemplate only-actions (slot phase (type SYMBOL) (default ?NONE)))

(deffunction update-only-actions (?jump-stage)
	(do-for-fact ((?only-actions only-actions)) TRUE (retract ?only-actions)
	(assert (only-actions (phase ?jump-stage))))
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

; FUNCION DE CAMBIO DE FASE
(deffunction MAIN::tic (?stage)
	(bind ?stage (get-focus))

	; ACTUALIZA FOCOS
	(bind ?jump-stage (stage-guide ?stage))
	(if ?jump-stage then
		(pop-focus)
		(jump ?jump-stage)
		else
		(if (eq (nth$ 2 (get-focus-stack)) MAIN) then
			(if (< (length$ (get-focus-stack)) 3) then 
				(debug Fin de la partida);PUEDE QUE SEA NECESARIO PQ NUNCA OCURRA
				(halt)
				else
				(update-only-actions (nth$ 3 (get-focus-stack)))
			)
			else 
			(update-only-actions (nth$ 2 (get-focus-stack)))
		)
	)
	
	; ELIMINA EVENTOS O FASES EVENTUALES TERMINADAS
	(do-for-all-instances ((?e EVENT)) 
		(and 
			(eq ?e:type OUT) 
			(not (str-index ?e:target-phase (implode$ (get-focus-stack))))
		)
		(debug DELETING ?e)
		(send ?e delete)
	)
)



; REGLA DE INICIO DE JUEGO
(defrule MAIN::start =>
	(assert (only-actions (phase FALSE)))
	(tic 1)
	(assert (infinite))
	(assert (player ?*player1*))
	(assert (enemy ?*player2*))
)