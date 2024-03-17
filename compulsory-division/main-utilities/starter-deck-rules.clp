; ARAGORN-II: +2 influence against rangers of the north faction
; BOROMIR-II: +2 influence against men of anorien (falta MEN-OF-ANORIEN)
; FARAMIR: +2 influence against rangers of ithilien (falta RANGERS-OF-ITHILIEN)
; EOMER: +2 influence against riders of rohan
; ERKENBRAND: +2 influence against riders of rohan
; GIMLI: +2 influence against the iron hills dwarves faction
; LEGOLAS: +2 influence against the wood-elves faction
(defrule MAIN::DIP-influence-certain-faction-+2 (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason faction-play $?))
        (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE $?) (state DONE) (name ?d))
	
        (data (phase faction-play) (data faction ?faction))
        (data (phase faction-play) (data character ?char))
        (test (or
            (and (eq (class ?char) ARAGORN-II) (eq (class ?faction) RANGERS-OF-THE-NORTH))
            (and (eq (class ?char) BOROMIR-II) (eq (class ?faction) MEN-OF-ANORIEN))
            (and (eq (class ?char) FARAMIR) (eq (class ?faction) RANGERS-OF-ITHILIEN))
            (and (eq (class ?char) EOMER) (eq (class ?faction) RIDERS-OF-ROHAN))
            (and (eq (class ?char) ERKENBRAND) (eq (class ?faction) RIDERS-OF-ROHAN))
            (and (eq (class ?char) GIMLI) (eq (class ?faction) IRON-HILL-DWARVES))
            (and (eq (class ?char) LEGOLAS) (eq (class ?faction) WOOD--ELVES))
        ))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 2)
        (motive "el modificador de influencia de " ?char " sobre " ?faction))
)

; ARAGORN-II: -3 marsharlling points if eliminated
(defrule MAIN::DIP-aragorn-eliminated (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a ARAGORN-II) (player ?p) (position ?pos&:(eq ?pos (outofgamesymbol ?p))))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot mp) (target ?p) (value -3)
        (motive "la eliminacion de Aragorn-II"))
)


; KILI,BEREGOND: -1 influence checks against factions
(defrule MAIN::DIP-influence-any-faction--1 (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason faction-play $?))
        (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE $?) (state DONE) (name ?d))
	
        (data (phase faction-play) (data character ?char))
        (object (is-a KILI | BEREGOND) (name ?char))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value -1)
        (motive "el modificador de influencia de " ?char " sobre cualquier facion"))
)


; KILI: +1 prowess against orcs
; ELLADAN: +1 prowess against orcs
(defrule MAIN::DIP-strike-orcs-+1 (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
        (object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (name ?d))
	
        (data (phase strike) (data target ?char))
        (object (is-a KILI | ELLADAN) (name ?char))
        (data (phase strike) (data attackable ?at))
        (object (name ?at) (race ORC))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 1)
        (motive "el modificador de " ?char " sobre ataques orcos"))
)

; MERRY: unless he is one of the starting characters, he may only be brought to play at his home site (falta BAG-END)
; PIPPIN: unless he is one of the starting characters, he may only be brought to play at his home site (falta BAG-END)
; (defrule MAIN::EI-play-merry-pippin (declare (auto-focus TRUE) (salience ?*E-intercept*))
;     ?e <- (object (is-a E-modify) (state IN) (reason $? PLAY $?) (target ?t) (new ?loc))
;     (object (is-a MERRY | PIPPIN) (name ?t))
;     (not (object (is-a E-phase) (reason start-game $?) (state EXEC-HOLD)))
;     (not (object (is-a BAG-END) (name ?loc)))
;     (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-play-merry-pippin)))
;     =>
;     (E-cancel MAIN::EI-play-merry-pippin)
; )


; GANDALF: Gandalf may tap to test a gold ring in his company
(defrule MAIN::a-gandalf-ring-test (declare (salience ?*a-population*))
	(logical
    	(player ?p)
		(object (is-a GANDALF) (player ?p) (state UNTAPPED) (name ?gandalf))
        (object (is-a GOLD-RING) (player ?p) (name ?ring))
        ;TODO: definir concretamente cuando se puede usar
	)
	=>
	(assert (action 
		(player ?p)
		(event-def phase) ;TODO: definir la fase. QUE LOS CANCELERS DE UN EVENTO SE APLIQUEN A ACTION
		(description (sym-cat "Girar a Gandalf para examinar el anillo " ?ring))
		(identifier ?gandalf ?ring)
        (data ring ?ring)
		(reason ring MAIN::a-gandalf-ring-test)
	))
)


; GIMLI: +2 prowess against orcs
(defrule MAIN::DIP-strike-gimli (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
        (object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (name ?d))
	
        (data (phase strike) (data target ?char))
        (object (is-a GIMLI) (name ?char))
        (data (phase strike) (data attackable ?at))
        (object (name ?at) (race ORC))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 2)
        (motive "el modificador de Gimli sobre ataques orcos"))
)


; GIMLI: +1 influence against elf factions
(defrule MAIN::DIP-influence-gimli (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason faction-play $?))
        (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE $?) (state DONE) (name ?d))
	
        (data (phase faction-play) (data faction ?faction&:(eq ELF (send ?faction get-race))))
        (data (phase faction-play) (data character ?char))
        (object (is-a GIMLI) (name ?char))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 1)
        (motive "el modificador de influencia de Gimli sobre facciones de elfos"))
)