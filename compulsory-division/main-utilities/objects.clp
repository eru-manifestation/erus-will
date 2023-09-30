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

; CLASES ABSTRACTAS
(defclass MAIN::PLAYER (is-a NUMERABLE)
    (slot instance-# (source composite))
	(slot general-influence (type INTEGER) (default 20))
	(slot hand (type INTEGER) (default 0))
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
	(slot is-haven (type SYMBOL) (default FALSE) (access read-only) (allowed-symbols TRUE FALSE))
	(slot state (source composite) (default UNTAPPED))
)

(defclass MAIN::HAVEN (is-a LOCATION)
	(multislot site-paths (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
    (slot is-haven (source composite) (default TRUE))
)

(defclass MAIN::CHARACTER (is-a WOUNDABLE OWNABLE CARD)
	(slot birthplace (type SYMBOL) (default ?NONE) (access initialize-only) (allowed-symbols TODO))
	(slot influence (type INTEGER) (default 0) (access read-write))
	(slot mind (type INTEGER) (default 0) (access read-write))
	(slot race (type SYMBOL) (default ?NONE) (access initialize-only) (allowed-symbols TODO))
	(slot corruption (type INTEGER) (default 0) (access read-write))
)

(defclass MAIN::ALLY (is-a WOUNDABLE RESOURCE))

(defclass MAIN::R-PERMANENT-EVENT (is-a RESOURCE))
(defclass MAIN::A-PERMANENT-EVENT (is-a ADVERSITY))

(defclass MAIN::R-LONG-EVENT (is-a RESOURCE))
(defclass MAIN::A-LONG-EVENT (is-a ADVERSITY))

(defclass MAIN::R-SHORT-EVENT (is-a RESOURCE))
(defclass MAIN::A-SHORT-EVENT (is-a ADVERSITY))

(defclass MAIN::FACTION(is-a RESOURCE))
(defclass MAIN::CREATURE(is-a ADVERSITY))

(defclass MAIN::ITEM(is-a RESOURCE CORRUPTION))
(defclass MAIN::MINOR-ITEM(is-a ITEM))
(defclass MAIN::GREATER-ITEM(is-a ITEM))
(defclass MAIN::MAJOR-ITEM(is-a ITEM))

(deffunction MAIN::enemy (?player)
	(if (eq ?player [player1]) then
		[player2]
		else
		[player1]
	)
)
