; ARAGORN-II: +2 influence against rangers of the north faction
; BOROMIR-II: +2 influence against men of anorien (falta MEN-OF-ANORIEN)
; FARAMIR: +2 influence against rangers of ithilien (falta RANGERS-OF-ITHILIEN)
; EOMER: +2 influence against riders of rohan
; ERKENBRAND: +2 influence against riders of rohan
; GIMLI: +2 influence against the iron hills dwarves faction
; LEGOLAS: +2 influence against the wood-elves faction
; BARD-BOWMAN: +2 influence against the men of northern rhovanion faction
(defrule MAIN::DIP-influence-certain-faction-+2 (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason faction-play $?))
        (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE-ROLL $?) (state DONE) (name ?d))
	
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
            (and (eq (class ?char) BARD-BOWMAN) (eq (class ?faction) MEN-OF-NORTHERN-RHOVANION))
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
        (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE-ROLL $?) (state DONE) (name ?d))
	
        (data (phase faction-play) (data character ?char))
        (object (is-a KILI | BEREGOND) (name ?char))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value -1)
        (motive "el modificador de influencia de " ?char " sobre cualquier facion"))
)


; KILI: +1 prowess against orcs
; ELLADAN: +1 prowess against orcs
; ELROHIR: +1 prowess against orcs
(defrule MAIN::DIP-strike-orcs-+1 (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
        (object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (name ?d))
	
        (data (phase strike) (data target ?char))
        (object (is-a KILI | ELLADAN | ELROHIR) (name ?char))
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
        (object (is-a FELLOWSHIP) (name ?fell))
        (in (over ?fell) (under ?gandalf))
        (in (over ?fell) (under ?ring))
        ;TODO: definir concretamente cuando se puede usar
	)
	=>
	(assert (action 
		(player ?p)
		(event-def phase) ;TODO: QUE LOS CANCELERS DE UN EVENTO SE APLIQUEN A ACTION
		(description (sym-cat "Girar a Gandalf para examinar el anillo " ?ring))
		(identifier ?gandalf ?ring)
        (data gandalf ?gandalf ring ?ring)
		(reason ring MAIN::a-gandalf-ring-test)
	))
)


; GANDALF: Girar al examinar el anillo segun la regla anterior
(defrule MAIN::EI-tap-gandalf-test (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (state IN) (reason $? gandalf ?gandalf $? MAIN::a-gandalf-ring-test))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-tap-gandalf-test)))
    =>
    (E-modify ?gandalf state TAPPED TAP MAIN::EI-tap-gandalf-test)
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
        (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE-ROLL $?) (state DONE) (name ?d))
	
        (data (phase faction-play) (data faction ?faction&:(eq ELF (send ?faction get-race))))
        (data (phase faction-play) (data character ?char))
        (object (is-a GIMLI) (name ?char))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 1)
        (motive "el modificador de influencia de Gimli sobre facciones de elfos"))
)


; SARUMAN: May tap to use a Palantir he bears
(defrule MAIN::a-saruman-use-palantir (declare (salience ?*a-population*))
	(logical
    	(player ?p)
		(object (is-a SARUMAN) (player ?p) (state UNTAPPED) (name ?saruman))
        (object (is-a PALANTIR) (position ?saruman) (name ?palantir))
        ;TODO: definir concretamente cuando se puede usar
	)
	=>
	(assert (action 
		(player ?p)
		(event-def phase) ;TODO: definir la fase. QUE LOS CANCELERS DE UN EVENTO SE APLIQUEN A ACTION
		(description (sym-cat "Girar Saruman para usar una palantir " ?palantir))
		(identifier ?saruman ?palantir)
        (data palantir ?palantir)
		(reason MAIN::a-saruman-use-palantir)
	))
)


; SARUMAN: TODO: At the beginning of your end-of-turn phase you may tap Saruman to take one spell from your discard pile to your hand
; (defrule MAIN::EI-spell-Saruman
; )


; SHIELD-OF-IRON--BOUND-ASH: Tap shield of iron-bound ash to gain +1 prowess against one strike
(defrule strike-4::shield-of-iron--bound-ash
    (object (is-a SHIELD-OF-IRON--BOUND-ASH) (state UNTAPPED) (position ?t) (name ?shield))
    (data (phase strike) (data target ?t))
    =>
    (assert (data (phase strike) (data shield-of-iron--bound-ash ?t)))
    (E-modify ?shield state TAPPED strike-4::shield-of-iron--bound-ash)
)

; SHIELD-OF-IRON--BOUND-ASH
(defrule MAIN::DIP-shield-of-iron--bound-ash (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
        (object (is-a E-phase) (position ?e) (reason dices STRIKE-ROLL $?) (state DONE) (name ?d))
	
        (data (phase strike) (data shield-of-iron--bound-ash ?t))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 1)
        (motive "el uso del escudo de fresno y hierro forjado"))
)



