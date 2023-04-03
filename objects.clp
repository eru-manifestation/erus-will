; *** DEFINICIÓN ELEMENTOS PRIMARIOS (I) ***
; Solo deben estar aquí aquellos elementos que necesariamente deben ir al principio para ser referenciados
; cuanto antes mejor

(defclass PLAYER (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
)

(defclass ELEMENT-HOLDER (is-a USER)
	(role abstract) (pattern-match non-reactive)
	(multislot cards (type INSTANCE-NAME) (allowed-classes CARD))
)

(defclass OWNABLE (is-a USER)
	(role abstract) (pattern-match non-reactive)
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE) (access initialize-only))
)

(defclass DECK (is-a ELEMENT-HOLDER OWNABLE)
	(role concrete) (pattern-match reactive)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
)

(defclass HAND (is-a ELEMENT-HOLDER OWNABLE)
	(role concrete) (pattern-match reactive)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
)

(defclass FELLOWSHIP (is-a OWNABLE)
	(role concrete) (pattern-match reactive)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
)

;(defclass TABLE (is-a ELEMENT-HOLDER)) Por simplicidad, omitiré el elemento tablero y las localizaciones serán las raíces


; *** VARIABLES GLOBALES ***
(defglobal
	?*havens* = (create$ [l1] [l2] [l3] [l4]) 
)

; *** DEFINICIÓN DE CLASES ***
(defclass TAPPABLE (is-a ELEMENT-HOLDER)
	(role abstract) (pattern-match non-reactive)
	(slot tap (type SYMBOL) (default UNTAPPED) (allowed-symbols UNTAPPED TAPPED))
	(slot card-name (type STRING) (default ?NONE) (access initialize-only))
)

(defclass CARD (is-a TAPPABLE OWNABLE)
	(role abstract) (pattern-match non-reactive)
	(slot unique (type SYMBOL) (default FALSE) (allowed-symbols TRUE FALSE) (access initialize-only))
	(slot marshalling-points (type INTEGER) (default 0) (range 0 ?VARIABLE) (access initialize-only))
)

(defclass LOCATION (is-a TAPPABLE)
	(role concrete) (pattern-match reactive)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
	; *** CARACTERÍSTICAS PROPIAS ***
	; COMPLETAR
	(slot location-type (type SYMBOL) (default ?NONE) (access initialize-only) (allowed-values HAVEN WILDS FREE-LANDS))
	(slot closest-haven (type INSTANCE-NAME) (access initialize-only) (allowed-instance-names [l1] [l2] [l3] [l4]))
	(slot ally-draws (type INTEGER) (default ?NONE) (access initialize-only) (range 0 ?VARIABLE))
	(slot enemy-draws (type INTEGER) (default ?NONE) (access initialize-only) (range 0 ?VARIABLE))
	(slot region (type SYMBOL) (default ?NONE) (access initialize-only))
	(multislot playable (type SYMBOL) (default (create$)) (access initialize-only))
	(slot automatic-attack-strikes (default FALSE) (access initialize-only))
	(slot automatic-attack-prowess (default FALSE) (access initialize-only))
	(slot automatic-attack-enemy (default FALSE) (access initialize-only))
)

(defmessage-handler LOCATION is-haven ()
	(member$ ?self ?*havens*)
)

(defglobal
	?*locations* = 
		(create$ 
			(make-instance l5 of LOCATION
				(card-name "Bolsón Cerrado")
				(location-type FREE-LANDS)
				(closest-haven l1)
				(ally-draws 2)
				(enemy-draws 2)
				(region LA-COMARCA)
			)
		)
)

(defclass COMBAT-ABLE (is-a CARD)
	(role abstract) (pattern-match non-reactive)
	; *** CARACTERÍSTICAS HEREDADAS MODIFICADAS ***
	(slot tap (allowed-symbols UNTAPPED TAPPED WOUNDED))
	; *** CARACTERÍSTICAS PROPIAS ***
	(slot prowess (type INTEGER) (default ?NONE) (range 0 ?VARIABLE) (access initialize-only))
	(slot body (type INTEGER) (default ?NONE) (range 0 ?VARIABLE) (access initialize-only))
	(slot mind (type INTEGER) (default ?NONE) (range 1 ?VARIABLE) (access initialize-only))
	(slot birthplace (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
	(multislot skills (type SYMBOL) (default ?NONE) (allowed-symbols WARRIOR SCOUT RANGER SAGE DIPLOMAT) 
		(access initialize-only))
)

(defclass CHARACTER (is-a COMBAT-ABLE)
	(role concrete) (pattern-match reactive)
	; *** CARACTERÍSTICAS PROPIAS ***
	(slot influence (type INTEGER) (default 0) (range 0 ?VARIABLE) (access initialize-only))
	(slot race (type SYMBOL) (default ?NONE) (allowed-symbols ELF HOBBIT DWARF DUNEDAN MAN WIZARD) 
		(access initialize-only))
	(slot corruption-modifier (type INTEGER) (default 0))
)

(defclass ALLY (is-a COMBAT-ABLE)
	(role concrete) (pattern-match reactive)
	; *** CARACTERÍSTICAS PROPIAS ***
	
)

(defclass R-PERMANENT-EVENT (is-a CARD)(role concrete) (pattern-match reactive))
(defclass A-PERMANENT-EVENT (is-a CARD)(role concrete) (pattern-match reactive))
(defclass R-LONG-EVENT (is-a CARD)(role concrete) (pattern-match reactive))
(defclass A-LONG-EVENT (is-a CARD)(role concrete) (pattern-match reactive))
(defclass R-SHORT-EVENT (is-a CARD)(role concrete) (pattern-match reactive))
(defclass A-SHORT-EVENT (is-a CARD)(role concrete) (pattern-match reactive))

; *** DEFINICIÓN DE PLANTILLAS ***

; TODO: USARLO?
(deftemplate path
	; Representan la conexión entre dos localizaciones
	(slot haven (type INSTANCE-NAME) (default ?NONE) (allowed-instance-names [l1] [l2] [l3] [l4]))
	(slot location (type INSTANCE-NAME) (default ?NONE))
	; COMPLETAR
	(multislot regions-between (type SYMBOL) (allowed-values WILD-LANDS))
)

;TODO: UNUSED YET
(deftemplate attack
	(slot strikes (type INTEGER) (default ?NONE))
	(slot prowess (type INTEGER) (default ?NONE) (range 1 ?VARIABLE))
	(slot enemy (type SYMBOL) (allowed-symbols ORCS DRAGON MEN)) ; COMPLETAAAAR
)

; *** DEFINICIÓN DE FUNCIONES ***
(deffunction is-haven (?location)
	(member$ ?location ?*havens*)
)

(deffunction enemy (?player)
	(if (eq ?player [player1]) then
		[player2]
		else
		[player1]
	)
)

;(defrule secarga => (println secarga))
