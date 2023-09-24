(defclass MAIN::PLAYER (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
	(slot general-influence (type INTEGER) (default 20) (access initialize-only))
)

(defclass MAIN::FELLOWSHIP (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
	(slot player (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [player1] [player2]))
	(slot empty (type SYMBOL) (default TRUE) (allowed-symbols TRUE FALSE))
)

; *** DEFINICIÓN DE CLASES ***
(defclass MAIN::CARD (is-a USER)
	(slot state (type SYMBOL) (default UNTAPPED) (allowed-symbols DRAW HAND MP DISCARD UNTAPPED TAPPED))
)

(defclass MAIN::RESOURCE (is-a CARD)
	(slot player (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [player1] [player2]))
)
(defclass MAIN::ADVERSITY (is-a CARD)
	(slot player (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [player1] [player2]))
)

(defclass MAIN::LOCATION (is-a CARD)
	(slot closest-haven (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [rivendell] [grey-havens] [edhellond] [lorien]))
	(slot is-haven (type SYMBOL) (default FALSE) (access initialize-only) (allowed-symbols TRUE FALSE))
)

(defclass MAIN::CHARACTER (is-a CARD)
	(slot birthplace (type SYMBOL) (default ?NONE) (access initialize-only) (allowed-symbols TODO))
	(slot influence (type INTEGER) (default 0) (access initialize-only))
	(slot mind (type INTEGER) (default 0) (access initialize-only))
	(slot player (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [player1] [player2]))
	(slot race (type SYMBOL) (default ?NONE) (access initialize-only) (allowed-symbols TODO))
	(slot state (type SYMBOL) (default UNTAPPED) (allowed-symbols DRAW HAND MP DISCARD UNTAPPED TAPPED WOUNDED))
)

(defclass MAIN::ALLY (is-a RESOURCE)
	(slot state (type SYMBOL) (default UNTAPPED) (allowed-symbols DRAW HAND MP DISCARD UNTAPPED TAPPED WOUNDED))
)

(defclass MAIN::R-PERMANENT-EVENT (is-a RESOURCE))
(defclass MAIN::A-PERMANENT-EVENT (is-a ADVERSITY))

(defclass MAIN::R-LONG-EVENT (is-a RESOURCE)
	(slot player (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [player1] [player2]))
)

(defclass MAIN::A-LONG-EVENT (is-a ADVERSITY)
	(slot player (type INSTANCE-NAME) (default ?NONE) (access initialize-only) (allowed-instance-names [player1] [player2]))
)

(defclass MAIN::R-SHORT-EVENT (is-a RESOURCE))
(defclass MAIN::A-SHORT-EVENT (is-a ADVERSITY))

(defclass MAIN::ITEM(is-a RESOURCE))
(defclass MAIN::MINOR-ITEM(is-a ITEM))
(defclass MAIN::GREATER-ITEM(is-a ITEM))
(defclass MAIN::MAJOR-ITEM(is-a ITEM))

(defclass MAIN::FACTION(is-a RESOURCE))
(defclass MAIN::CREATURE(is-a ADVERSITY))

(deffunction MAIN::enemy (?player)
	(if (eq ?player [player1]) then
		[player2]
		else
		[player1]
	)
)
