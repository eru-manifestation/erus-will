;TODO: IMPORTANTE, RECORDAR QUE LA CORRUPCIÓN DE LOS PERSONAJES AL SER UN MODIFICADOR,
;   SE DEBE INVERTIR CON RESPECTO A LA INFORMACIÓN DE LA CARTA

; PERSONAJES Y OBJETOS INICIALES

(defclass ARAGORN-II (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 3))
    (slot mind (source composite) (default 9))
    (slot race (source composite) (default DUNADAN))
)

(defclass EOMER (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 3))
    (slot race (source composite) (default MAN))
)

(defclass BOROMIR-II (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default DUNADAN))
    (slot corruption (source composite) (default 1))
)

(defclass SHIELD-OF-IRON--BOUND-ASH (is-a MINOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
)

(defclass MERRY (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default HOBBIT))
)


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
    (slot race (source composite) (default WIZARD))
    (slot corruption (source composite) (default -1))
)

(defclass BEREGOND (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 2))
    (slot race (source composite) (default DUNADAN))
    (slot corruption (source composite) (default 1))
)

(defclass FARAMIR (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 5))
    (slot race (source composite) (default DUNADAN))
)

(defclass KILI (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 3))
    (slot race (source composite) (default DWARF))
    (slot corruption (source composite) (default 1))
)

(defclass ERKENBRAND (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 2))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default MAN))
)

(defclass BERETAR (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default TODO))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 5))
    (slot race (source composite) (default DUNADAN))
)

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

(defclass TOM (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default TROLL))
    (slot regions (source composite) (default (create$ WILDERNESS 2))) 
    (slot prowess (source composite) (default 13))   
)

(defclass GIANT (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default GIANT))
    (slot regions (source composite) (default WILDERNESS 2)) 
    (slot prowess (source composite) (default 13))   
)

(defclass ORC-GUARD (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default ORC))   
    (slot regions (source composite) (default SHADOW-LAND 1 DARK-LAND 1)) 
    (slot prowess (source composite) (default 8)) 
    (slot strikes (source composite) (default 5)) 
    (multislot places (source composite) (default SHADOW-HOLD DARK-HOLD)) 
)

(defclass ORC-LIEAUTENANT (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default ORC))  
    (slot regions (source composite) (default (create$ WILDERNESS 1 SHADOW-LAND 1 DARK-LAND 1))) 
    (slot prowess (source composite) (default 7)) 
    (multislot places (source composite) (default RUINS SHADOW-HOLD DARK-HOLD))    
)

(defclass ORC-WARRIORS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default ORC))   
    (slot regions (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1))) 
    (slot prowess (source composite) (default 7))   
    (slot strikes (source composite) (default 3)) 
    (multislot places (source composite) (default RUINS))    
)

(defclass BRIGANDS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default MAN))   
    (slot regions (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1))) 
    (slot prowess (source composite) (default 8))   
    (slot strikes (source composite) (default 2))    
)

(defclass CAVE-DRAKE (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default DRAGON)) 
    (slot regions (source composite) (default (create$ WILDERNESS 2))) 
    (slot prowess (source composite) (default 10))   
    (slot strikes (source composite) (default 2))      
    (multislot places (source composite) (default RUINS))    
)



