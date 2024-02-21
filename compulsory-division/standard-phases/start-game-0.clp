;/////////////////// INICIA EL JUEGO 0: SE INICIA LA MESA ////////////////////////
(defmodule start-game-0 (import MAIN ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(message INICIA EL JUEGO, creamos la mesa))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))

(deffunction init-handS()
    (message Creating inital card of Saruman)

    (init-card GIMLI 1 2)
    (init-card LEGOLAS 1 2)
    (init-card ELLADAN 1 2)
    (init-card ELVEN-CLOAK 1 2)
    (init-card PIPPIN 1 2)
    (init-card DAGGER-OF-WESTERNESSE 1 2)
    (init-card HAUBERK-OF-BRIGHT-MAIL 1 2)
    (init-card ORCRIST 1 2)
    (init-card SWORD-OF-GONDOLIN 2 2)
    (init-card PALANTIR-OF-ORTHANC 1 2)
    (init-card HEALING-HERBS 1 2)
    (init-card DUNLENDINGS 1 2)
    (init-card WOOD--ELVES 1 2)
    (init-card ENTS-OF-FANGORN 1 2)
    (init-card GOLLUM 1 2)
    (init-card BLOCK 3 2)
    (init-card RISKY-BLOW 3 2)
    (init-card HALFLING-STEALTH 2 2)
    (init-card BRIDGE 2 2)
    (init-card MUSTER 3 2)
    (init-card DARK-QUARRELS 3 2)
    (init-card VANISHMENT 2 2)
    (init-card FAIR-TRAVELS-IN-WILDERNESS 2 2)
    (init-card SARUMAN 2 2)
    (init-card ANNALENA 1 2)
    (init-card BARD-BOWMAN 1 2)
    (init-card ELROHIR 1 2)
    (init-card CELEBORN 1 2)
    (init-card PEATH 1 2)
    (init-card CHOKING-SHADOWS 2 2)
    (init-card CALL-OF-HOME 2 2)
    (init-card WAKE-OF-WAR 3 2)
    (init-card RIVER 2 2)
    (init-card PLAGUE-OF-WIGHTS 2 2)
    (init-card LURE-OF-POWER 2 2)
    (init-card DOORS-OF-NIGHT 2 2)
    (init-card WARGS 2 2)
    (init-card WOLVES 3 2)
    (init-card GHOSTS 2 2)
    (init-card LESSER-SPIDERS 3 2)
    (init-card GHOULS 2 2)
    (init-card OLD-MAN-WILLOW 1 2)
    (init-card AMBUSHER 1 2)
    
    
    (message Initial cards of Saruman created)
)

(deffunction init-handG()
    (message Creating inital card of Gandalf)

    (init-card ARAGORN-II 1 1)
    (init-card EOMER 1 1)
    (init-card BOROMIR-II 1 1)
    (init-card SHIELD-OF-IRON--BOUND-ASH 1 1)
    (init-card MERRY 1 1)
    (init-card ELVEN-CLOAK 1 1)
    (init-card SCROLL-OF-ISILDUR 1 1)
    (init-card GREAT-SHIELD-OF-ROHAN 1 1)
    (init-card GLAMDRING 1 1)
    (init-card STAR--GLASS 1 1)
    (init-card RED-ARROW 1 1)
    (init-card RANGERS-OF-THE-NORTH 1 1)
    (init-card RIDERS-OF-ROHAN 1 1)
    (init-card TOWER-GUARD-OF-MINAS-TIRITH 1 1)
    (init-card QUICKBEAM 1 1)
    (init-card DODGE 3 1)
    (init-card LUCKY-STRIKE 3 1)
    (init-card NEW-FRIENDSHIP 2 1)
    (init-card CONCEALMENT 3 1)
    (init-card HALFLING-STRENGTH 2 1)
    (init-card ESCAPE 2 1)
    (init-card FORD 2 1)
    (init-card A-FRIEND-OR-THREE 2 1)
    (init-card LAPSE-OF-WILL 2 1)
    (init-card GANDALF 2 1)
    (init-card BEREGOND 1 1)
    (init-card FARAMIR 1 1)
    (init-card KILI 1 1)
    (init-card ERKENBRAND 1 1)
    (init-card BERETAR 1 1)
    (init-card AWAKEN-MINIONS 2 1)
    (init-card MUSTER-DISPERSES 2 1)
    (init-card MINIONS-STIR 3 1)
    (init-card LURE-OF-NATURE 2 1)
    (init-card WEARINESS-OF-THE-HEART 2 1)
    (init-card NEW-MOON 2 1)
    (init-card TWILIGHT 2 1)
    (init-card TOM-TUMA 1 1)
    (init-card GIANT 2 1)
    (init-card ORC--GUARD 2 1)
    (init-card ORC--LIEUTENANT 2 1)
    (init-card ORC--WARRIORS 3 1)
    (init-card BRIGANDS 3 1)
    (init-card CAVE-DRAKE 2 1)
    
    (message Initial cards of Gandalf created)
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
        [aragorn-ii1]|[eomer1]|[boromir-ii1]|[merry1])
        (player ?p)
        (position ?draw&:(eq ?draw (drawsymbol ?p)))
    )
    (object (is-a FELLOWSHIP) (position ?loc&:(eq ?loc (symbol-to-instance-name rivendell)))
        (player ?p) (name ?fell&[fellowship1]|[fellowship2])
    )
    =>
    (E-modify ?char position ?fell PLAY CHARACTER start-game-0::initial-chars)
    (message "Jugando personaje inicial " ?char)
)



(defrule initial-items
    ?minoritem <- (object (is-a MINOR-ITEM)
        (name ?itemname&[elven-cloak2]|[dagger-of-westernesse1]
        |[elven-cloak1]|[shield-of-iron--bound-ash1]) 
        (player ?p)
        (position ?draw&:(eq ?draw (drawsymbol ?p)))
    )
    (not (exists
        (object (is-a CHARACTER) 
            (name ?char&[elladan1]|[pippin1]|[boromir-ii1]|[merry1])
            (player ?p)
            (position ?fell&:(neq (class ?fell) FELLOWSHIP))
        )
    ))
    =>
    (bind ?holder (switch ?itemname
        (case [elven-cloak2] then [elladan1])
        (case [dagger-of-westernesse1] then [pippin1])
        (case [elven-cloak1] then [merry1])
        (case [shield-of-iron--bound-ash1] then [boromir-ii1])
    ))
    (E-modify ?itemname position ?holder PLAY ITEM start-game-0::initial-items)
    (message "Jugando objeto inicial " ?itemname " en " ?holder)
)