; SCROLL-OF-ISILDUR: When a gold ring is tested in a company with scroll of islildur, the result of the roll is modified with +2
(defrule ring-1::DIP-scroll-of-isildur (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a E-phase) (position ?e) (reason dices RING-TEST-ROLL $?) (state DONE) (name ?d))
    	(data (phase ring) (data ring ?ring))
        (object (is-a SCROLL-OF-ISILDUR) (name ?scroll))
        (object (is-a FELLOWSHIP) (name ?fell))
        (in (over ?fell) (under ?ring))
        (in (over ?fell) (under ?scroll))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 2)
        (motive "el pergamino de Isildur en su compañia"))
)


; GREAT SHIELD OF ROHAN: Warrior only: tap great shield of rohan to remain untapped against one strike (unless the bearer is wounded by the strike)
(defrule MAIN::EIa-great-shield-of-rohan (declare (salience ?*a-population*))
	(logical
        (object (is-a GREAT-SHIELD-OF-ROHAN) (state UNTAPPED) (position ?t) (name ?shield))
		(object (is-a CHARACTER) (state UNTAPPED) (name ?t) (player ?p))
        (object (is-a E-modify) (target ?t) (state IN) (reason $? MAIN::EI-tap-unhindered) (name ?e))
        (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EIa-great-shield-of-rohan)))
        ; TODO: cuando se debe activar esto?
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Girar el Gran Escudo de Rohan para evitar girar el guerrero " ?t))
		(identifier ?shield)
        (data ?shield state TAPPED)
		(reason MAIN::EIa-great-shield-of-rohan)
	))
)

; GREAT SHIELD OF ROHAN:
(defrule MAIN::EI-great-shield-of-rohan-cancel (declare (salience ?*a-population*))
    ?e <- (object (is-a E-modify) (target ?t) (state IN) (reason $? MAIN::EI-tap-unhindered))
    (not (object (is-a EVENT) (position ?e) (reason $? MAIN::EI-tap-unhindered)))
	=>
	(E-cancel MAIN::EI-great-shield-of-rohan-cancel)
)

; GLAMDRING: a maximum of 9 against orcs
(defrule strike-5::DIP-glamdring (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (data (phase strike) (data target ?char))
        (data (phase strike) (data attackable ?at))
        (object (name ?at) (race ORC))
        (object (is-a GLAMDRING) (position ?char) (name ?glamdring))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot max-prowess) (target ?glamdring) (value 1)
        (motive "el modificador de Glamdring sobre ataques orcos"))
)


; HAUBERK-OF-BRIGHT-MAIL: Warrior only: +2 body to a maximum of 9
(defrule MAIN::DIP-hauberk-of-bright-mail (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (object (is-a CHARACTER) (skills $? WARRIOR $?) (name ?char))
        (object (is-a HAUBERK-OF-BRIGHT-MAIL) (position ?char) (name ?i))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot body) (target ?char) 
        (value (max 0 (min 2 (- 9 (send ?char get-body)))))
        (motive "el jubon de malla brillante del guerrero " ?char))
)


; ORCRIST: +4 to prowess to a maximum of 10 against orcs
(defrule strike-5::DIP-orcrist (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        (data (phase strike) (data target ?char))
        (data (phase strike) (data attackable ?at))
        (object (name ?at) (race ORC))
        (object (is-a ORCRIST) (position ?char) (name ?orcrist))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot prowess) (target ?orcrist) (value 1)
        (motive "el modificador de Orcrist sobre ataques orcos"))
    (make-instance (gen-name data-item) of data-item (target-slot max-prowess) (target ?orcrist) (value 1)
        (motive "el modificador de Orcrist sobre ataques orcos"))
)


; DODGE: target character does not tap against one strike (unless he is wounded by the strike). If wounded by the strike, his body is modified by -1 for the resulting body check.
(defrule strike-4::a-dodge (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
        (data (phase strike) (data target ?t))
		(object (is-a DODGE) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?dodge))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Se utiliza Esquiva sobre " ?t))
		(identifier ?dodge ?t)
		(data (create$ ?dodge position (discardsymbol ?p)))
		(reason target ?t strike-4::a-dodge)
	))
)

; DODGE
(defrule MAIN::EI-dodge-cancel-tap (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN) (reason $? MAIN::EI-tap-unhindered) (position ?strike))
    (exists (object (is-a E-modify) (state DONE) (position ?strike) (reason target ?t strike-4::a-dodge)))
    (not (object (is-a EVENT) (position ?e) (reason $? EI-dodge-cancel-tap)))
	=>
	(E-cancel MAIN::EI-dodge-cancel-tap)
)

