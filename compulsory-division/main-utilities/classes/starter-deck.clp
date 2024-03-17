;TODO: IMPORTANTE, RECORDAR QUE LA CORRUPCIÓN DE LOS PERSONAJES AL SER UN MODIFICADOR, SE DEBE INVERTIR CON RESPECTO A LA INFORMACIÓN DE LA CARTA
; baraja ID tipo nombre

; PERSONAJES GANDALF
; G01 TW009 Personaje Aragorn II
(defclass ARAGORN-II (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [bree]))
    (slot influence (source composite) (default 3))
    (slot mind (source composite) (default 9))
    (slot race (source composite) (default DUNEDAIN))
    (multislot skills (source composite) (default WARRIOR SCOUT RANGER))
    (slot mp (source composite) (default 3))
    (slot prowess (source composite) (default 6))
    (slot body (source composite) (default 9))
)


; G02 TW023 Personaje Boromir II
(defclass BOROMIR-II (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [minas-tirith]))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default DUNEDAIN))
    (multislot skills (source composite) (default WARRIOR))
    (slot corruption (source composite) (default 1))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 6))
    (slot body (source composite) (default 7))
)

; G04 TW054 Personaje Kili
(defclass KILI (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [blue-mountains-dwarf--hold]))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 3))
    (slot race (source composite) (default DWARF))
    (multislot skills (source composite) (default WARRIOR SCOUT))
    (slot corruption (source composite) (default 1))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 3))
    (slot body (source composite) (default 8))
)


; G05 TW057 Personaje Merry
(defclass MERRY (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [bag-end]))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default HOBBIT))
    (multislot skills (source composite) (default SCOUT))
    (slot corruption (source composite) (default -2))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 1))
    (slot body (source composite) (default 9))
)


; G17 TW016 Personaje Beregond
(defclass BEREGOND (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [minas-tirith]))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 2))
    (slot race (source composite) (default DUNEDAIN))
    (multislot skills (source composite) (default WARRIOR))
    (slot corruption (source composite) (default 1))
    (slot mp (source composite) (default 0))
    (slot prowess (source composite) (default 4))
    (slot body (source composite) (default 8))
)


; G22 TW037 Personaje Faramir
(defclass FARAMIR (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [henneth-annun]))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 5))
    (slot race (source composite) (default DUNEDAIN))
    (multislot skills (source composite) (default WARRIOR RANGER))
    (slot mp (source composite) (default 2))
    (slot prowess (source composite) (default 5))
    (slot body (source composite) (default 8))
)


; G25 TW034 Personaje Ã‰omer
(defclass EOMER (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [edoras]))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 3))
    (slot race (source composite) (default MAN))
    (multislot skills (source composite) (default WARRIOR RANGER))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 3))
    (slot body (source composite) (default 8))
)


; G26 TW002 Personaje Gandalf
; G38 TW002 Personaje Gandalf
(defclass GANDALF (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [rivendell]))
    (slot influence (source composite) (default 10))
    (slot mind (source composite) (default 0))
    (multislot skills (source composite) (default WARRIOR SCOUT SAGE DIPLOMAT))
    (slot race (source composite) (default WIZARD))
    (slot corruption (source composite) (default -1))
    (slot prowess (source composite) (default 6))
    (slot body (source composite) (default 9))
)


; G44 TW036 Personaje Erkenbrand
(defclass ERKENBRAND (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [edoras]))
    (slot influence (source composite) (default 2))
    (slot mind (source composite) (default 4))
    (multislot skills (source composite) (default WARRIOR))
    (slot race (source composite) (default MAN))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 5))
    (slot body (source composite) (default 6))
)



; PERSONAJES SARUMAN
; TODO: investigar que significa influencia directa sobre elfos
; S01 TW046 Personaje Gimli
(defclass GIMLI (is-a CHARACTER)
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [iron-hill-dwarf--hold]))
    (slot influence (source composite) (default 2))
    (slot mind (source composite) (default 6))
    (multislot skills (source composite) (default WARRIOR DIPLOMAT))
    (slot race (source composite) (default DWARF))
    (slot mp (source composite) (default 2))
    (slot prowess (source composite) (default 5))
    (slot body (source composite) (default 8))
)


