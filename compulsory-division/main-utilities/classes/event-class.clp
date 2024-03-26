(defclass MAIN::EVENT (is-a BASIC)
    (slot instance-# (source composite))
	(slot active (visibility public) (type SYMBOL) (default TRUE) (allowed-values TRUE FALSE))
	(slot state (visibility public) (type SYMBOL) (default IN) (allowed-symbols IN IN-HOLD EXEC EXEC-HOLD _ OUT OUT-HOLD DONE DEFUSED))
	(slot reason (visibility public) (type SYMBOL) (default ?NONE))
	(slot position (source composite) (type INSTANCE-ADDRESS INSTANCE-NAME) (default-dynamic ?*active-event*))
)


; FUNCIONES
(defclass MAIN::E-phase (is-a EVENT)
	(slot phase (visibility public) (type SYMBOL) (default ?NONE) (storage shared))
	(slot res (visibility public) (type ?VARIABLE) (default UNDEFINED))
)

(defclass MAIN::EP-turn (is-a E-phase)
	(slot phase (source composite) (default turn))
	(slot player (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-values [player1] [player2]))
	(multislot move (visibility public) (type INSTANCE-NAME))
	(multislot remain (visibility public) (type INSTANCE-NAME))
	(slot council (visibility public) (type SYMBOL) (default FALSE))
)

(defclass MAIN::EP-start-game (is-a E-phase)
	(slot phase (source composite) (default start-game)))

(defclass MAIN::EP-dices (is-a E-phase)
	(slot phase (source composite) (default dices)))

(defclass MAIN::EP-corruption-check (is-a E-phase)
	(slot phase (source composite) (default corruption-check))
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defclass MAIN::EP-combat (is-a E-phase)
	(slot phase (source composite) (default combat))
	(multislot attackables (visibility public) (type INSTANCE-NAME) (default ?NONE))
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defclass MAIN::EP-standarize-hand (is-a E-phase)
	(slot phase (source composite) (default standarize-hand))
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defclass MAIN::EP-fell-move (is-a E-phase)
	(slot phase (source composite) (default fell-move))
	(slot fellowship (visibility public) (type INSTANCE-NAME) (default ?NONE))
	(slot to (visibility public) (type INSTANCE-NAME))
	(slot hazard-limit (visibility public) (type INTEGER) (default 0))
	(slot player-draw (visibility public) (type INTEGER) (default 0))
	(slot enemy-draw (visibility public) (type INTEGER) (default 0))
	(multislot route (visibility public) (type ?VARIABLE))
)

(defclass MAIN::EP-free-council (is-a E-phase)
	(slot phase (source composite) (default free-council)))

(defclass MAIN::EP-attack (is-a E-phase)
	(slot phase (source composite) (default attack))
	(slot attackable (visibility public) (type INSTANCE-NAME) (default ?NONE))
	(slot fellowship (visibility public) (type INSTANCE-NAME) (default ?NONE))
	(multislot strikes (visibility public) (type INSTANCE-NAME))
)

(defclass MAIN::EP-draw (is-a E-phase)
	(slot phase (source composite) (default draw))
	(slot ammount (visibility public) (type INTEGER) (default ?NONE))
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defclass MAIN::EP-resistance-check (is-a E-phase)
	(slot phase (source composite) (default resistance-check))
	(slot attacker (visibility public) (type INSTANCE-NAME) (default ?NONE))
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defclass MAIN::EP-strike (is-a E-phase)
	(slot phase (source composite) (default strike))
	(slot attackable (visibility public) (type INSTANCE-NAME) (default ?NONE))
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE))
	(slot hindered (visibility public) (type SYMBOL) (default FALSE))
	(slot spare-strike (visibility public) (type SYMBOL) (default FALSE))
)

(defclass MAIN::EP-faction-play (is-a E-phase)
	(slot phase (source composite) (default faction-play))
	(slot faction (visibility public) (type INSTANCE-NAME) (default ?NONE))
	(slot character (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defclass MAIN::EP-loc-phase (is-a E-phase)
	(slot phase (source composite) (default loc-phase))
	(slot fellowship (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defclass MAIN::EP-ring (is-a E-phase)
	(slot phase (source composite) (default ring))
	(slot ring (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defclass MAIN::EP-strike-roll (is-a EP-dices))
(defclass MAIN::EP-resistance-roll (is-a EP-dices))
(defclass MAIN::EP-corruption-roll (is-a EP-dices))
(defclass MAIN::EP-ring-test-roll (is-a EP-dices))
(defclass MAIN::EP-faction-influence-roll (is-a EP-dices))


; ASIGNADORES
(defclass MAIN::E-modify (is-a EVENT)
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
	(slot slot (visibility public) (type SYMBOL) (default ?NONE) (access initialize-only))
	(multislot old (visibility public) (type ?VARIABLE) (default TOBEDETERMINED) (access initialize-only))
	(multislot new (visibility public) (type ?VARIABLE) (default ?NONE) (access initialize-only))
)


(defclass MAIN::E-play (is-a E-modify))

(defclass MAIN::E-play-by-region (is-a E-play)
	(slot region (visibility public) (type SYMBOL) (default ?NONE) (access initialize-only))
)

(defclass MAIN::E-play-by-place (is-a E-play)
	(slot place (visibility public) (type SYMBOL) (default ?NONE) (access initialize-only))
)

(defclass MAIN::E-discard (is-a E-modify))