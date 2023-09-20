; PERSONAJES Y OBJETOS INICIALES

(defclass ARAGORN-II (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 3))
    (slot mind (default 9))
    (slot race (default TODO))
)

(defclass EOMER (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 0))
    (slot mind (default 3))
    (slot race (default TODO))
)

(defclass BOROMIR-II (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 1))
    (slot mind (default 4))
    (slot race (default TODO))
)

(defclass SHIELD-OF-IRON--BOUND-ASH (is-a MINOR-ITEM)(slot instance-# (type INTEGER) (default 2) (storage shared))
)

(defclass MERRY (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 1))
    (slot mind (default 4))
    (slot race (default TODO))
)

(defclass ELVEN-CLOAK (is-a MINOR-ITEM)(slot instance-# (type INTEGER) (default 2) (storage shared))
)

; RECURSOS (OBJETOS)

(defclass SCROLL-OF-ISILDUR (is-a GREATER-ITEM)(slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass GREAT-SHIELD-OF-ROHAN (is-a MAJOR-ITEM)(slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass SCROLL-OF-ISILDUR (is-a GREATER-ITEM)(slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass GLAMDRING (is-a MAJOR-ITEM)(slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass STAR--GLASS (is-a MINOR-ITEM)(slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass RED-ARROW (is-a MAJOR-ITEM)(slot instance-# (type INTEGER) (default 2) (storage shared)))


; RECURSOS (FACCIONES)

(defclass RANGERS-OF-THE-NORTH (is-a FACTION)(slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass RIDERS-OF-ROHAN (is-a FACTION)(slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass TOWER-GUARD-OF-MINAS-TIRITH (is-a FACTION)(slot instance-# (type INTEGER) (default 2) (storage shared)))


; RECURSOS (ALIADOS)

(defclass QUICKBEAM (is-a ALLY) (slot instance-# (type INTEGER) (default 2) (storage shared)))


; RECURSOS (SUCESOS)

(defclass DODGE (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass LUCKY-STRIKE (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass NEW-FRIENDSHIP (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass CONCEALEMENT (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass HALFLING-STRENGTH (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass ESCAPE (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass FORD (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass A-FRIEND-OR-THREE (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass LAPSE-OF-WILL (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass DODGE (is-a R-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

; PERSONAJES

(defclass GANDALF (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 10))
    (slot mind (default 0))
    (slot race (default TODO))
)

(defclass BEREGOND (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 0))
    (slot mind (default 2))
    (slot race (default TODO))
)

(defclass FARAMIR (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 1))
    (slot mind (default 5))
    (slot race (default TODO))
)

(defclass KILI (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 0))
    (slot mind (default 3))
    (slot race (default TODO))
)

(defclass ERKENBRAND (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 2))
    (slot mind (default 4))
    (slot race (default TODO))
)

(defclass BERETAR (is-a CHARACTER)     
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot birthplace (default TODO))
    (slot influence (default 1))
    (slot mind (default 5))
    (slot race (default TODO))
)

; ADVERSIDADES (SUCESOS)

(defclass AWAKEN-MINIONS (is-a A-LONG-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass MUSTER-DISPERSES (is-a A-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass MINIONS-STIR (is-a A-LONG-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass LURE-OF-NATURE (is-a A-PERMANENT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass WEARINESS-OF-THE-HEART (is-a A-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass AWAKEN-MINIONS (is-a A-LONG-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass NEW-MOON (is-a A-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass TWILIGHT (is-a A-SHORT-EVENT) (slot instance-# (type INTEGER) (default 2) (storage shared)))


; ADVERSIDADES (CRIATURAS)

(defclass TOM (is-a CREATURE) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass GIANT (is-a CREATURE) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass ORC-GUARD (is-a CREATURE) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass ORC-LIEAUTENANT (is-a CREATURE) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass ORC-WARRIORS (is-a CREATURE) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass BRIGANDS (is-a CREATURE) (slot instance-# (type INTEGER) (default 2) (storage shared)))

(defclass CAVE-DRAKE (is-a CREATURE) (slot instance-# (type INTEGER) (default 2) (storage shared)))



; DEFINICIÓN DE LA MANO

(deffunction MAIN::init-card(?card-class ?times ?player-n)
    (make-instance (gen-name ?card-class) of ?card-class 
        (player (sym-cat [player ?player-n ])))
    (if (< 1 ?times)
    then
        (init-card ?card-class (- ?times 1) ?player-n)
    )
)

(deffunction MAIN::init-handG()
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
    
)


;(definstances handG
;    ((gen-name ARAGORN-II) of ARAGORN-II (player [player1]))
;    ((gen-name EOMER) of EOMER (player [player1]))
;    ((gen-name BOROMIR-II) of BOROMIR-II (player [player1]))
;    ((gen-name SHIELD-OF-IRON--BOUND-ASH) of SHIELD-OF-IRON--BOUND-ASH (player [player1]))
;)