; DODGE
(defrule resistance-check-1::DIP-dodge-res-check (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (logical
        (object (is-a E-phase) (state EXEC) (reason $?   strike-5::execute-strike#defender-res-check) (position ?strike))
	    (object (is-a E-phase) (reason dices RESISTANCE-ROLL $?) (state DONE) (name ?d))
        (exists (object (is-a E-modify) (state DONE) (position ?strike) (reason target ?t strike-4::a-dodge)))
    )
	=>
	(make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value -1)
        (motive "el efecto adverso de Esquiva"))
)


; LUCKY-STRIKE: Warrior only: make two rolls against a strike and choose one of the two rolls to use
(defrule strike-4::a-lucky-strike (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
        (data (phase strike) (data target ?t))
        (object (name ?t) (skills $? WARRIOR $?))
		(object (is-a LUCKY-STRIKE) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?ls))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Se utiliza Golpe afortunado sobre " ?t))
		(identifier ?ls ?t)
		(data (create$ ?ls position (discardsymbol ?p)))
		(reason strike-4::a-lucky-strike)
	))
)

; LUCKY-STRIKE
(defrule strike-5::a-lucky-strike-roll (declare (salience ?*a-population*))
	?strike <- (object (is-a E-phase) (state EXEC))
    (player ?p)
    (exists (object (is-a E-phase) (position ?strike) (reason dices STRIKE-ROLL $?) (state DONE)))
	(exists (object (is-a E-modify) (position ?strike) (reason strike-4::a-lucky-strike) (state DONE)))
	=>
	(E-roll-dices STRIKE-ROLL strike-5::a-lucky-strike-roll)
)


;LUCKY-STRIKE
(defrule strike-5::a-lucky-strike-choose (declare (salience ?*a-population*))
	(logical
		?strike <- (object (is-a E-phase) (state EXEC))
    	(player ?p)
        (exists 
            (object (is-a E-phase) (position ?strike) (reason $? strike-5::a-lucky-strike-roll) (state DONE))
            (object (is-a E-phase) (position ?strike) (reason $? ~strike-5::a-lucky-strike-roll) (state DONE))
        )
        (object (is-a E-phase) (position ?strike) (reason dices STRIKE-ROLL $?) (state DONE) (res ?d) (name ?roll))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Elegir la tirada de " ?d))
		(identifier ?d)
		(data (create$ ?roll position (outofgamesymbol ?p)))
		(reason strike-5::a-lucky-strike-choose)
        (blocking TRUE)
	))
)


; TEMPERING-FRIENDSHIP: +4 to an influence attempt against a faction
(defrule faction-play-2::a-tempering-friendship (declare (salience ?*a-population*))
	(logical
		?e <- (object (is-a E-phase) (state EXEC))
    	(player ?p)
	    (data (phase faction-play) (data character ?char))
		(object (is-a TEMPERING-FRIENDSHIP) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?tf))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar Fiel Amistad sobre " ?char))
		(identifier ?tf ?char)
		(data (create$ ?tf position ?char))
		(reason faction-play-2::a-tempering-friendship)
	))
)


; TEMPERING-FRIENDSHIP
(defrule faction-play-3::DIP-tempering-friendship (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?fp <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-phase) (position ?fp) (reason dices FACTION-INFLUENCE-ROLL $?) (state DONE) (name ?d))
    (object (is-a E-modify) (position ?fp) (reason faction-play-2::a-tempering-friendship) (state DONE))
	=>
	(make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 4)
        (motive "Fiel Amistad"))
)


; CONCEALEMENT: Scout only. Tap one scout to cancel one attack against his company
(defrule attack-1::a-concealement (declare (salience ?*a-population*))
	(logical
        (object (is-a CONCEALEMENT) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?concealement))
		?e <- (object (is-a E-phase) (state EXEC))
		(data (phase attack) (data fellowship ?fell))
        (object (is-a ATTACKABLE) (player ?p) (skills $? SCOUT $?) (state UNTAPPED) (name ?t))
        (in (over ?fell) (under ?t))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar Ocultamiento sobre " ?t))
		(identifier ?concealement ?t)
		(data (create$ ?concealement position (discardsymbol ?p)))
		(reason target ?t attack-1::a-concealement)
	))
)

; CONCEALEMENT
(defrule MAIN::EI-tap-concealement (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (reason target ?char attack-1::a-concealement) (state EXEC))
	(not (object (is-a EVENT) (position ?e) (reason MAIN::EI-tap-concealement)))
    =>
	(E-modify ?char state TAPPED MAIN::EI-tap-concealement)
)

; CONCEALEMENT
(defrule attack-1::EI-cancel-concealement (declare (auto-focus TRUE) (salience ?*E-intercept*))
	?attack <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-modify) (position ?attack) (reason target ?char attack-1::a-concealement) (state DONE))
    =>
	(complete UNDEFEATED)
)


