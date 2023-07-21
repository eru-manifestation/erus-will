; DEFINICIÓN DE TEMPLATE EVENTO
(defclass TOOLS::EVENT (is-a USER)
    (slot instance-# (type INTEGER) (default 2) (storage shared) (visibility public))
	(slot event-definitor (type SYMBOL) (default ?NONE) (access initialize-only) (visibility public))
	(slot type (type SYMBOL) (default IN) (allowed-symbols IN OUT) (visibility public))
	; Revisar en los que capturen datos de eventos que se especifique defused FALSE
	; para evitar pattern matching innecesario
	(slot defused (type SYMBOL) (default FALSE) (allowed-symbols TRUE FALSE)
		(pattern-match non-reactive) (visibility public))
	(multislot dont-use-data (default (create$)) (pattern-match non-reactive) (create-accessor ?NONE)
        (visibility public))
)


(defclass TOOLS::EVENT-PHASE (is-a EVENT)
    (slot instance-# (type INTEGER) (default 2) (storage shared))
    (slot priority (type INTEGER) (default ?NONE) (access initialize-only))
    ; Define si está activa la fase eventual, no debe ejecutarse más o está en espera 
	(slot type (type SYMBOL) (default IN) (allowed-symbols IN OUT WAITING))
    ; Módulo que se encarga de la fase eventual
    (slot module (type SYMBOL) (default ?NONE))
	(slot player (type INSTANCE-NAME) (allowed-classes PLAYER) (default ?NONE))
    (multislot stage (default (create$ start)))

)