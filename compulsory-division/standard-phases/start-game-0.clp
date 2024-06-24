;/////////////////// INICIA EL JUEGO 0: SE INICIA LA MESA ////////////////////////
(defmodule start-game-0 (import MAIN ?ALL))

;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(deffunction init-handG()
    (message Creating inital card of Gandalf)

    ; PERSONAJES
    (init-card ARAGORN-II 1 1)
    (init-card BOROMIR-II 1 1)
    (init-card KILI 1 1)
    (init-card MERRY 1 1)
    (init-card BEREGOND 1 1)
    (init-card FARAMIR 1 1)
    (init-card EOMER 1 1)
    (init-card GANDALF 2 1)
    (init-card ERKENBRAND 1 1)

    ; OBJETOS
    (init-card SHIELD-OF-IRON--BOUND-ASH 1 1)
    (init-card ELVEN-CLOAK 1 1)
    (init-card SCROLL-OF-ISILDUR 1 1)
    (init-card GREAT-SHIELD-OF-ROHAN 1 1)
    (init-card GLAMDRING 1 1)

    ; RECURSOS
    (init-card DODGE 3 1)
    (init-card LUCKY-STRIKE 3 1)
    (init-card TEMPERING-FRIENDSHIP 1 1)
    (init-card CONCEALMENT 2 1)
    (init-card HALFLING-STRENGTH 3 1)
    (init-card ESCAPE 2 1)
    (init-card FORD 1 1)
    (init-card BRIDGE 1 1)
    (init-card MUSTER 1 1)

    ; ALIADOS
    (init-card QUICKBEAM 1 1)

    ; FACCIONES
    (init-card RANGERS-OF-THE-NORTH 1 1)
    (init-card RIDERS-OF-ROHAN 1 1)
    (init-card TOWER-GUARD-OF-MINAS-TIRITH 1 1)

    ; ADVERSIDADES
    (init-card BERT-BURAT 1 1)
    (init-card ORC--RAIDERS 3 1)
    (init-card ORC--GUARD 3 1)
    (init-card ORC--WARRIORS 3 1)
    (init-card BRIGANDS 3 1)
    (init-card WILLIAM-WULUAG 1 1)
    (init-card ORC--WATCH 3 1)
    (init-card AROUSE-MINIONS 3 1)
    (init-card RIVER 2 1)
    (init-card MINIONS-STIR 2 1)
    
    (message Initial cards of Gandalf created)
)

(deffunction init-handS()
    (message Creating inital card of Saruman)

    ; PERSONAJES
    (init-card WOLVES 3 2); Los pongo adelante para poder probar el combate
    (init-card GIMLI 1 2)
    (init-card LEGOLAS 1 2)
    (init-card ELLADAN 1 2)
    (init-card PIPPIN 1 2)
    (init-card SARUMAN 2 2)
    (init-card ANNALENA 1 2)
    (init-card BARD-BOWMAN 1 2)
    (init-card CELEBORN 1 2)
    (init-card ELROHIR 1 2)

    ; OBJETOS
    (init-card ELVEN-CLOAK 1 2)
    (init-card DAGGER-OF-WESTERNESSE 1 2)
    (init-card HAUBERK-OF-BRIGHT-MAIL 1 2)
    (init-card ORCRIST 1 2)
    (init-card SWORD-OF-GONDOLIN 2 2)

    ; RECURSOS
    (init-card TEMPERING-FRIENDSHIP 1 2)
    (init-card CONCEALMENT 2 2)
    (init-card HALFLING-STRENGTH 3 2)
    (init-card ESCAPE 1 2)
    (init-card FORD 1 2)
    (init-card BRIDGE 1 2)
    (init-card MUSTER 1 2)
    (init-card BLOCK 3 2)
    (init-card RISKY-BLOW 3 2)
    (init-card DARK-QUARRELS 1 2)

    ; ALIADOS
    (init-card GOLLUM 1 2)

    ; FACCIONES
    (init-card DUNLENDINGS 1 2)
    (init-card WOOD--ELVES 1 2)
    (init-card ENTS-OF-FANGORN 1 2)

    ; ADVERSIDADES
    (init-card AROUSE-MINIONS 3 2)
    (init-card RIVER 2 2)
    (init-card WARGS 3 2)
    (init-card GHOSTS 2 2)
    (init-card LESSER-SPIDERS 3 2)
    (init-card GHOULS 2 2)
    (init-card HUORN 2 2)
    (init-card BARROW-WIGHTS 2 2)
    (init-card WAKE-OF-WAR 2 2)
    
    (message Initial cards of Saruman created)
)

(defrule init-cards
	=>
	(init-locations)
	(init-handG)
	(init-handS)
)


(defrule initial-chars
    (object (is-a CHARACTER) 
        (name ?char&[gimli1]|[legolas1]|[elladan1]|[pippin1]|
        [aragorn-ii1]|[kili1]|[boromir-ii1]|[merry1])
        (player ?p)
        (position ?draw&:(eq ?draw (drawsymbol ?p)))
    )
    (object (is-a FELLOWSHIP) (position ?loc&:(eq ?loc (symbol-to-instance-name rivendell)))
        (player ?p) (name ?fell&[fellowship1]|[fellowship2])
    )
    =>
    (E-play ?char ?fell start-game-0::initial-chars)
    (message "Jugando personaje inicial " ?char)
)



(defrule initial-items
    ?minoritem <- (object (is-a MINOR-ITEM)
        (name ?itemname&[elven-cloak2]|[dagger-of-westernesse1]
        |[elven-cloak1]|[shield-of-iron--bound-ash1]) 
        (player ?p)
        (position ?draw&:(eq ?draw (drawsymbol ?p)))
    )
    (not (and
        (object (is-a CHARACTER) 
            (name ?char)
            (player ?p2)
            (position ?hand&:(eq ?hand (drawsymbol ?p2)))
        )
        (test (or
            (eq ?char [elladan1])
            (eq ?char [pippin1])
            (eq ?char [boromir-ii1])
            (eq ?char [merry1])
        ))
    ))
    =>
    (bind ?holder (switch ?itemname
        (case [elven-cloak2] then [pippin1])
        (case [dagger-of-westernesse1] then [legolas1])
        (case [elven-cloak1] then [merry1])
        (case [shield-of-iron--bound-ash1] then [boromir-ii1])
    ))
    (E-play ?itemname ?holder start-game-0::initial-items)
    (message "Jugando objeto inicial " ?itemname " en " ?holder)
)