; HALFLING-STEALTH: Hobbit only: cancel one strike against the hobbit
(defrule strike-4::a-halfling-stealth (declare (salience ?*a-population*))
	(logical
		?e <- (object (is-a E-phase) (state EXEC))
    	(player ?p)
        (data (phase strike) (data target ?t))
        (object (name ?t) (race HOBBIT))
		(object (is-a HALFLING-STEALTH) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?hs))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Utilizar Sigilo de los Medianos en " ?t))
		(identifier ?hs ?t)
		(data (create$ ?hs position (discardsymbol ?p)))
		(reason strike-4::a-halfling-stealth)
	))
)


; HALFLING-STEALTH
(defrule strike-4::EI-cancel-halfling-stealth (declare (auto-focus TRUE) (salience ?*E-intercept*))
	?strike <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-modify) (position ?strike) (reason strike-4::a-halfling-stealth) (state DONE))
    =>
	(complete PARTIALLY-UNDEFEATED)
)


; HALFLING-STRENGTH (1): he may receive a +4 modification to one corruption check
(defrule corruption-check1::a-halfling-strength (declare (salience ?*a-population*))
	(logical
		?e <- (object (is-a E-phase) (state EXEC))
    	(player ?p)
	    (data (phase corruption-check) (data target ?t))
        (object (name ?t) (race HOBBIT))
		(object (is-a HALFLING-STRENGTH) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?hs))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Utilizar Fuerza de los Medianos en el chequeo de resistencia de " ?t))
		(identifier ?hs ?t)
		(data (create$ ?hs position (discardsymbol ?p)))
		(reason corruption-check1::a-halfling-strength)
	))
)

; HALFLING-STRENGTH (1)
(defrule corruption-check1::DIP-halfling-strength (declare (auto-focus TRUE) (salience ?*universal-rules*))
    ?e <- (object (is-a E-phase) (state EXEC) (reason corruption-check $?))
    (object (is-a E-phase) (position ?e) (reason dices CORRUPTION-ROLL $?) (state DONE) (name ?d))
	(object (is-a E-modify) (position ?strike) (reason strike-4::a-halfling-stealth) (state DONE))
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value 4)
        (motive "el modificador de corrupcion de Fuerza de los Medianos"))
)


; HALFLILNG-STRENGTH (2): Hobbit only: the hobbit may untap or he may move from wounded status to well and untapped during his organization phase or ...
(defrule P-1-1-1::a-halfling-strength (declare (salience ?*a-population*))
	(logical
		?e <- (object (is-a E-phase) (state EXEC))
    	(player ?p)
        (object (name ?t) (race HOBBIT) (state TAPPED | WOUNDED))
		(object (is-a HALFLING-STRENGTH) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?hs))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Usar Fuerza de los Medianos para curar heridas o cansancio de " ?t))
		(identifier ?hs ?t)
		(data (create$ ?hs position (discardsymbol ?p)))
		(reason target ?t P-1-1-1::a-halfling-strength)
	))
)


; HALFLING-STRENGTH (2)
(defrule MAIN::EI-halfling-strength-cure (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (reason target ?t P-1-1-1::a-halfling-strength) (state EXEC))
	(not (object (is-a EVENT) (position ?e) (reason MAIN::EI-halfling-strength-cure)))
    =>
	(E-modify ?t state UNTAPPED MAIN::EI-halfling-strength-cure)
)


; ESCAPE: Playable on an unwounded character facing an attack. The attack is canceled and the character is wounded (no body check is required)
(defrule attack-1::a-escape (declare (salience ?*a-population*))
	(logical
		(object (is-a ESCAPE) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?escape))
		?e <- (object (is-a E-phase) (state EXEC))
		(data (phase attack) (data fellowship ?fell))
        (object (is-a ATTACKABLE) (player ?p) (state ~WOUNDED) (name ?t))
        (in (over ?fell) (under ?t))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar Huida sobre " ?t))
		(identifier ?escape ?t)
		(data (create$ ?escape position (discardsymbol ?p)))
		(reason target ?t attack-1::a-escape)
	))
)


; ESCAPE
(defrule MAIN::EI-wound-escape (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (reason target ?char attack-1::a-escape) (state EXEC))
	(not (object (is-a EVENT) (position ?e) (reason MAIN::EI-wound-escape)))
    =>
	(E-modify ?char state WOUNDED MAIN::EI-wound-escape)
)

; ESCAPE
(defrule attack-1::EI-cancel-escape (declare (auto-focus TRUE) (salience ?*E-intercept*))
	?attack <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-modify) (position ?attack) (reason target ?char attack-1::a-escape) (state DONE))
    ; TODO: IMPORTANTE!!!!! ESTO SE VA A REPETIR CADA VEZ QUE OTRO EI SE ACTIVE
    =>
	(complete UNDEFEATED)
)

