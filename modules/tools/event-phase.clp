(defclass TOOLS::EVENT-PHASE (is-a EVENT)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot priority (type INTEGER) (default ?NONE) (access initialize-only))
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
    (multislot stage)

)

(defclass TOOLS::MOVE-FELLOWSHIP-EP
    (slot fell (type INSTANCE-NAME) (allowed-class FELLOWSHIP) (default ?NONE))
    (slot from (type INSTANCE-NAME) (allowed-class LOCATION) (default ?NONE))
)