; S02 TW055 Personaje Legolas
(defclass LEGOLAS (is-a CHARACTER)
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [thranduils-halls]))
    (slot influence (source composite) (default 2))
    (slot mind (source composite) (default 6))
    (multislot skills (source composite) (default WARRIOR DIPLOMAT))
    (slot race (source composite) (default ELF))
    (slot mp (source composite) (default 2))
    (slot prowess (source composite) (default 5))
    (slot body (source composite) (default 8))
)


; S04 TW031 Personaje Elladan
(defclass ELLADAN (is-a CHARACTER)
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [rivendell]))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 4))
    (multislot skills (source composite) (default WARRIOR RANGER))
    (slot race (source composite) (default ELF))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 5))
    (slot body (source composite) (default 8))
)


; S05 TW063 Personaje Pippin
(defclass PIPPIN (is-a CHARACTER)
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [bag-end]))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default HOBBIT))
    (slot corruption (source composite) (default -2))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 1))
    (slot body (source composite) (default 9))
)

; TODO: añadir caracteristicas propias desde aqui
; TODO: gestionar unicidad

; S19 TW005 Personaje Saruman
; S32 TW005 Personaje Saruman
(defclass SARUMAN (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [isengard]))
    (slot influence (source composite) (default 10))
    (slot mind (source composite) (default 0))
    (slot race (source composite) (default WIZARD))
    (slot prowess (source composite) (default 6))
    (slot body (source composite) (default 9))
)


; S23 TW008 Personaje Annalena
(defclass ANNALENA (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [edhellond]))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 3))
    (slot race (source composite) (default ELF))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 3))
    (slot body (source composite) (default 8))
)


; S36 TW013 Personaje Bardo el Arquero
(defclass BARD-BOWMAN (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [lake--town]))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 2))
    (slot race (source composite) (default MAN))
    (slot mp (source composite) (default 0))
    (slot prowess (source composite) (default 3))
    (slot body (source composite) (default 6))
)


; S42 TW024 Personaje Celeborn
(defclass CELEBORN (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [lorien]))
    (slot influence (source composite) (default 1))
    (slot mind (source composite) (default 6))
    (slot race (source composite) (default ELF))
    (slot mp (source composite) (default 2))
    (slot prowess (source composite) (default 6))
    (slot body (source composite) (default 9))
)


