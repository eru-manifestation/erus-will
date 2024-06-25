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

    ?*active-event* = (slot-default-value BASIC position)
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
corruption-check-1
FALSE

START-fell-move
fell-move-1
fell-move-2
fell-move-3
fell-move-4
fell-move-5
fell-move-6
FALSE

START-loc-phase
loc-phase-1-1
loc-phase-2-1
loc-phase-3-1
FALSE

START-faction-play
faction-play-1
faction-play-2
faction-play-3
FALSE

START-free-council
free-council-1-0
free-council-1-1
free-council-2-1
FALSE

START-combat
combat-1
combat-2
FALSE

START-dices
dices-1
FALSE

START-attack
attack-1
attack-2
attack-3
attack-4
FALSE

START-strike
strike-1
strike-2
strike-3
strike-4
strike-5
FALSE

START-resistance-check
resistance-check-1
FALSE

START-ring
ring-1
FALSE

)
	?*jumps* = 0
)


; RECUPERA EL FOCO ACTUAL Y LO COMPARA EN LA LISTA PARA DEVOLVER EL FOCO SIGUIENTE
(deffunction MAIN::stage-guide (?stage)
	(bind ?i (member$ ?stage $?*phase-list*))
    (if (eq ?i FALSE) then (println "no se ha encontrado" ?stage))

	(nth$ (+ 1 ?i) $?*phase-list*)
)

(deffunction MAIN::ini-message (?stage)
    (switch ?stage
        (case start-game-0 then "INICIA EL JUEGO, creamos la mesa")
        (case start-game-1 then "Se roba hasta tener 8")
        (case P-0-1-1 then "Genera evento enderezar carta no localizaciones")
        (case P-0-2-1 then "Cura personajes en refugios")
        (case P-1-1-1 then "Ejecucion de la fase de organizacion")
        (case P-1-1-2-0 then "Ejecucion declarar movimiento")
        (case P-1-1-2-1 then "Inicio declarar movimiento")
        (case P-2-1-1 then "Descartar recursos de suceso duradero")
        (case P-2-2-1 then "Jugar recursos suceso duradero")
        (case P-2-3-1 then "Descartar adversidades suceso duradero")
        (case P-3-1-1 then "Eleccion de la ejecucion del movimiento")
        (case P-4 then "Fase de lugares")
        (case P-5-1-1 then "Ejecucion eleccion si descartar")
        (case P-5-2-1 then "Ambos roban antes del final del turno")
        (case P-5-3 then "Ir al concilio libre si ha sido convocado")
        (case P-5-4 then "Convoque free council if the conditions are met")
        (case standarize-hand-0 then "Descartar o robar hasta tener 8 cartas")
        (case draw-0 then "Robar las cartas necesarias")
        (case corruption-check-1 then "Chequeo de corrupcion")
        (case resistance-check-1 then "Chequeo de resistencia")
        (case ring-1 then "Examinar anillo")
        (case dices-1 then "Tirada de dados")
        (case fell-move-1 then "Revelar movimiento")
        (case fell-move-2 then "Calcular limite de adversidades, cartas por robar e itinerario")
        (case fell-move-3 then "Ambos jugadores roban una carta si se ejecuta un movimiento")
        (case fell-move-4 then "El jugador que mueve decide si seguir robando, de ser posible")
        (case fell-move-5 then "El adversario decide si seguir robando, si es posible")
        (case fell-move-6 then "El adversario puede jugar adversidades")
        (case loc-phase-1-1 then "Ejecucion ataques automaticos fase lugares")
        (case loc-phase-2-1 then "Jugar recursos en el lugar")
        (case loc-phase-3-1 then "Jugar objeto menor adicional")
        (case faction-play-1 then "Se gira el personaje")
        (case faction-play-2 then "Se pueden jugar cartas que modifiquen la proxima tirada")
        (case faction-play-3 then "Se resuelve el chequeo de influencia")
        (case free-council-1-0 then "Jugador realiza chequeo de corrupcion de sus personajes")
        (case free-council-1-1 then "Enemigo realiza chequeo de corrupcion de sus personajes")
        (case free-council-2-1 then "Nombramiento del vencedor del concilio")
        (case combat-1 then "Se ejecutan los ataques en orden")
        (case combat-2 then "Resolucion del combate")
        (case attack-1 then "Se juegan cartas que modifiquen el numero de golpes")
        (case attack-2 then "El defensor elige quienes recibiran golpes")
        (case attack-3 then "El atacante administra los golpes restantes")
        (case attack-4 then "El defensor ejecuta los golpes")
        (case strike-1 then "Atacante juega adversidades que modifiquen el golpe")
        (case strike-2 then "El atacante usa los golpes sin objetivo como modificador")
        (case strike-3 then "El defensor decide si luchar reservando energias")
        (case strike-4 then "El defensor juega recursos que modifiquen el golpe")
        (case strike-5 then "Se tiran los dados")
        (default "No info")
    )
)

(deffunction MAIN::jump (?jump-stage)
	; Comportamiento inesperado si una fase tiene el FALSE justo despues de su START
	(if (str-index START ?jump-stage) then (bind ?jump-stage (stage-guide ?jump-stage)))
    (focus ?jump-stage)
	(bind ?*jumps* (+ 1 ?*jumps*))
	(foreach ?rule (get-defrule-list ?jump-stage) (refresh ?rule))
    (phase (ini-message ?jump-stage))
    ?jump-stage
)