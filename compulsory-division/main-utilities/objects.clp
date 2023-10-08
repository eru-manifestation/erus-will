; INTERFACES (intentar que no tengan dependencias)
(defclass MAIN::OWNABLE (is-a USER)
	(slot player (type INSTANCE-NAME) (default ?NONE) (access initialize-only) 
		(allowed-instance-names [player1] [player2]))
)

(defclass MAIN::STATABLE (is-a USER)
	(slot state (type SYMBOL) (default DRAW) (allowed-symbols DRAW HAND MP DISCARD OUT-OF-GAME UNTAPPED TAPPED))
)

(defclass MAIN::WOUNDABLE (is-a USER)
	(slot state (type SYMBOL) (default DRAW) (allowed-symbols DRAW HAND MP DISCARD OUT-OF-GAME UNTAPPED TAPPED WOUNDED))
)

(defclass MAIN::CORRUPTION (is-a USER)
	(slot corruption (type INTEGER) (default 0) (access read-only))
)

(defclass MAIN::NUMERABLE (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
)

(defclass MAIN::ATTACKABLE (is-a USER)
	(slot race (type SYMBOL) (default ?NONE) (access initialize-only) 
		(allowed-symbols ANIMAL SPIDER AWAKENED-PLANT PUKEL-CREATURE DRAGON SLAYER GIANT MAN WOLF UNDEAD ORC TROLL NAZGUL))
	(slot prowess (type INTEGER) (default ?NONE) (access initialize-only) (range 1 ?VARIABLE))
	(slot strikes (type INTEGER) (default 1) (access initialize-only))
)

(defclass MAIN::MP-ABLE (is-a USER)
	(slot mp (type INTEGER) (default 0))
)

; CLASES ABSTRACTAS
(defclass MAIN::PLAYER (is-a NUMERABLE)
    (slot instance-# (source composite))
	(slot general-influence (type INTEGER) (default 20))
	(slot hand (type INTEGER) (default 0))
	(slot mp (type INTEGER) (default 0))
)

(defclass MAIN::FELLOWSHIP (is-a OWNABLE NUMERABLE)
    (slot instance-# (source composite))
	(slot empty (type SYMBOL) (default TRUE) (allowed-symbols TRUE FALSE))
	(slot companions (type INTEGER) (default 0) (access read-write))
)

; CLASES CONCRETAS
(defclass MAIN::CARD (is-a STATABLE NUMERABLE))

(defclass MAIN::RESOURCE (is-a OWNABLE CARD))
(defclass MAIN::ADVERSITY (is-a OWNABLE CARD))

(defclass MAIN::LOCATION (is-a CARD)
	(slot closest-haven (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
	(slot state (source composite) (default UNTAPPED) (allowed-symbols OUT-OF-GAME UNTAPPED TAPPED))
	(slot player-draw (type INTEGER) (default ?NONE) (access initialize-only) (range 0 ?VARIABLE))
	(slot enemy-draw (type INTEGER) (default ?NONE) (access initialize-only) (range 0 ?VARIABLE))
	(multislot route (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 COAST FREE-LAND BORDER-LAND WILDERNESS SHADOW-LAND DARK-LAND))
	(slot place (type SYMBOL) (default ?NONE) (access initialize-only) 
		(allowed-symbols FREE-HOLD BORDER-HOLD RUINS SHADOW-HOLD DARK-HOLD HAVEN))
	(multislot automatic-attacks (type INSTANCE-NAME) (default (create$)) (access initialize-only) (allowed-classes ATTACKABLE))
	(multislot playable-items (type SYMBOL) (default (create$)) (access read-only) (allowed-symbols MINOR-ITEM GREATER-ITEM MAJOR-ITEM))
)

(defclass MAIN::HAVEN (is-a LOCATION)
	(slot site-pathA (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
	(slot site-pathB (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
	(multislot routeA (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 COAST FREE-LAND BORDER-LAND WILDERNESS SHADOW-LAND DARK-LAND))
	(multislot routeB (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 COAST FREE-LAND BORDER-LAND WILDERNESS SHADOW-LAND DARK-LAND))
	(slot player-draw (source composite) (default 2))
	(slot enemy-draw (source composite) (default 2))
	(slot place (source composite) (default HAVEN))
	; SE INUTILIZA ROUTE ENTRE REFUGIOS
	(multislot route (type ?VARIABLE) (default nil) (access read-only))
)

(defclass MAIN::CHARACTER (is-a MP-ABLE WOUNDABLE OWNABLE CARD)
	(slot birthplace (type SYMBOL) (default ?NONE) (access initialize-only) (allowed-symbols TODO))
	(slot influence (type INTEGER) (default 0) (access read-write))
	(slot mind (type INTEGER) (default 0) (access read-write))
	(slot race (type SYMBOL) (default ?NONE) (access initialize-only) 
		(allowed-symbols DUNEDAIN ELF DWARF HOBBIT MAN WIZARD))
	(slot corruption (type INTEGER) (default 0) (access read-write))
)

(defclass MAIN::ALLY (is-a MP-ABLE WOUNDABLE RESOURCE);TODO poner el allowed classes de playable-places
	(multislot playable-places (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
)

(defclass MAIN::R-PERMANENT-EVENT (is-a RESOURCE))
(defclass MAIN::A-PERMANENT-EVENT (is-a ADVERSITY))

(defclass MAIN::R-LONG-EVENT (is-a RESOURCE))
(defclass MAIN::A-LONG-EVENT (is-a ADVERSITY))

(defclass MAIN::R-SHORT-EVENT (is-a RESOURCE))
(defclass MAIN::A-SHORT-EVENT (is-a ADVERSITY))

(defclass MAIN::FACTION(is-a MP-ABLE RESOURCE)
	(multislot playable-places (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
	(slot influence-check (type INTEGER) (default ?NONE) (access initialize-only))
	(multislot influence-modifiers (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 -1 -2 -3 -4 -5 -6 -7 -8 -9 DUNEDAIN ELF DWARF HOBBIT MAN WIZARD))
)
(defclass MAIN::CREATURE(is-a MP-ABLE ADVERSITY ATTACKABLE)
	(multislot regions (type ?VARIABLE) (default ?NONE) (access initialize-only) 
		(allowed-values 1 2 3 4 5 6 7 8 9 COAST FREE-LAND BORDER-LAND WILDERNESS SHADOW-LAND DARK-LAND))
	(multislot places (type SYMBOL) (default (create$)) (access initialize-only) 
		(allowed-symbols FREE-HOLD BORDER-HOLD RUINS SHADOW-HOLD DARK-HOLD HAVEN))
)

(defclass MAIN::ITEM(is-a MP-ABLE RESOURCE CORRUPTION))
(defclass MAIN::MINOR-ITEM(is-a ITEM))
(defclass MAIN::GREATER-ITEM(is-a ITEM))
(defclass MAIN::MAJOR-ITEM(is-a ITEM))
(defclass MAIN::SPECIAL-ITEM(is-a ITEM))

(deffunction MAIN::enemy (?player)
	(if (eq ?player [player1]) then
		[player2]
		else
		[player1]
	)
)