; TODO: division de fases del juego
; ; FORD: Playable at the end of the organization phase on an untapped ranger. Tap the ranger. No hazard no hazard creatures may be keyed to a Wilderness against the ranger's company this turn
; (defrule ???::a-ford (declare (salience ?*a-population*))
; 	(logical
; 		(object (is-a FORD) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?ford))
; 		?e <- (object (is-a E-phase) (state EXEC))
; 		?turn <- (object (is-a E-phase) (reason turn $?) (state EXEC-HOLD))
;         (object (is-a ATTACKABLE) (state UNTAPPED) (skills $? RANGER $?) (name ?t))
; 	)
; 	=>
; 	(assert (action 
; 		(player ?p)
; 		(event-def modify)
; 		(description (sym-cat "Jugar Vado sobre " ?t))
; 		(identifier ?ford ?t)
; 		(data (create$ ?ford position (discardsymbol ?p)))
; 		(reason target ?t ???::a-ford)
; 	))
; )


; ; FORD
; (defrule MAIN::EI-cancel-ford (declare (auto-focus TRUE) (salience ?*E-intercept*))
; 	(object (is-a E-modify) (state IN) (reason PLAY CREATURE REGION WILDERNESS $?))
; 	?turn <- (object (is-a E-phase) (reason turn $?) (state EXEC-HOLD))
; 	?ford-play <- (not (object (is-a E-modify) (reason target ?t ???::a-ford)))
;     (in (over ?turn) (under ?ford-play))
;     (not (object (is-a EVENT) (reason $? MAIN::EI-cancel-ford)))
;     =>
; 	(E-cancel MAIN::EI-cancel-ford)
; )


; BRIDGE: Playable at the end of a movement/hazard phase of a company that moved to a haven. That company may move to an additional site on the same turn. Another site card may be played and a movement/hazard phase inmediately follows for that company
(defrule MAIN::EIa-bridge (declare (auto-focus TRUE) (salience ?*a-population*))
	(logical
        ; TODO: revisar bien
		(object (is-a BRIDGE) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?bridge))
		?e <- (object (is-a E-phase) (state OUT) (data $? fellowship ?fell $? to ?to $?) (reason fell-move $?))
        (player ?p)
        (object (is-a HAVEN) (name ?to))
        (not (object (is-a EVENT) (reason $? MAIN::EIa-bridge)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar Puente sobre " ?fell))
		(identifier ?bridge ?t)
		(data (create$ ?bridge position (discardsymbol ?p)))
		(reason target ?fell MAIN::EIa-bridge)
	))
)

; BRIDGE
(defrule P-3-1-1::a-bridge (declare (auto-focus TRUE) (salience ?*a-population*))
	(logical
    ; TODO: revisar bien, hacer que solo se active una vez (solucionado)
		?e <- (object (is-a E-phase) (state EXEC))
        (object (is-a E-modify) (position ?e) (reason target ?fell MAIN::EIa-bridge) (state DONE))
        (object (is-a FELLOWSHIP) (name ?fell) (empty FALSE) (player ?p) (position ?loc))
        (object (is-a HAVEN) (name ?loc) (site-pathA ?pathA)); (site-pathB ?pathB))
        (object (is-a LOCATION) (place ~HAVEN) (closest-haven ?loc) (name ?to))
        (not (object (is-a E-phase) (state DONE) (reason $? P-3-1-1::a-bridge)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def variable)
		(description (sym-cat "Declarar segundo movimiento de " ?fell " hacia " ?to " por Puente"))
		(identifier ?fell ?to)
		(data fellowship ?fell / to ?to)
        (reason fell-move P-3-1-1::a-bridge)
	))
	(assert (action 
		(player ?p)
		(event-def variable)
		(description (sym-cat "Declarar segundo movimiento de " ?fell " hacia " ?pathA " por Puente"))
		(identifier ?fell ?pathA)
		(data fellowship ?fell / to ?pathA) 
        (reason fell-move P-3-1-1::a-bridge)
	))
)


; MUSTER: An influence check against a faction by a warrior is modified by adding the warrior's prowess to a maximum modifier of +5
(defrule faction-play-2::a-muster (declare (salience ?*a-population*))
	(logical
		?e <- (object (is-a E-phase) (state EXEC))
    	(player ?p)
	    (data (phase faction-play) (data character ?char))
		(object (is-a MUSTER) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?muster))
        (object (name ?char) (skills $? WARRIOR $?))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar Acantonamiento sobre " ?char))
		(identifier ?muster ?char)
		(data (create$ ?tf position (discardsymbol ?p)))
		(reason target ?char faction-play-2::a-muster)
	))
)


