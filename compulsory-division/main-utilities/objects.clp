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
	(slot corruption (type INTEGER) (default 0) (access initialize-only) (create-accessor ?NONE))
)

; CLASES ABSTRACTAS
(defclass MAIN::PLAYER (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
	(slot general-influence (type INTEGER) (default 20) (access initialize-only))
)

(defclass MAIN::FELLOWSHIP (is-a OWNABLE)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
	(slot empty (type SYMBOL) (default TRUE) (allowed-symbols TRUE FALSE))
)

; CLASES CONCRETAS
(defclass MAIN::CARD (is-a STATABLE))

(defclass MAIN::RESOURCE (is-a OWNABLE CARD)
)
(defclass MAIN::ADVERSITY (is-a OWNABLE CARD)
)

(defclass MAIN::LOCATION (is-a CARD)
	(slot closest-haven (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
	(slot is-haven (type SYMBOL) (default FALSE) (access initialize-only) (allowed-symbols TRUE FALSE))
	(slot state (default UNTAPPED))
)

(defclass MAIN::HAVEN (is-a LOCATION)
	(multislot site-paths (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
    (slot is-haven (default TRUE))
)

(defclass MAIN::CHARACTER (is-a WOUNDABLE OWNABLE CARD)
	(slot birthplace (type SYMBOL) (default ?NONE) (access initialize-only) (allowed-symbols TODO))
	(slot influence (type INTEGER) (default 0) (access initialize-only))
	(slot mind (type INTEGER) (default 0) (access initialize-only))
	(slot race (type SYMBOL) (default ?NONE) (access initialize-only) (allowed-symbols TODO))
	(slot corruption (type INTEGER) (default 0) (access initialize-only) (create-accessor ?NONE))
)

(defclass MAIN::ALLY (is-a WOUNDABLE RESOURCE)
)

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