; S51 TW032 Personaje Elrohir
(defclass ELROHIR (is-a CHARACTER)     
    (slot instance-# (source composite))
    (slot birthplace (source composite) (default [rivendell]))
    (slot influence (source composite) (default 0))
    (slot mind (source composite) (default 4))
    (slot race (source composite) (default ELF))
    (slot mp (source composite) (default 1))
    (slot prowess (source composite) (default 5))
    (slot body (source composite) (default 8))
)



; OBJETOS GANDALF
; G03 TW155 Objeto Escudo de Fresno y Hierro Forjado
(defclass SHIELD-OF-IRON--BOUND-ASH (is-a MINOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
    (slot mp (source composite) (default 0))
    (slot body (source composite) (default 1))
    (slot max-body (source composite) (default 8))
)


; G06 TW126 Objeto Capa Ã‰lfica
; S06 TW126 Objeto Capa Ã‰lfica
(defclass ELVEN-CLOAK (is-a MINOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
    (slot mp (source composite) (default 0))
)


; G21 TW154 Objeto Pergamino de Isildur
(defclass SCROLL-OF-ISILDUR (is-a GREATER-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 3))
    (slot mp (source composite) (default 4))
)


; G27 TW130 Objeto Gran Escudo de Rohan
(defclass GREAT-SHIELD-OF-ROHAN (is-a MAJOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 2))
    (slot mp (source composite) (default 2))
    (slot body (source composite) (default 2))
    (slot max-body (source composite) (default 9))
)


; G41 TW129 Objeto Glamdring
(defclass GLAMDRING (is-a MAJOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
    (slot mp (source composite) (default 2))
    (slot prowess (source composite) (default 3))
    (slot max-prowess (source composite) (default 8))
)



; OBJETOS SARUMAN
; S03 TW115 Objeto Daga de Oesternese
(defclass DAGGER-OF-WESTERNESSE (is-a MINOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
    (slot mp (source composite) (default 0))
    (slot prowess (source composite) (default 1))
    (slot max-prowess (source composite) (default 8))
)


; S07 TW131 Objeto JubÃ³n de Mallas Brillantes
(defclass HAUBERK-OF-BRIGHT-MAIL (is-a MAJOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 1))
    (slot mp (source composite) (default 2))
)


; S20 TW142 Objeto Orcrist
(defclass ORCRIST (is-a GREATER-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 2))
    (slot mp (source composite) (default 4))
    (slot prowess (source composite) (default 3))
    (slot max-prowess (source composite) (default 9))
)


; S44 TW158 Objeto Espada de Gondolin
(defclass SWORD-OF-GONDOLIN (is-a MAJOR-ITEM)
    (slot instance-# (source composite))
    (slot corruption (source composite) (default 2))
    (slot mp (source composite) (default 4))
)


; RECURSOS DE GANDALF
; G07 TW176 Recurso de Suceso Esquiva
; G23 TW176 Recurso de Suceso Esquiva
; G39 TW176 Recurso de Suceso Esquiva
(defclass DODGE (is-a R-SHORT-EVENT)
    (slot instance-# (source composite))
)


; G09 TW204 Recurso de Suceso Golpe Afortunado
; G24 TW204 Recurso de Suceso Golpe Afortunado
; G40 TW204 Recurso de Suceso Golpe Afortunado
(defclass LUCKY-STRIKE (is-a R-SHORT-EVENT) 
    (slot instance-# (source composite))
)


; G10 TW232 Recurso de Suceso Fiel Amistad
; S45 TW232 Recurso de Suceso Fiel Amistad
(defclass TEMPERING-FRIENDSHIP (is-a R-SHORT-EVENT) 
    (slot instance-# (source composite))
)


; G11 TW173 Recurso de Suceso Ocultamiento
; G33 TW173 Recurso de Suceso Ocultamiento
; S49 TW173 Recurso de Suceso Ocultamiento
; S55 TW173 Recurso de Suceso Ocultamiento
(defclass CONCEALMENT (is-a R-SHORT-EVENT) 
    (slot instance-# (source composite))
)


; G51 TW197 Recurso de Suceso Fuerza de los Medianos
; G56 TW196 Recurso de Suceso Sigilo de los Medianos
; G20 TW197 Recurso de Suceso Fuerza de los Medianos
; S22 TW196 Recurso de Suceso Sigilo de los Medianos
; S35 TW197 Recurso de Suceso Fuerza de los Medianos
; S47 TW197 Recurso de Suceso Fuerza de los Medianos
(defclass HALFLING-STRENGTH (is-a R-SHORT-EVENT) 
    (slot instance-# (source composite))
)


; G29 TW180 Recurso de Suceso Huida
; G35 TW180 Recurso de Suceso Huida
; S16 TW180 Recurso de Suceso Huida
(defclass ESCAPE (is-a R-SHORT-EVENT) 
    (slot instance-# (source composite))
)


; G50 TW191 Recurso de Suceso Vado
; S60 TW191 Recurso de Suceso Vado
(defclass FORD (is-a R-SHORT-EVENT) 
    (slot instance-# (source composite))
)


; G55 TW171 Recurso de Suceso Puente
; S56 TW171 Recurso de Suceso Puente
(defclass BRIDGE (is-a R-SHORT-EVENT)
    (slot instance-# (source composite))
)


; G59 TW210 Recurso de Suceso Acantonamiento
; S58 TW210 Recurso de Suceso Acantonamiento
(defclass MUSTER (is-a R-SHORT-EVENT)
    (slot instance-# (source composite))
)



; RECURSOS DE SARUMAN
; S08 TW170 Recurso de Suceso Bloqueo
; S17 TW170 Recurso de Suceso Bloqueo
; S43 TW170 Recurso de Suceso Bloqueo
(defclass BLOCK (is-a R-SHORT-EVENT)
    (slot instance-# (source composite))
)


; S09 TW224 Recurso de Suceso Golpe Arriesgado
; S25 TW224 Recurso de Suceso Golpe Arriesgado
; S39 TW224 Recurso de Suceso Golpe Arriesgado
(defclass RISKY-BLOW (is-a R-SHORT-EVENT)
    (slot instance-# (source composite))
)


; S18 TW175 Recurso de Suceso Discusiones Oscuras
(defclass DARK-QUARRELS (is-a R-SHORT-EVENT)
    (slot instance-# (source composite))
)



; ALIADOS DE GANDALF
; G31 TW077 Aliado Ramaviva
(defclass QUICKBEAM (is-a ALLY)
    (slot instance-# (source composite))
    (multislot playable-places (source composite) (default [wellinghall]))
    (slot mp (source composite) (default 2))
)



; ALIADOS DE SARUMAN
; S33 TW074 Aliado Gollum
(defclass GOLLUM (is-a ALLY)
    (slot instance-# (source composite))
    (multislot playable-places (source composite) (default (create$ [goblin--gate] [moria])))
    (slot mp (source composite) (default 2))
)




; FACCIONES DE GANDALF
; G08 TW102 FacciÃ³n Montaraces del Norte
(defclass RANGERS-OF-THE-NORTH (is-a FACTION)
    (slot race (source composite) (default DUNEDAIN))
    (slot instance-# (source composite))
    (multislot playable-places (source composite) (default (create$ [bree])))
    (slot influence-check (source composite) (default 9))
    (multislot influence-modifiers (source composite) (default DUNEDAIN 1))
    (slot mp (source composite) (default 3))
)


; G43 TW103 FacciÃ³n Jinetes de Rohan
(defclass RIDERS-OF-ROHAN (is-a FACTION)(slot instance-# (source composite))
    (slot race (source composite) (default MAN))
    (multislot playable-places (source composite) (default (create$ [edoras])))
    (slot influence-check (source composite) (default 9))
    (multislot influence-modifiers (source composite) (default HOBBIT 1 DUNEDAIN 1))
    (slot mp (source composite) (default 3))
)


; G53 TW106 FacciÃ³n Torre de Guardia de Minas Tirith
(defclass TOWER-GUARD-OF-MINAS-TIRITH (is-a FACTION)(slot instance-# (source composite))
    (slot race (source composite) (default DUNEDAIN))
    (multislot playable-places (source composite) (default (create$ [minas-tirith])))
    (slot influence-check (source composite) (default 7))
    (multislot influence-modifiers (source composite) (default DUNEDAIN 1))
    (slot mp (source composite) (default 2))
)



; FACCIONES DE SARUMAN
; S15 TW086 FacciÃ³n Dundelinos
(defclass DUNLENDINGS (is-a FACTION)
    (slot race (source composite) (default MAN))
    (slot instance-# (source composite))
    (multislot playable-places (source composite) (default (create$ [dunnish-clan--hold])))
    (slot influence-check (source composite) (default 9))
    (multislot influence-modifiers (source composite) (default MAN -1 DUNEDAIN -1 DWARF -1))
    (slot mp (source composite) (default 2))
)


; S27 TW108 FacciÃ³n Elfos del Bosque
(defclass WOOD--ELVES (is-a FACTION)
    (slot race (source composite) (default ELF))
    (slot instance-# (source composite))
    (multislot playable-places (source composite) (default (create$ [thranduils-halls])))
    (slot influence-check (source composite) (default 8))
    (multislot influence-modifiers (source composite) (default MAN -1 ELF 1 DWARF -2))
    (slot mp (source composite) (default 3))
)


; S53 TW089 FacciÃ³n Ents de Fangorn
(defclass ENTS-OF-FANGORN (is-a FACTION)
    (slot race (source composite) (default ENT))
    (slot instance-# (source composite))
    (multislot playable-places (source composite) (default (create$ [wellinghall])))
    (slot influence-check (source composite) (default 9))
    (multislot influence-modifiers (source composite) (default HOBBIT 4))
    (slot mp (source composite) (default 3))
)



; ADVERSIDADES DE GANDALF
; G12 TW258 Adversidad Criatura Berto (BÃ»rat)
(defclass BERT-BURAT (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default TROLL))
    (slot regions (source composite) (default (create$ WILDERNESS 1 SHADOW-LAND 1))) 
    (multislot places (source composite) (default SHADOW-HOLD)) 
    (slot prowess (source composite) (default 12))   
    (slot mp (source composite) (default 1))
)


; G13 TW284 Adversidad Criatura Incursores Orcos
; G42 TW284 Adversidad Criatura Incursores Orcos
; G52 TW284 Adversidad Criatura Incursores Orcos
(defclass ORC--RAIDERS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default ORC))   
    (slot regions (source composite) (default BORDER-LAND 1 WILDERNESS 1)) 
    (slot prowess (source composite) (default 6)) 
    (slot strikes (source composite) (default 4)) 
    (multislot places (source composite) (default RUINS)) 
    (slot mp (source composite) (default 1))
)


; G14 TW281 Adversidad Criatura Guardia de Orcos
; G30 TW281 Adversidad Criatura Guardia de Orcos
; G45 TW281 Adversidad Criatura Guardia de Orcos
(defclass ORC--GUARD (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default ORC))   
    (slot regions (source composite) (default SHADOW-LAND 1 DARK-LAND 1)) 
    (slot prowess (source composite) (default 8)) 
    (slot strikes (source composite) (default 5)) 
    (multislot places (source composite) (default SHADOW-HOLD DARK-HOLD)) 
    (slot mp (source composite) (default 1))
)


; G15 TW286 Adversidad Criatura Guerreros Orcos
; G34 TW286 Adversidad Criatura Guerreros Orcos
; G54 TW286 Adversidad Criatura Guerreros Orcos
(defclass ORC--WARRIORS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default ORC))   
    (slot regions (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1))) 
    (slot prowess (source composite) (default 7))   
    (slot strikes (source composite) (default 3)) 
    (multislot places (source composite) (default RUINS))    
    (slot mp (source composite) (default 1))
)


; G18 TW259 Adversidad Criatura Forajidos
; G32 TW259 Adversidad Criatura Forajidos
; G49 TW259 Adversidad Criatura Forajidos
(defclass BRIGANDS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default MAN))   
    (slot regions (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1))) 
    (slot prowess (source composite) (default 8))   
    (slot strikes (source composite) (default 2))    
    (slot mp (source composite) (default 1))
)


; G28 TW302 Adversidad Criatura Guille (WÃ»luag)
(defclass WILLIAM-WULUAG (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default TROLL))
    (slot regions (source composite) (default (create$ WILDERNESS 1 SHADOW-LAND 1 DARK-LAND 1))) 
    (multislot places (source composite) (default SHADOW-HOLD DARK-HOLD)) 
    (slot prowess (source composite) (default 11))   
    (slot mp (source composite) (default 1))
)


; G47 TW287 Adversidad Criatura Centinelas Orcos
; G57 TW287 Adversidad Criatura Centinelas Orcos
; G60 TW287 Adversidad Criatura Centinelas Orcos
(defclass ORC--WATCH (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default ORC))   
    (slot regions (source composite) (default SHADOW-LAND 1 DARK-LAND 1)) 
    (slot prowess (source composite) (default 9)) 
    (slot strikes (source composite) (default 3)) 
    (multislot places (source composite) (default SHADOW-HOLD DARK-HOLD)) 
    (slot mp (source composite) (default 1))
)


; G16 TW306 Adversidad de Suceso Perturbar a los Lacayos
; G37 TW306 Adversidad de Suceso Perturbar a los Lacayos
; G58 TW306 Adversidad de Suceso Perturbar a los Lacayos
; S14 TW306 Adversidad de Suceso Perturbar a los Lacayos
; S37 TW306 Adversidad de Suceso Perturbar a los Lacayos
; S59 TW306 Adversidad de Suceso Perturbar a los Lacayos
(defclass AROUSE-MINIONS (is-a A-SHORT-EVENT) 
    (slot instance-# (source composite))
)


; G19 TW346 Adversidad de Suceso RÃ­o
; G48 TW346 Adversidad de Suceso RÃ­o
; S41 TW346 Adversidad de Suceso RÃ­o
; S48 TW346 Adversidad de Suceso RÃ­o
(defclass RIVER (is-a A-SHORT-EVENT)
    (slot instance-# (source composite))
)


; G36 TW338 Adversidad de Suceso Los Sirvientes se Agitan
; G46 TW338 Adversidad de Suceso Los Sirvientes se Agitan
(defclass MINIONS-STIR (is-a A-LONG-EVENT) 
    (slot instance-# (source composite))
)



; ADVERSIDADES DE SARUMAN
; S10 TW300 Adversidad Criatura Huargos
; S12 TW300 Adversidad Criatura Huargos
; S30 TW300 Adversidad Criatura Huargos
(defclass WARGS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default WOLF)) 
    (slot regions (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1 SHADOW-LAND 1))) 
    (slot prowess (source composite) (default 9))   
    (slot strikes (source composite) (default 2))      
    (slot mp (source composite) (default 1))
)


; S11 TW304 Adversidad Criatura Lobos
; S26 TW304 Adversidad Criatura Lobos
; S28 TW304 Adversidad Criatura Lobos
(defclass WOLVES (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default WOLF)) 
    (slot regions (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1))) 
    (slot prowess (source composite) (default 8))   
    (slot strikes (source composite) (default 3))    
    (slot mp (source composite) (default 1))  
)


; S13 TW267 Adversidad Criatura Fantasmas
; S50 TW267 Adversidad Criatura Fantasmas
(defclass GHOSTS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default UNDEAD)) 
    (slot regions (source composite) (default (create$ DARK-LAND 1 SHADOW-LAND 1))) 
    (slot prowess (source composite) (default 9))   
    (slot strikes (source composite) (default 3))      
    (multislot places (source composite) (default SHADOW-HOLD DARK-HOLD))   
    (slot mp (source composite) (default 1)) 
)


; S20 TD095 Adversidad Criatura AraÃ±as Menores
; S31 TD095 Adversidad Criatura AraÃ±as Menores
; S46 TD095 Adversidad Criatura AraÃ±as Menores
(defclass LESSER-SPIDERS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default SPIDER)) 
    (slot regions (source composite) (default (create$ WILDERNESS 1 SHADOW-LAND 1))) 
    (slot prowess (source composite) (default 7))   
    (slot strikes (source composite) (default 4))      
    (multislot places (source composite) (default RUINS))    
    (slot mp (source composite) (default 1))
)


; S21 TW268 Adversidad Criatura NecrÃ³fagos
; S57 TW268 Adversidad Criatura NecrÃ³fagos
(defclass GHOULS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default UNDEAD)) 
    (slot regions (source composite) (default (create$ SHADOW-LAND 1 DARK-LAND 1))) 
    (slot prowess (source composite) (default 7))   
    (slot strikes (source composite) (default 5))      
    (multislot places (source composite) (default SHADOW-HOLD DARK-HOLD))    
    (slot mp (source composite) (default 1))
)


; S24 TW273 Adversidad Criatura Ucorno
; S38 TW273 Adversidad Criatura Ucorno
(defclass HUORN (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default AWAKENED-PLANT)) 
    (slot regions (source composite) (default (create$ WILDERNESS 1))) 
    (slot prowess (source composite) (default 10))   
    (slot strikes (source composite) (default 1))      
    (slot mp (source composite) (default 1))
)


; S34 TW257 Adversidad Criatura Tumulario
; S52 TW257 Adversidad Criatura Tumulario
(defclass BARROW-WIGHTS (is-a CREATURE) 
    (slot instance-# (source composite))
    (slot race (source composite) (default UNDEAD)) 
    (slot regions (source composite) (default (create$ SHADOW-LAND 1 DARK-LAND 1))) 
    (slot prowess (source composite) (default 12))   
    (slot strikes (source composite) (default 1))      
    (multislot places (source composite) (default SHADOW-HOLD DARK-HOLD))    
    (slot mp (source composite) (default 1))
)


; S29 TW361 Adversidad de Suceso Alba de Guerra
; S54 TW361 Adversidad de Suceso Alba de Guerra
(defclass WAKE-OF-WAR (is-a A-LONG-EVENT)
    (slot instance-# (source composite))
)