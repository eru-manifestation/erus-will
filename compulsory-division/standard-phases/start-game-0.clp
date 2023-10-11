;/////////////////// INICIA EL JUEGO 0: SE INICIA LA MESA ////////////////////////
(defmodule start-game-0 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug INICIA EL JUEGO, creamos la mesa)

(assert (post-drawS))
(assert (post-drawG))

)
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (play-actions ?p))

(deffunction init-handS()
    (debug Creating inital card of Saruman)

    (init-card GIMLI 1 2)
    (init-card LEGOLAS 1 2)
    (init-card ELLADAN 1 2)
    (init-card ELVEN-CLOAK 1 2)
    (init-card PIPPIN 1 2)
    (init-card DAGGER-OF-WESTERNESS 1 2)
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
    
    
    (debug Initial cards of Saruman created)
)

(deffunction init-handG()
    (debug Creating inital card of Gandalf)

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
    (init-card CONCEALEMENT 3 1)
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
    (init-card TOM 1 1)
    (init-card GIANT 2 1)
    (init-card ORC-GUARD 2 1)
    (init-card ORC-LIEAUTENANT 2 1)
    (init-card ORC-WARRIORS 3 1)
    (init-card BRIGANDS 3 1)
    (init-card CAVE-DRAKE 2 1)
    
    (debug Initial cards of Gandalf created)
)

(defrule init-cards
	=>
	(init-locations)
	(init-handG)
	(init-handS)
)


(defrule post-drawS
    ?pd <- (post-drawS)
    (enemy ?p)
    (object (is-a GIMLI) (name ?gimli) (player ?p))
    (object (is-a LEGOLAS) (name ?legolas) (player ?p))
    (object (is-a ELLADAN) (name ?elladan) (player ?p))
    (object (is-a PIPPIN) (name ?pippin) (player ?p))
    (object (is-a ELVEN-CLOAK) (name ?cloak) (player ?p))
    (object (is-a DAGGER-OF-WESTERNESS) (name ?dagger) (player ?p))

    (object (is-a RIVENDELL) (name ?rivendell))
    (object (is-a FELLOWSHIP) (name ?fell) (player ?p))
    (in (over ?rivendell) (under ?fell))
    =>
    (debug Putting initial fellowship of Saruman)

    (make-instance (gen-name E-char-play) of E-char-play (character ?gimli) (under ?fell))
    (make-instance (gen-name E-char-play) of E-char-play (character ?legolas) (under ?fell))
    (make-instance (gen-name E-char-play) of E-char-play (character ?elladan) (under ?fell))
    (make-instance (gen-name E-char-play) of E-char-play (character ?pippin) (under ?fell))

    (debug Putting initial items of Saruman)

    (make-instance (gen-name E-item-play-only-minor) of E-item-play-only-minor (item ?cloak) (owner ?elladan))
    (make-instance (gen-name E-item-play-only-minor) of E-item-play-only-minor (item ?dagger) (owner ?pippin))

    ;ESTA REGLA SOLO SE DEBE LANZAR UNA VEZ
    (retract ?pd)
)



(defrule post-drawG
    ?pd <- (post-drawG)
    (player ?p)
    (object (is-a ARAGORN-II) (name ?aragorn) (player ?p))
    (object (is-a EOMER) (name ?eomer) (player ?p))
    (object (is-a BOROMIR-II) (name ?boromir) (player ?p))
    (object (is-a MERRY) (name ?merry) (player ?p))
    (object (is-a ELVEN-CLOAK) (name ?cloak) (player ?p))
    (object (is-a SHIELD-OF-IRON--BOUND-ASH) (name ?shield) (player ?p))

    (object (is-a RIVENDELL) (name ?rivendell))
    (object (is-a FELLOWSHIP) (name ?fell) (player ?p))
    (in (over ?rivendell) (under ?fell))
    =>
    (debug Putting initial fellowship of Gandalf)

    (make-instance (gen-name E-char-play) of E-char-play (character ?aragorn) (under ?fell))
    (make-instance (gen-name E-char-play) of E-char-play (character ?eomer) (under ?fell))
    (make-instance (gen-name E-char-play) of E-char-play (character ?boromir) (under ?fell))
    (make-instance (gen-name E-char-play) of E-char-play (character ?merry) (under ?fell))

    (debug Putting initial items of Gandalf)

    (make-instance (gen-name E-item-play-only-minor) of E-item-play-only-minor (item ?shield) (owner ?boromir))
    (make-instance (gen-name E-item-play-only-minor) of E-item-play-only-minor (item ?cloak) (owner ?merry))

    ;ESTA REGLA SOLO SE DEBE LANZAR UNA VEZ
    (retract ?pd)
)