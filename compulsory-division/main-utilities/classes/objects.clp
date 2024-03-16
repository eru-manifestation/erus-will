; INTERFACES (intentar que no tengan dependencias)
(defclass MAIN::OWNABLE (is-a USER)
	(slot player (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only) 
		(allowed-instance-names [player1] [player2]))
)

(defclass MAIN::STATABLE (is-a USER)
	(slot state (visibility public) (type SYMBOL) (default UNTAPPED) (allowed-symbols UNTAPPED TAPPED))
)

(defclass MAIN::WOUNDABLE (is-a USER)
	(slot state (visibility public) (type SYMBOL) (default UNTAPPED) (allowed-symbols UNTAPPED TAPPED WOUNDED))
)

(defclass MAIN::CORRUPTION (is-a USER)
	(slot corruption (visibility public) (type INTEGER) (default 0) (access read-only))
)

(defclass MAIN::BASIC (is-a USER)
	(slot position (visibility public) (access read-write) (default ?DERIVE) (type INSTANCE-NAME) (allowed-classes POSITIONABLE))
    (slot instance-# (visibility public) (type INTEGER) (default 2) (storage shared) (pattern-match non-reactive))
)

(defclass MAIN::ATTACKABLE (is-a BASIC)
	; Los attackable son aquellos que pueden atacar, son las características mínimas para la fase de ataque. Son tanto
	; ataques automáticos como criaturas
	(slot race (visibility public) (type SYMBOL) (default ?NONE) (access initialize-only) 
		(allowed-symbols ANIMAL SPIDER AWAKENED-PLANT PUKEL-CREATURE DRAGON SLAYER GIANT MAN WOLF UNDEAD ORC TROLL NAZGUL))
	(slot prowess (visibility public) (type INTEGER) (default ?NONE) (access read-write) (range 1 ?VARIABLE))
	(slot body (visibility public) (type ?VARIABLE) (default nil) (access read-write) (range 1 ?VARIABLE))
	(slot strikes (visibility public) (type INTEGER) (default 1) (access read-write))
)

(defclass MAIN::MP-ABLE (is-a USER)
	(slot mp (visibility public) (type INTEGER) (default 0))
)

; CLASES ABSTRACTAS
(defclass MAIN::PLAYER (is-a BASIC)
    (slot instance-# (source composite))
	(slot general-influence (visibility public) (type INTEGER) (default 20))
	(slot hand (visibility public) (type INTEGER) (default 0))
	(slot mp (visibility public) (type INTEGER) (default 0))
)

(defclass MAIN::FELLOWSHIP (is-a OWNABLE BASIC)
    (slot instance-# (source composite))
	(slot empty (visibility public) (type SYMBOL) (default TRUE) (allowed-symbols TRUE FALSE))
	(slot companions (visibility public) (type FLOAT) (default 0.0) (access read-write))
)

(defclass MAIN::STACK (is-a OWNABLE BASIC))

(defclass MAIN::data-item (is-a BASIC)
    (slot instance-# (source composite))
    (slot active (visibility public) (type SYMBOL) (default TRUE) (allowed-symbols TRUE FALSE))
    (slot target (visibility public) (type SYMBOL) (default ?NONE))
    (slot target-slot (visibility public) (type SYMBOL) (default ?NONE))
    (slot value (visibility public) (type INTEGER) (default ?NONE))
	(multislot motive (visibility public))
)

; CLASES CONCRETAS
(defclass MAIN::CARD (is-a STATABLE BASIC))

(defclass MAIN::RESOURCE (is-a OWNABLE CARD))
(defclass MAIN::ADVERSITY (is-a OWNABLE CARD))

(defclass MAIN::LOCATION (is-a CARD)
	(slot closest-haven (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
	(slot player-draw (visibility public) (type INTEGER) (default ?NONE) (access initialize-only) (range 0 ?VARIABLE))
	(slot enemy-draw (visibility public) (type INTEGER) (default ?NONE) (access initialize-only) (range 0 ?VARIABLE))
	(multislot route (visibility public) (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 COAST FREE-LAND BORDER-LAND WILDERNESS SHADOW-LAND DARK-LAND))
	(slot place (visibility public) (type SYMBOL) (default ?NONE) (access initialize-only) 
		(allowed-symbols FREE-HOLD BORDER-HOLD RUINS SHADOW-HOLD DARK-HOLD HAVEN))
	(multislot automatic-attacks (visibility public) (type INSTANCE-NAME) (default (create$)))
	(multislot playable-items (visibility public) (type SYMBOL) (default (create$)) (access read-only) (allowed-symbols MINOR-ITEM GREATER-ITEM MAJOR-ITEM GOLD-RING))
)

(defclass MAIN::HAVEN (is-a LOCATION)
	(slot site-pathA (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
	;(slot site-pathB (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
	(multislot routeA (visibility public) (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 COAST FREE-LAND BORDER-LAND WILDERNESS SHADOW-LAND DARK-LAND))
	; (multislot routeB (visibility public) (type ?VARIABLE) (default ?NONE) (access initialize-only) 
	; 	(allowed-values 1 2 3 4 5 6 7 8 9 COAST FREE-LAND BORDER-LAND WILDERNESS SHADOW-LAND DARK-LAND))
	(slot player-draw (source composite) (default 2))
	(slot enemy-draw (source composite) (default 2))
	(slot place (source composite) (default HAVEN))
	; SE INUTILIZA ROUTE ENTRE REFUGIOS
	(multislot route (visibility public) (type ?VARIABLE) (default nil) (access read-only))
)

(defclass MAIN::CHARACTER (is-a ATTACKABLE MP-ABLE WOUNDABLE OWNABLE CARD)
	(slot birthplace (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
	(slot influence (visibility public) (type INTEGER) (default 0) (access read-write))
	(slot mind (visibility public) (type INTEGER) (default 0) (access read-write))
	(slot race (visibility public) (type SYMBOL) (default ?NONE) (access initialize-only) 
		(allowed-symbols DUNEDAIN ELF DWARF HOBBIT MAN WIZARD))
	(slot corruption (visibility public) (type INTEGER) (default 0) (access read-write))
)

(defclass MAIN::ALLY (is-a MP-ABLE WOUNDABLE RESOURCE)
	(multislot playable-places (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
)

(defclass MAIN::R-PERMANENT-EVENT (is-a RESOURCE))
(defclass MAIN::A-PERMANENT-EVENT (is-a ADVERSITY))

(defclass MAIN::R-LONG-EVENT (is-a RESOURCE))
(defclass MAIN::A-LONG-EVENT (is-a ADVERSITY))

(defclass MAIN::R-SHORT-EVENT (is-a RESOURCE))
(defclass MAIN::A-SHORT-EVENT (is-a ADVERSITY))

(defclass MAIN::FACTION(is-a MP-ABLE RESOURCE)
	(multislot playable-places (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
	(slot influence-check (visibility public) (type INTEGER) (default ?NONE) (access initialize-only))
	(multislot influence-modifiers (visibility public) (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 -1 -2 -3 -4 -5 -6 -7 -8 -9 DUNEDAIN ELF DWARF HOBBIT MAN WIZARD))
)
(defclass MAIN::CREATURE(is-a MP-ABLE ADVERSITY ATTACKABLE)
	(multislot regions (visibility public) (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 COAST FREE-LAND BORDER-LAND WILDERNESS SHADOW-LAND DARK-LAND))
	(multislot places (visibility public) (type SYMBOL) (default (create$)) (access initialize-only) 
		(allowed-symbols FREE-HOLD BORDER-HOLD RUINS SHADOW-HOLD DARK-HOLD HAVEN))
)

(defclass MAIN::ITEM(is-a MP-ABLE RESOURCE CORRUPTION)
	(slot prowess (visibility public) (type INTEGER) (default 0) (access read-write) (range 0 ?VARIABLE))
	(slot body (visibility public) (type INTEGER) (default 0) (access read-write) (range 0 ?VARIABLE))
	(slot max-prowess (visibility public) (type INTEGER) (default 0) (access read-write) (range 0 ?VARIABLE))
	(slot max-body (visibility public) (type INTEGER) (default 0) (access read-write) (range 0 ?VARIABLE))
)

(defclass MAIN::MINOR-ITEM(is-a ITEM))
(defclass MAIN::GREATER-ITEM(is-a ITEM))
(defclass MAIN::MAJOR-ITEM(is-a ITEM))
(defclass MAIN::SPECIAL-ITEM(is-a ITEM))
(defclass MAIN::GOLD-RING(is-a ITEM))

(deffunction MAIN::enemy (?player)
	(if (eq ?player [player1]) then
		[player2]
		else
		[player1]
	)
)