; MUSTER
(defrule MAIN::DIP-muster (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (object (is-a E-modify) (reason target ?char faction-play-2::a-muster) (state DONE))
    (object (name ?char) (prowess ?prowess))
    ?e <- (object (is-a E-phase) (state EXEC) (reason faction-play $?))
    (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE-ROLL $?) (state DONE) (name ?d))
    =>
    (make-instance (gen-name data-item) of data-item (target-slot res) (target ?d) (value (min ?prowess 5))
        (motive "el modificador de influencia de Acantonamiento en " ?char))
)


; BLOCK: Warrior only. Warrior does not tap against one strike (unless he is wounded by the strike).
(defrule strike-4::a-block (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
        (data (phase strike) (data target ?t))
		(object (is-a BLOCK) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?block))
        (object (name ?t) (skills $? WARRIOR $?))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Se utiliza Bloqueo sobre " ?t))
		(identifier ?block ?t)
		(data (create$ ?block position (discardsymbol ?p)))
		(reason target ?t strike-4::a-block)
	))
)

; BLOCK
(defrule MAIN::EI-block-cancel-tap (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (state IN) (reason $? MAIN::EI-tap-unhindered) (position ?strike))
    (exists (object (is-a E-modify) (state DONE) (position ?strike) (reason target ?t strike-4::a-block)))
    (not (object (is-a EVENT) (position ?e) (reason $? EI-block-cancel-tap)))
	=>
	(E-cancel MAIN::EI-block-cancel-tap)
)


; RISKY-BLOW: Warrior only against one strike. +3 to prowess and -1 to body
(defrule strike-4::a-risky-blow (declare (salience ?*a-population*))
	(logical
		(object (is-a E-phase) (state EXEC))
    	(player ?p)
        (data (phase strike) (data target ?t))
		(object (is-a RISKY-BLOW) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?rb))
        (object (name ?t) (skills $? WARRIOR $?))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Se utiliza Bloqueo sobre " ?t))
		(identifier ?rb ?t)
		(data (create$ ?rb position (discardsymbol ?p)))
		(reason target ?t strike-4::a-risky-blow)
	))
)

; RISKY-BLOW
(defrule MAIN::DIP-risky-blow (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (logical
        ?e <- (object (is-a E-phase) (state EXEC) (reason strike $?))
        (object (is-a E-modify) (position ?e) (reason target ?t strike-4::a-risky-blow) (state DONE))
        (object (is-a E-phase) (position ?e) (reason dices FACTION-INFLUENCE-ROLL $?) (state DONE) (name ?d))
    )
    =>
    (make-instance (gen-name data-item) of data-item (target-slot prowess) (target ?char) (value 3)
        (motive "el modificador de Golpe Arriesgado en " ?char))
    (make-instance (gen-name data-item) of data-item (target-slot body) (target ?char) (value -1)
        (motive "el modificador de Golpe Arriesgado en " ?char))
)


; DARK-QUARRELS: Cancel one attack by orcs, trolls or men...
(defrule attack-1::a-dark-quarrels (declare (salience ?*a-population*))
	(logical
        (object (is-a DARK-QUARRELS) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?dk))
		?e <- (object (is-a E-phase) (state EXEC))
		(data (phase attack) (data attackable ?at))
        (test (member$ ?at (create$ TROLL ORC MAN)))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar Discusiones Oscuras"))
		(identifier ?dk)
		(data (create$ ?dk position (discardsymbol ?p)))
		(reason attack-1::a-dark-quarrels)
	))
)


; DARK-QUARRELS
(defrule attack-1::EI-cancel-dark-quarrels (declare (auto-focus TRUE) (salience ?*E-intercept*))
	?attack <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-modify) (position ?attack) (reason attack-1::a-dark-quarrels) (state DONE))
    ; TODO: IMPORTANTE!!!!! ESTO SE VA A REPETIR CADA VEZ QUE OTRO EI SE ACTIVE
    =>
	(complete UNDEFEATED)
)


