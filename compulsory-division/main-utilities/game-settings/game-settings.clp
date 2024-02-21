;CREA LOS DOS JUGADORES Y SUS MANOS Y BARAJAS
(defglobal MAIN
	?*player1* = (make-instance (gen-name PLAYER) of PLAYER)
	?*player2* = (make-instance (gen-name PLAYER) of PLAYER)

    ?*hand1* = (make-instance hand1 of STACK (player ?*player1*))
    ?*hand2* = (make-instance hand2 of STACK (player ?*player2*))

    ?*draw1* = (make-instance draw1 of STACK (player ?*player1*))
    ?*draw2* = (make-instance draw2 of STACK (player ?*player2*))

    ?*discard1* = (make-instance discard1 of STACK (player ?*player1*))
    ?*discard2* = (make-instance discard2 of STACK (player ?*player2*))

    ?*mp1* = (make-instance mp1 of STACK (player ?*player1*))
    ?*mp2* = (make-instance mp2 of STACK (player ?*player2*))

    ?*out-of-game1* = (make-instance out-of-game1 of STACK (player ?*player1*))
    ?*out-of-game2* = (make-instance out-of-game2 of STACK (player ?*player2*))
)

(deffunction MAIN::handsymbol (?player)
    (switch ?player
        (case [player1] then ?*hand1*)
        (case [player2] then ?*hand2*)
        (default FALSE)
    )
)

(deffunction MAIN::drawsymbol (?player)
    (switch ?player
        (case [player1] then ?*draw1*)
        (case [player2] then ?*draw2*)
        (default FALSE)
    )
)

(deffunction MAIN::discardsymbol (?player)
    (switch ?player
        (case [player1] then ?*discard1*)
        (case [player2] then ?*discard2*)
        (default FALSE)
    )
)

(deffunction MAIN::mpsymbol (?player)
    (switch ?player
        (case [player1] then ?*mp1*)
        (case [player2] then ?*mp2*)
        (default FALSE)
    )
)

(deffunction MAIN::outofgamesymbol (?player)
    (switch ?player
        (case [player1] then ?*out-of-game1*)
        (case [player2] then ?*out-of-game2*)
        (default FALSE)
    )
)

; MECANISMO DE INICIACIÓN DE CARTAS
(deffunction MAIN::init-card(?card-class ?times ?player-n)
    (bind ?player (symbol-to-instance-name (sym-cat player ?player-n)))
    (make-instance (gen-name ?card-class) of ?card-class 
        (player ?player) (position (drawsymbol ?player)))
    (if (< 1 ?times)
    then
        (init-card ?card-class (- ?times 1) ?player-n)
    )
)



(defglobal MAIN ?*phase-list* = (create$ 
START-start-game
start-game-0
start-game-1
FALSE

START-turn
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
FALSE

START-standarize-hand
standarize-hand-0
FALSE

START-draw
draw-0
FALSE

START-corruption-check
corruption-check-1-1-1
corruption-check-1-2
FALSE

START-fell-move
fell-move-1
fell-move-2
fell-move-3-1
fell-move-3-2
fell-move-3-3
fell-move-4-1
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
attack-1
attack-2-1
attack-2-2
attack-3
attack-4
FALSE

START-strike
strike-1-1
strike-2
strike-3-1
strike-3-2
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
    ;TODO: sustituir la regla ini por un mapa (switch) que imprima el mensaje de entrada conveniente y que refresque las reglas del modulo, ya que cambiando el foco basta para conseguirlo
	(message (get-defrule-list))
)