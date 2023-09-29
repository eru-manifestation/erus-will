; PERSONAJES Y OBJETOS INICIALES

(defclass ARAGORN-II (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 3))
    (slot mind (source composite) (default 9))
    (slot race (source composite) (default TODO))
)
(defmessage-handler ARAGORN-II get-mind () (call-next-handler))
(defmessage-handler ARAGORN-II raw-mind () ?self:mind)
(defmessage-handler ARAGORN-II get-influence () (call-next-handler))
(defmessage-handler ARAGORN-II raw-influence () ?self:influence)

(defclass EOMER (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 3))
    (slot race (source composite) (default TODO))
)
(defmessage-handler EOMER get-mind () (call-next-handler))
(defmessage-handler EOMER raw-mind () ?self:mind)
(defmessage-handler EOMER get-influence () (call-next-handler))
(defmessage-handler EOMER raw-influence () ?self:influence)

(defclass BOROMIR-II (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default TODO))
    (slot corruption (source composite) (default -1))
)
(defmessage-handler BOROMIR-II get-corruption () (call-next-handler))
(defmessage-handler BOROMIR-II raw-corruption () ?self:corruption)
(defmessage-handler BOROMIR-II get-mind () (call-next-handler))
(defmessage-handler BOROMIR-II raw-mind () ?self:mind)
(defmessage-handler BOROMIR-II get-influence () (call-next-handler))
(defmessage-handler BOROMIR-II raw-influence () ?self:influence)


(defclass SHIELD-OF-IRON--BOUND-ASH (is-a MINOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
)

(defclass MERRY (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default TODO))
)
(defmessage-handler MERRY get-mind () (call-next-handler))
(defmessage-handler MERRY raw-mind () ?self:mind)
(defmessage-handler MERRY get-influence () (call-next-handler))
(defmessage-handler MERRY raw-influence () ?self:influence)


(defclass ELVEN-CLOAK (is-a MINOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
)

; RECURSOS (OBJETOS)

(defclass SCROLL-OF-ISILDUR (is-a GREATER-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 3))
)

(defclass GREAT-SHIELD-OF-ROHAN (is-a MAJOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 2))
)

(defclass GLAMDRING (is-a MAJOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
)

(defclass STAR--GLASS (is-a MINOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
)

(defclass RED-ARROW (is-a MAJOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 2))
)


; RECURSOS (FACCIONES)

(defclass RANGERS-OF-THE-NORTH (is-a FACTION)(slot instance-# (source composite)))

(defclass RIDERS-OF-ROHAN (is-a FACTION)(slot instance-# (source composite)))

(defclass TOWER-GUARD-OF-MINAS-TIRITH (is-a FACTION)(slot instance-# (source composite)))


; RECURSOS (ALIADOS)

(defclass QUICKBEAM (is-a ALLY) (slot instance-# (source composite)))


; RECURSOS (SUCESOS)

(defclass DODGE (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass LUCKY-STRIKE (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass NEW-FRIENDSHIP (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass CONCEALEMENT (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass HALFLING-STRENGTH (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass ESCAPE (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass FORD (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass A-FRIEND-OR-THREE (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass LAPSE-OF-WILL (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

(defclass DODGE (is-a R-SHORT-EVENT) (slot instance-# (source composite)))

; PERSONAJES

(defclass GANDALF (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 10))
    (slot mind (source composite) (default 0))
    (slot race (source composite) (default TODO))
    (slot corruption (source composite) (default 1))
)
(defmessage-handler GANDALF get-corruption () (call-next-handler))
(defmessage-handler GANDALF raw-corruption () ?self:corruption)
(defmessage-handler GANDALF get-mind () (call-next-handler))
(defmessage-handler GANDALF raw-mind () ?self:mind)
(defmessage-handler GANDALF get-influence () (call-next-handler))
(defmessage-handler GANDALF raw-influence () ?self:influence)

(defclass BEREGOND (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 2))
    (slot race (source composite) (default TODO))
    (slot corruption (source composite) (default -1))
)
(defmessage-handler BEREGOND get-corruption () (call-next-handler))
(defmessage-handler BEREGOND raw-corruption () ?self:corruption)
(defmessage-handler BEREGOND get-mind () (call-next-handler))
(defmessage-handler BEREGOND raw-mind () ?self:mind)
(defmessage-handler BEREGOND get-influence () (call-next-handler))
(defmessage-handler BEREGOND raw-influence () ?self:influence)

(defclass FARAMIR (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 5))
    (slot race (source composite) (default TODO))
)

(defclass KILI (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 3))
    (slot race (source composite) (default TODO))
    (slot corruption (source composite) (default -1))
)
(defmessage-handler KILI get-corruption () (call-next-handler))
(defmessage-handler KILI raw-corruption () ?self:corruption)
(defmessage-handler KILI get-mind () (call-next-handler))
(defmessage-handler KILI raw-mind () ?self:mind)
(defmessage-handler KILI get-influence () (call-next-handler))
(defmessage-handler KILI raw-influence () ?self:influence)

(defclass ERKENBRAND (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 2))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default TODO))
)
(defmessage-handler ERKENBRAND get-mind () (call-next-handler))
(defmessage-handler ERKENBRAND raw-mind () ?self:mind)
(defmessage-handler ERKENBRAND get-influence () (call-next-handler))
(defmessage-handler ERKENBRAND raw-influence () ?self:influence)

(defclass BERETAR (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 5))
    (slot race (source composite) (default TODO))
)
(defmessage-handler BERETAR get-mind () (call-next-handler))
(defmessage-handler BERETAR raw-mind () ?self:mind)
(defmessage-handler BERETAR get-influence () (call-next-handler))
(defmessage-handler BERETAR raw-influence () ?self:influence)

; ADVERSIDADES (SUCESOS)

(defclass AWAKEN-MINIONS (is-a A-LONG-EVENT) (slot instance-# (source composite)))

(defclass MUSTER-DISPERSES (is-a A-SHORT-EVENT) (slot instance-# (source composite)))

(defclass MINIONS-STIR (is-a A-LONG-EVENT) (slot instance-# (source composite)))

(defclass LURE-OF-NATURE (is-a A-PERMANENT-EVENT) (slot instance-# (source composite)))

(defclass WEARINESS-OF-THE-HEART (is-a A-SHORT-EVENT) (slot instance-# (source composite)))

(defclass AWAKEN-MINIONS (is-a A-LONG-EVENT) (slot instance-# (source composite)))

(defclass NEW-MOON (is-a A-SHORT-EVENT) (slot instance-# (source composite)))

(defclass TWILIGHT (is-a A-SHORT-EVENT) (slot instance-# (source composite)))


; ADVERSIDADES (CRIATURAS)

(defclass TOM (is-a CREATURE) (slot instance-# (source composite)))

(defclass GIANT (is-a CREATURE) (slot instance-# (source composite)))

(defclass ORC-GUARD (is-a CREATURE) (slot instance-# (source composite)))

(defclass ORC-LIEAUTENANT (is-a CREATURE) (slot instance-# (source composite)))

(defclass ORC-WARRIORS (is-a CREATURE) (slot instance-# (source composite)))

(defclass BRIGANDS (is-a CREATURE) (slot instance-# (source composite)))

(defclass CAVE-DRAKE (is-a CREATURE) (slot instance-# (source composite)))