; QUICKBEAM: may not be attacked by automatic attacks or hazards keyed to his site
(defrule MAIN::QUICKBEAM (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (object (is-a QUICKBEAM) (name ?q))
    ?strike <- (data (phase attack) (data strike ?q))
    (in (over [wellinghall]) (under ?q))
    (or 
        (object (is-a E-phase) (state EXEC-HOLD) (reason combat loc-phase-1-1::face-automatic-attacks))
        (and 
            ?modify <- (object (is-a E-modify) (reason $? PLAY CREATURE PLACE [wellinghall] $?))
            (object (is-a E-phase) (position ?modify) (state EXEC-HOLD) (reason combat CREATURE $?))
        )
    )
    =>
    (retract ?f)
    (assert (data (phase attack) (data unasigned-strike 0)))
    ; TODO: esto se va a repetir muchas veces y no va a contabilizar
)


; GOLLUM: If his company's size is two or less, tap gollum to cancel one attack against his company keyed to wilderness or shadow-land...
(defrule attack-1::a-gollum (declare (salience ?*a-population*))
	(logical
        (object (is-a GOLLUM) (state UNTAPPED) (name ?gollum))
		(data (phase attack) (data fellowship ?fell))
        (object (is-a FELLOWSHIP) (companions ?c&:(<= ?c 2)) (name ?fell))
        (in (over ?fell) (under ?gollum))
		?modify <- (object (is-a E-modify) (reason $? PLAY CREATURE REGION WILDERNESS|SHADOW-LAND $?))
		?combat <- (object (is-a E-phase) (position ?modify))
		?attack <- (object (is-a E-phase) (position ?combat) (state EXEC))
		(data (phase attack) (data attackable ?at))

	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Cancelar ataque con Gollum"))
		(identifier ?gollum)
		(data (create$ ?gollum state TAPPED))
		(reason attack-1::a-gollum)
	))
)


; GOLLUM
(defrule attack-1::EI-gollum-cancel (declare (auto-focus TRUE) (salience ?*E-intercept*))
	?attack <- (object (is-a E-phase) (state EXEC))
	(object (is-a E-modify) (position ?attack) (reason attack-1::a-gollum) (state DONE))
    ; TODO: IMPORTANTE!!!!! ESTO SE VA A REPETIR CADA VEZ QUE OTRO EI SE ACTIVE
    =>
	(complete UNDEFEATED)
)


; GOLLUM: You may tap Gollum if he is at the same non-haven site as the one ring; then both gollum and the one ring are discarded
(defrule MAIN::a-gollum (declare (salience ?*a-population*))
	(logical
    ; TODO: concretar cuando se puede usar, cuidado con los nombres repetidos en reglas
        (object (is-a GOLLUM) (state UNTAPPED) (player ?p) (name ?gollum))
        (object (is-a THE-ONE-RING) (name ?ring))
        (object (is-a LOCATION) (place ~HAVEN) (name ?loc))
        (in (over ?loc) (under ?gollum))
        (in (over ?loc) (under ?ring))
		(object (is-a E-phase) (state EXEC))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Descartar " ?ring " y " ?gollum))
		(identifier ?gollum)
		(data (create$ ?gollum state TAPPED))
		(reason target ?ring MAIN::a-gollum)
	))
)

; GOLLUM
(defrule MAIN::EI-gollum-discard-ring (declare (auto-focus TRUE) (salience ?*E-intercept*))
	?e <- (object (is-a E-modify) (reason target ?ring attack-1::a-gollum) (state EXEC))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-gollum-discard-ring)))
    =>
	(E-modify ?ring position (discardsymbol (send ?ring get-player)))
)

; GOLLUM
(defrule MAIN::EI-gollum-discard-self (declare (auto-focus TRUE) (salience ?*E-intercept*))
	?e (object (is-a E-modify) (reason $? attack-1::a-gollum) (target ?gollum) (state EXEC))
    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-gollum-discard-self)))
    =>
	(E-modify ?gollum position (discardsymbol (send ?ring get-player)))
)


; BERT-BURAT: If played against a company that faced william or tom this turn, each character wounded by bert discards all non special items he bears
(defrule MAIN::EI-bert (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (reason MAIN::EI-wound) (state EXEC) (target ?t))
    ?turn <- (object (is-a E-phase) (reason turn $?) (state EXEC-HOLD))
    ?previous <- (object (is-a E-phase) (reason attack) (data fellowship ?fell / attackable ?attackable) (state DONE))
    (in (over ?fell) (under ?t))
    (or
        (object (is-a WILLIAM-WULUAG) (name ?attackable))
        (object (is-a WILLIAM-WULUAG) (name ?attackable))
        ; (object (is-a TOM-TUMA) (name ?attackable))
    )
    (in (over ?turn) (under ?previous))

	(data (phase strike) (data attackable ?bert))
    (object (is-a BERT-BURAT) (name ?bert))
    (object (is-a ITEM) (position ?t) (name ?item))
    (not (object (is-a SPECIAL-ITEM) (name ?item)))

    (not (object (is-a EVENT) (position ?e) (target ?item) (reason MAIN::EI-bert)))
	=>
	(E-modify ?item position (discardsymbol (send ?item get-player)) MAIN::EI-bert)
)


