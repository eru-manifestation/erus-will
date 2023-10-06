; DEFINICIÓN DE LA MANO

(deffunction MAIN::init-card(?card-class ?times ?player-n)
    (make-instance (gen-name ?card-class) of ?card-class 
        (player (symbol-to-instance-name (sym-cat player ?player-n))))
    (if (< 1 ?times)
    then
        (init-card ?card-class (- ?times 1) ?player-n)
    )
)

(deffunction MAIN::init-handG()
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


(defrule MAIN::post-drawG (declare (auto-focus TRUE) (salience ?*universal-rules-salience*))
    ?pd <- (post-drawG)
    (object (is-a ARAGORN-II) (name ?aragorn) (player ?p&:(eq ?p ?*player*)))
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

    (make-instance (gen-name E-item-play) of E-item-play (item ?shield) (owner ?boromir))
    (make-instance (gen-name E-item-play) of E-item-play (item ?cloak) (owner ?merry))

    ;ESTA REGLA SOLO SE DEBE LANZAR UNA VEZ
    (retract ?pd)
)


;(definstances handG
;    ((gen-name ARAGORN-II) of ARAGORN-II (player [player1]))
;    ((gen-name EOMER) of EOMER (player [player1]))
;    ((gen-name BOROMIR-II) of BOROMIR-II (player [player1]))
;    ((gen-name SHIELD-OF-IRON--BOUND-ASH) of SHIELD-OF-IRON--BOUND-ASH (player [player1]))
;)