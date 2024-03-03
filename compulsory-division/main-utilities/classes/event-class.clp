(defclass MAIN::EVENT (is-a BASIC)
    (slot instance-# (source composite))
	(slot state (visibility public) (type SYMBOL) (default IN) (allowed-symbols IN IN-HOLD EXEC EXEC-HOLD _ OUT OUT-HOLD DONE DEFUSED))
	(multislot reason (visibility public) (type SYMBOL) (default ?NONE))
	(slot position (source composite) (type INSTANCE-ADDRESS INSTANCE-NAME) (default-dynamic ?*active-event*))
)


(defclass MAIN::E-phase (is-a EVENT)
	(multislot data (visibility public) (type ?VARIABLE) (default (create$)))
	(slot res (visibility public) (type SYMBOL) (default UNDEFINED))
)


(defclass MAIN::E-modify (is-a EVENT)
	(slot target (visibility public) (type INSTANCE-NAME) (default ?NONE) (access initialize-only))
	(slot slot (visibility public) (type SYMBOL) (default ?NONE) (access initialize-only))
	(slot old (visibility public) (type ?VARIABLE) (default TOBEDETERMINED) (access initialize-only))
	(slot new (visibility public) (type ?VARIABLE) (default ?NONE) (access initialize-only))
)


(deftemplate MAIN::data
	(slot phase (type SYMBOL) (default turn))
	(multislot data (type ?VARIABLE) (default ?NONE))
)

(deffunction MAIN::decompressData (?phase $?data)
	(if (neq (create$) ?data) then
		(while (bind ?i (member$ / ?data)) do
			(assert (data (phase ?phase) (data (subseq$ ?data 1 (- ?i 1)))))
			(bind ?data (replace$ ?data 1 ?i (create$)))
		)
		(assert (data (phase ?phase) (data ?data)))
	)
)

(deffunction MAIN::compressData (?phase)
	(bind ?res (create$))
	(do-for-fact ((?data data)) (eq ?phase ?data:phase)
		(bind ?res ?data:data)
		(retract ?data)
	)
	(delayed-do-for-all-facts ((?data data)) (eq ?phase ?data:phase)
		(bind ?res (insert$ ?res 1 ?data:data /))
		(retract ?data)
	)
	(return ?res)
)