; BRIGANDS: If any of the strikes of the brigands hurts a character, the company must inmediately discard one item (of denfender's choice)
(defrule MAIN::EI-brigands (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-phase) (reason combat $?) (state OUT))
    ?attack <- (object (is-a E-phase) (position ?e) (reason attack $?) (state DONE) (data $? fellowship ?fell $? attackable ?brigands $?))
    (object (is-a BRIGANDS) (name ?brigands))
    ?wound <- (object (is-a E-modify) (reason MAIN::EI-wound) (state DONE))
    (in (over ?attack) (under ?wound))
    (object (is-a ITEM) (name ?item))
    (in (over ?fell) (under ?item))

    (not (object (is-a EVENT) (position ?e) (reason MAIN::EI-brigands)))
	=>
    (assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Descartar " ?item " por el golpe de los Forjidos"))
		(identifier ?item)
		(data (create$ ?item position (discardsymbol (send ?item get-player))))
		(reason MAIN::EI-brigands)
        (blocking TRUE)
	))
)


; WILLIAM-WULUAG: If played against a company that faced bert or tom this turn, each character wounded by william discards all non special items he bears
(defrule MAIN::EI-william (declare (auto-focus TRUE) (salience ?*E-intercept*))
    ?e <- (object (is-a E-modify) (reason MAIN::EI-wound) (state EXEC) (target ?t))
    ?turn <- (object (is-a E-phase) (reason turn $?) (state EXEC-HOLD))
    ?previous <- (object (is-a E-phase) (reason attack) (data fellowship ?fell / attackable ?attackable) (state DONE))
    (in (over ?fell) (under ?t))
    (or
        (object (is-a BERT-BURAT) (name ?attackable))
        (object (is-a BERT-BURAT) (name ?attackable))
        ; (object (is-a TOM-TUMA) (name ?attackable))
    )
    (in (over ?turn) (under ?previous))

	(data (phase strike) (data attackable ?william))
    (object (is-a WILLIAM-WULUAG) (name ?william))
    (object (is-a ITEM) (position ?t) (name ?item))
    (not (object (is-a SPECIAL-ITEM) (name ?item)))

    (not (object (is-a EVENT) (position ?e) (target ?item) (reason MAIN::EI-william)))
	=>
	(E-modify ?item position (discardsymbol (send ?item get-player)) MAIN::EI-william)
)


; AROUSE-MINIONS: Playable on a shadow-hold or a dark-hold. This turn, the prowess of one automatic-attack (your choice) at target site is increased by 3. Cannot be duplicated at a given site.
(defrule attack-1::a-arouse-minions (declare (salience ?*a-population*))
	(logical
        (enemy ?p)
        (object (is-a AROUSE-MINIONS) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?am))
		?e <- (object (is-a E-phase) (state EXEC))
		(data (phase attack) (data attackable ?at))
        (object (is-a LOCATION) (place SHADOW-HOLD|DARK-HOLD) (automatic-attacks $? ?at $?) (name ?loc))
		?turn <- (object (is-a E-phase) (state EXEC-HOLD) (reason turn $?))
        (not (exists
            ?play <- (object (is-a E-modify) (reason target ?at2 attack-1::a-arouse-minions) (state DONE))
            (in (over ?turn) (under ?play))
            (object (name ?loc) (automatic-attacks $? ?at2 $?))
        ))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar Perturbar a los Lacayos sobre este ataque en " ?loc))
		(identifier ?am)
		(data (create$ ?am position (discardsymbol ?p)))
		(reason target ?at attack-1::a-arouse-minions)
	))
)


; AROUSE-MINONS
(defrule MAIN::DIP-arouse-minions (declare (auto-focus TRUE) (salience ?*E-intercept*))
    (logical
        ?play <- (object (is-a E-modify) (reason target ?at attack-1::a-arouse-minions) (state DONE))
        ?turn <- (object (is-a E-phase) (state EXEC-HOLD) (reason turn $?))
        (in (over ?turn) (under ?play))
    )
    =>
	(make-instance (gen-name data-item) of data-item (target-slot prowess) (target ?at) (value 3)
        (motive "Perturbar a los Lacayos"))
)


; RIVER: Playable on a site. A company moving to this site this turn must do nothing during its site phase. A ranger in such company may tap to cancel that effect, even at the start of his company's site phase.
(defrule fell-move-6::a-river (declare (salience ?*a-population*))
	(logical
        (enemy ?p)
        (object (is-a RIVER) (position ?pos&:(eq ?pos (handsymbol ?p))) (name ?rio))
		?e <- (object (is-a E-phase) (state EXEC))
        (data (phase fell-move) (data fellowship ?fell))
        (data (phase fell-move) (data to ?loc))
	)
	=>
	(assert (action 
		(player ?p)
		(event-def modify)
		(description (sym-cat "Jugar Rio sobre " ?loc))
		(identifier ?rio)
		(data (create$ ?rio position (discardsymbol ?p)))
		(reason target ?to fell-move-6::a-river)
	))
)

;TODO: finalizar de implementar RIVER