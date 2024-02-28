; DEFINICIÓN DE TEMPLATE EVENTO
(defclass MAIN::EVENT (is-a BASIC)
    (slot instance-# (source composite))
	(slot target-phase (visibility public) (type SYMBOL))
	(slot state (visibility public) (type SYMBOL) (default IN) (allowed-symbols IN IN-HOLD EXEC EXEC-HOLD _ OUT OUT-HOLD DONE DEFUSED))
	(multislot reason (visibility public) (type SYMBOL) (default ?NONE))
)


; DEFINICION DEL EVENTO DE FASE EVENTUAL
(defclass MAIN::E-phase (is-a EVENT)
	(multislot data (visibility public) (type STRING) (default (create$)))
)


(defclass MAIN::E-modify (is-a EVENT)
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
	(slot slot (visibility public) (type SYMBOL) (default ?NONE) (access initialize-only))
	(slot old (visibility public) (type ?VARIABLE) (default TOBEDETERMINED) (access initialize-only))
	(slot new (visibility public) (type ?VARIABLE) (default ?NONE) (access initialize-only))
)