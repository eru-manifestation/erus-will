(deffunction MAIN::upcase-first (?word)
    (sym-cat (str-cat (upcase (sub-string 1 1 ?word)) (sub-string 2 (str-length ?word) ?word)))
)

(deffunction MAIN::classes (?instance)
    (lowcase (str-cat (class ?instance) " " (implode$ (class-superclasses (class ?instance) inherit))))
)

(defmessage-handler USER get-slots ()
    ;Devolver una cadena con la asociacion entre slot y valor
    (bind ?res "")
    (foreach ?slot (class-slots (class ?self) inherit) (bind ?res (str-cat ?res ?slot "='" (implode$ (insert$ (create$) 1 (dynamic-get ?slot))) "'")))
    (return ?res)
)

(deffunction MAIN::instance-name-to-file (?instance)
    ;Elimina numero, utilizo el nombre de la clase
    (bind ?instance (lowcase (class ?instance)))
    ;Primera letra siempre en mayuscula
    (bind ?instance (upcase-first ?instance))
    ;Guion a espacio y doble guion desaparece porque la siguiente comienza en minuscula
    (bind ?instance (str-cat ?instance))
    (bind ?instance (str-replace ?instance "--" ""))
    (bind ?instance (str-replace ?instance "-" " "))
    ;Letra despues de espacio a mayuscula si su palabra no es "a an and the of or ..."
    ;Convertir "A fair travel in the border lands" en ("A" "fair" "travel" "in" "border" "lands")
    (bind ?instance (explode$ ?instance))
    (bind ?res (create$))
    (foreach ?word ?instance do
        (if (member$ (str-cat ?word) (create$ "a" "an" "and" "of" "the" "or" "in" "out")) then
            (bind ?res (insert$ ?res (+ 2 (length$ ?res)) ?word))
            else
            (bind ?res (insert$ ?res (+ 2 (length$ ?res)) (upcase-first ?word)))
        )
    )
    (bind ?res (implode$ ?res))
    (return (str-replace ?res " " ""))
)

(deffunction MAIN::bgstyle (?card)
    (if (str-index " card " (classes ?card)) then
        return (str-cat " style=background-image:url('../tw/icons/" (instance-name-to-file ?card) ".jpg') ")
        else 
        return ""
    )
)


(deffunction MAIN::update-under (?player ?card)
    (do-for-all-facts ((?in in)) 
        (and
            (eq ?in:transitive FALSE)
            (eq ?in:over ?card)
        )
        (state ?player (str-cat "<div id='[" ?in:under "]' class='" (classes ?in:under) "' " (bgstyle ?in:under) (send ?in:under get-slots) " draggable=true >")) 
        (update-under ?player ?in:under)
        (state ?player "</div>" crlf)
    )
)


(deffunction MAIN::draw (?player ?instance)
    (state ?player (str-cat "<div id='[" ?instance "]' class='" (classes ?instance) "' " (bgstyle ?instance) (send ?instance get-slots) " draggable=true >") crlf) 
    (update-under ?player ?instance)
    (state ?player "</div>" crlf)
)


; Main function
(deffunction MAIN::update-index (?player)
    (state ?player "<div class='game'>")

    ; Dibujar jugadores
    (state ?player "<div class='player'>")
    (draw ?player ?player)
    (state ?player "</div>" crlf)
    (state ?player "<div class='enemy'>")
    (draw ?player (enemy ?player))
    (state ?player "</div>" crlf)

    ; Dibujar localizaciones
    (state ?player "<div class='locations'>")
    (do-for-all-instances ((?instance LOCATION)) TRUE
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    ; Dibujar mazos, manos etc
    (state ?player "<div id='PLAYERHAND' class='player_hand' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (and (eq ?instance:state HAND) (eq ?instance:player ?player))
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='ENEMYHAND' class='enemy_hand' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (and (eq ?instance:state HAND) (neq ?instance:player ?player))
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='PLAYERDRAW' class='player_draw' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (and (eq ?instance:state DRAW) (eq ?instance:player ?player))
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='ENEMYDRAW' class='enemy_draw' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (and (eq ?instance:state DRAW) (neq ?instance:player ?player))
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='PLAYERDISCARD' class='player_discard' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (and (eq ?instance:state DISCARD) (eq ?instance:player ?player))
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='ENEMYDISCARD' class='enemy_discard' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (and (eq ?instance:state DISCARD) (neq ?instance:player ?player))
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='PLAYERMP' class='player_mp' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (and (eq ?instance:state MP) (eq ?instance:player ?player))
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='ENEMYMP' class='enemy_mp' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (and (eq ?instance:state MP) (neq ?instance:player ?player))
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='OUTOFGAME' class='out_of_game' draggable=true >")
    (do-for-all-instances ((?instance CARD)) (eq ?instance:state OUT-OF-GAME)
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    ; Dibujar eventos
    (state ?player "<div class='events'>")
    (do-for-all-instances ((?instance EVENT)) TRUE
        (draw ?player ?instance)
    )
    (state ?player "</div>" crlf)

    (state ?player "<div id='PASS' class='pass' draggable=true ></div>" crlf)

    ;TODO: COUNCIL


    (state ?player "</div>" crlf)
)