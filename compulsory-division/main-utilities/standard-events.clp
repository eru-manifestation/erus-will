; E-card-untap
(defclass MAIN::E-card-untap (is-a EVENT)
    (slot card (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CARD))
)

(defrule MAIN::E-card-untap (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-card-untap) (type IN)
		(card ?c))
    =>
    (send ?e complete)
    (send ?c put-state UNTAPPED)

    (debug Untapping ?c)
    (announce [player1] Untap ?c)
    (announce [player2] Untap ?c)
)

; E-cure
(defclass MAIN::E-cure (is-a EVENT)
    (slot card (visibility public) (type INSTANCE-NAME) (default ?NONE))
)

(defrule MAIN::E-cure (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-cure) (type IN)
		(card ?c))
    =>
    (send ?e complete)
    (send ?c put-state TAPPED)

    (debug Healing ?c)
    (announce [player1] Heal ?c)
    (announce [player2] Heal ?c)
)


; E-char-play
(defclass MAIN::E-char-play (is-a EVENT)
    (slot character (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot under (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP CHARACTER))
)


(defrule MAIN::E-char-play (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-char-play) (type IN)
		(character ?c) (under ?u))
    =>
    (send ?e complete)
    (in-move ?c ?u)
    (send ?c put-state UNTAPPED)
    (debug Playing character ?c under ?u)
    (announce [player1] Play character ?c ?u)
    (announce [player2] Play character ?c ?u)
)


; E-item-play-only-minor
(defclass MAIN::E-item-play-only-minor (is-a EVENT)
    (slot item (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes ITEM))
    (slot owner (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
)


(defrule MAIN::E-item-play-only-minor (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-item-play-only-minor) (type IN)
		(item ?item) (owner ?owner))
    =>
    (send ?e complete)
    (in-move ?item ?owner)
    (send ?item put-state UNTAPPED)
    (debug Playing minor item ?item under ?owner)
    (announce [player1] Play minor item ?item ?owner)
    (announce [player2] Play minor item ?item ?owner)
)


; E-item-play
(defclass MAIN::E-item-play (is-a EVENT)
    (slot item (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes ITEM))
    (slot owner (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot loc (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)


(defrule MAIN::E-item-play (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-item-play) (type IN)
		(item ?item) (owner ?owner) (loc ?loc))
    =>
    (send ?e complete)
    (in-move ?item ?owner)
    (send ?item put-state UNTAPPED)
    (send ?owner put-state TAPPED)
    (send ?loc put-state TAPPED)
    (debug Playing item ?item under ?owner)
    (announce [player1] Play item ?item ?owner)
    (announce [player2] Play item ?item ?owner)
)


; E-item-transfer
(defclass MAIN::E-item-transfer (is-a EVENT)
    (slot item (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes ITEM))
    (slot disposer (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot receiver (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    ; TODO: Puede un aliado tener un objeto??
)

(defrule MAIN::E-item-transfer (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-item-transfer) (type IN) 
        (item ?item) (receiver ?rec) (disposer ?disp))
    =>
    (send ?e complete)
    (make-instance (gen-name EP-corruption-check) of EP-corruption-check (character ?disp))
    (in-move ?item ?rec)

    (debug Transfering item ?item from ?disp to ?rec)
    (announce [player1] Transfer item ?item ?rec)
    (announce [player2] Transfer item ?item ?rec)
)


; E-item-store
(defclass MAIN::E-item-store (is-a EVENT)
    (slot item (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes ITEM))
    (slot bearer (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot haven (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-item-store (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-item-store) (type IN) 
        (item ?item) (bearer ?bearer) (haven ?haven))
    =>
    (send ?e complete)
    (make-instance (gen-name EP-corruption-check) of EP-corruption-check (character ?bearer))
    (send ?item put-state MP)

    (debug Storing item ?item in ?haven by ?bearer)
    (announce [player1] Store ?item ?haven)
    (announce [player2] Store ?item ?haven)
)


; E-loc-organize
(defclass MAIN::E-loc-organize (is-a EVENT)
    (slot player (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes PLAYER))
    (slot loc (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-loc-organize (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-loc-organize) (type IN) 
        (player ?p) (loc ?loc))
    =>
    (send ?e complete)
    (make-instance (gen-name EP-loc-organize) of EP-loc-organize (player ?p) (loc ?loc))
    (debug Organizing fellowships of player ?p in ?loc)
    (announce [player1] Organize ?loc)
    (announce [player2] Organize ?loc)
)


; E-r-long-event-discard
(defclass MAIN::E-r-long-event-discard (is-a EVENT)
    (slot r-long-event (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes R-LONG-EVENT))
)

(defrule MAIN::E-r-long-event-discard (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-r-long-event-discard) (type IN) 
        (r-long-event ?rle))
    =>
    (send ?e complete)
    (send ?rle put-state DISCARD)

    (debug Discarding long-event resoure ?rle)
    (announce [player1] Discard long-event resource ?rle)
    (announce [player2] Discard long-event resource ?rle)
)


; E-r-long-event-play
(defclass MAIN::E-r-long-event-play (is-a EVENT)
    (slot r-long-event (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes R-LONG-EVENT))
)

(defrule MAIN::E-r-long-event-play (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-r-long-event-play) (type IN) 
        (r-long-event ?rle))
    =>
    (send ?e complete)
    ; TODO: Qué siginifica jugar un r-long event?
    (send ?rle put-state UNTAPPED)

    (debug Playing long-event resoure ?rle)
    (announce [player1] Play long-event resource ?rle)
    (announce [player2] Play long-event resource ?rle)
)


; E-a-long-event-discard
(defclass MAIN::E-a-long-event-discard (is-a EVENT)
    (slot a-long-event (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes R-LONG-EVENT))
)

(defrule MAIN::E-a-long-event-discard (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-a-long-event-discard) (type IN) 
        (a-long-event ?ale))
    =>
    (send ?e complete)
    ; TODO: Qué siginifica jugar un r-long event?
    (send ?ale put-state DISCARD)

    (debug Discarding long-event adversity ?ale)
    (announce [player1] Discard long-event adversity ?ale)
    (announce [player2] Discard long-event adversity ?ale)
)


; E-fell-decl-remain
(defclass MAIN::E-fell-decl-remain (is-a EVENT)
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot loc (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)


; E-fell-decl-move
(defclass MAIN::E-fell-decl-move (is-a EVENT)
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot from (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
    (slot to (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)
(defmessage-handler E-fell-decl-move init after ()
	; Defuseo el evento de permanencia en el lugar de la compañía
	(do-for-instance ((?e E-fell-decl-remain)) (eq ?e:fell ?self:fell) (send ?e defuse))
)


; E-char-discard
(defclass MAIN::E-char-discard (is-a EVENT)
    (slot char (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
)

(defrule MAIN::E-char-discard (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-char-discard) (type IN) 
        (char ?c))
    =>
    (send ?e complete)
    (send ?c put-state DISCARD)
    ; TODO: COMO DESCARTAR TAMBIÉN SUS OBJETOS
    (debug Discarding character ?c)
    (announce [player1] Discard character ?c)
    (announce [player2] Discard character ?c)
)


; E-char-destroy
(defclass MAIN::E-char-destroy (is-a EVENT)
    (slot char (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
)

(defrule MAIN::E-char-destroy (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-char-destroy) (type IN) 
        (char ?c))
    =>
    (send ?e complete)
    (send ?c put-state OUT-OF-GAME)
    ; TODO: COMO DESCARTAR TAMBIÉN SUS OBJETOS

    (debug Destroying character ?c)
    (announce [player1] Destroy character ?c)
    (announce [player2] Destroy character ?c)
)


; E-char-move
(defclass MAIN::E-char-move (is-a EVENT)
    (slot char (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
)

(defrule MAIN::E-char-move (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-char-move) (type IN) 
        (char ?c) (fell ?fell))
    =>
    (send ?e complete)
    (in-move ?c ?fell)
    (debug Moving character ?c to ?fell)
    (announce [player1] Move character ?c ?fell)
    (announce [player2] Move character ?c ?fell)
)


; E-char-follow
(defclass MAIN::E-char-follow (is-a EVENT)
    (slot follower (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot followed (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
)

(defrule MAIN::E-char-follow (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-char-follow) (type IN) 
        (follower ?follower) (followed ?followed))
    =>
    (send ?e complete)
    (in-move ?follower ?followed)
    (debug Making character ?follower follower of ?followed)
    (announce [player1] Make follower ?follower ?followed)
    (announce [player2] Make follower ?follower ?followed)
)


; E-char-unfollow
(defclass MAIN::E-char-unfollow (is-a EVENT)
    (slot follower (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
)

(defrule MAIN::E-char-unfollow (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-char-unfollow) (type IN) 
        (follower ?follower) (fell ?fell))
    =>
    (send ?e complete)
    (in-move ?follower ?fell)
    (debug Making the follower ?follower an usual character in ?fell)
    (announce [player1] Unmake follower ?follower ?fell)
    (announce [player2] Unmake follower ?follower ?fell)
)


; E-fell-move
(defclass MAIN::E-fell-move (is-a EVENT)
    (slot decl-event (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes EVENT))
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot from (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
    (slot to (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-fell-move (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-fell-move) (type IN) 
        (from ?from) (to ?to) (fell ?fell) (decl-event ?decl-event))
    =>
    (send ?e complete)
    (send ?decl-event complete)
    (make-instance (gen-name EP-fell-move) of EP-fell-move (from ?from) (to ?to) (fell ?fell))
    (debug Executing ?fell movement from ?from to ?to)
)


; E-fell-remain
(defclass MAIN::E-fell-remain (is-a EVENT)
    (slot decl-event (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes EVENT))
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot loc (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-fell-remain (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-fell-remain) (type IN) 
        (loc ?loc) (fell ?fell) (decl-event ?decl-event))
    =>
    (send ?e complete)
    (send ?decl-event complete)
    (make-instance (gen-name EP-fell-move) of EP-fell-move (from ?loc) (to ?loc) (fell ?fell))
    (debug Executing the remain of ?fell in ?loc)
)


; E-player-draw
(defclass MAIN::E-player-draw (is-a EVENT)
    (slot player (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes PLAYER))
    (slot draw-ammount (visibility public) (type INTEGER) (default ?NONE) (range 1 ?VARIABLE))
)

(defrule MAIN::E-player-draw (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-player-draw) (type IN) 
        (player ?p) (draw-ammount ?n))
    =>
    (send ?e complete)

    (bind ?chosen (create$))
	; TODO: ESCOGE LOS PRIMEROS QUE SEAN, NO ES ALEATORIO
    (do-for-all-instances ((?card CARD) (?ownable OWNABLE)) (and (eq ?card ?ownable) (eq ?card:state DRAW) (eq ?card:player ?p))
        (if (< 0 ?n) then
            (bind ?chosen (insert$ ?chosen 1 ?card))
            (bind ?n (- ?n 1))
            (send ?card put-state HAND)
            else
            break
        )
    )
    (debug Player ?p draws (implode$ ?chosen))
)


; E-fell-move-player-draw
(defclass MAIN::E-fell-move-player-draw (is-a EVENT)
    (slot fell-move (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes E-fell-move))
)

(defrule MAIN::E-fell-move-player-draw (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-fell-move-player-draw) (type IN) 
        (fell-move ?fell-move))
    (player ?p)
    =>
    (send ?e complete)
    (make-instance (gen-name E-player-draw) of E-player-draw (draw-ammount 1) (player ?p))
    (send ?fell-move put-player-draw (- (send ?fell-move get-player-draw) 1))
)


; E-fell-move-enemy-draw
(defclass MAIN::E-fell-move-enemy-draw (is-a EVENT)
    (slot fell-move (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes E-fell-move))
)

(defrule MAIN::E-fell-move-enemy-draw (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-fell-move-enemy-draw) (type IN) 
        (fell-move ?fell-move))
    (enemy ?enemy)
    =>
    (send ?e complete)
    (make-instance (gen-name E-player-draw) of E-player-draw (draw-ammount 1) (player ?enemy))
    (send ?fell-move put-enemy-draw (- (send ?fell-move get-enemy-draw) 1))
)


; E-fell-change-loc
(defclass MAIN::E-fell-change-loc (is-a EVENT)
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot from (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
    (slot to (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-fell-change-loc (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-fell-change-loc) (type IN) 
        (fell ?fell) (from ?from) (to ?to))
    =>
    (send ?e complete)
    (in-move ?fell ?to)
    (debug Changing location of fellowship ?fell from ?from to ?to)
)


; E-loc-destroy
(defclass MAIN::E-loc-destroy (is-a EVENT)
    (slot loc (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-loc-destroy (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-loc-destroy) (type IN) 
        (loc ?loc))
    =>
    (send ?e complete)
    (send ?loc put-state OUT-OF-GAME)
    (debug Taking ?loc out of the game)
)


; E-player-discard-from-hand
(defclass MAIN::E-player-discard-from-hand (is-a EVENT)
    (slot player (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes PLAYER))
    (slot card (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes OWNABLE))
)

(defrule MAIN::E-player-discard-from-hand (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-player-discard-from-hand) (type IN) 
        (player ?p) (card ?c))
    =>
    (send ?e complete)
    (send ?c put-state DISCARD)
    (debug Discarding ?c of ?p from hand)
)


; E-loc-phase
(defclass MAIN::E-loc-phase (is-a EVENT)
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot loc (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-loc-phase (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-loc-phase) (type IN) 
        (fell ?fell) (loc ?loc))
    =>
    (send ?e complete)
    (make-instance (gen-name EP-loc-phase) of EP-loc-phase (fell ?fell) (loc ?loc))
    (debug Beginning location phase for ?fell in ?loc)
)


; E-ally-play
(defclass MAIN::E-ally-play (is-a EVENT)
    (slot ally (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes ALLY))
    (slot char (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot loc (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)


(defrule MAIN::E-ally-play (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-ally-play) (type IN)
		(ally ?ally) (char ?char) (loc ?loc))
    =>
    (send ?e complete)
    (in-move ?ally ?char)
    (send ?ally put-state UNTAPPED)
    (send ?char put-state TAPPED)
    (send ?loc put-state TAPPED)
    (debug Playing ally ?ally under ?char)
)


; E-ally-play
(defclass MAIN::E-faction-play (is-a EVENT)
    (slot faction (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FACTION))
    (slot char (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot loc (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)


(defrule MAIN::E-faction-play (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-faction-play) (type IN)
		(faction ?faction) (char ?char) (loc ?loc))
    =>
    (send ?e complete)
    (send ?char put-state TAPPED)
    (make-instance (gen-name EP-faction-play) of EP-faction-play (faction ?faction) (char ?char) (loc ?loc))
    (debug Influencing faction ?faction by ?char in ?loc)
)


; E-convoque-council
(defclass MAIN::E-convoque-council (is-a EVENT))

(defrule MAIN::E-convoque-council (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-convoque-council) (type IN))
    =>
    (send ?e complete)
    (make-instance (gen-name EP-free-council) of EP-free-council)
)


; E-creature-attack-fell
(defclass MAIN::E-creature-attack-fell (is-a EVENT)
    (slot fell (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot creature (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CREATURE))
    (slot attack-at (visibility public) (type SYMBOL) (default ?NONE))
    (slot attack (visibility public) (type INSTANCE-NAME) (allowed-classes EP-attack))
)

(defrule MAIN::E-creature-attack-fell (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-creature-attack-fell) (type IN) 
        (fell ?fell) (creature ?creature) (attack-at ?attack-at))
    =>
    (send ?e complete)
    (in-move ?creature ?fell)
    (send ?creature put-state UNTAPPED)
    (send ?e put-attack (instance-name (make-instance (gen-name EP-attack) of EP-attack (fell ?fell) (attackable ?creature))))
    (debug Creature ?creature attacking ?fell at ?attack-at)
)

(defrule MAIN::E-creature-attack-fell#defeated (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-creature-attack-fell) (type OUT) 
        (creature ?creature) (attack ?at))
    (object (is-a EP-attack) (type OUT) (name ?at) (state DEFEATED))
    =>
    (send ?creature put-state MP)
    (debug Creature ?creature has been defeated, moving it to the player's MP)
)

(defrule MAIN::E-creature-attack-fell#undefeated (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-creature-attack-fell) (type OUT) 
        (creature ?creature) (attack ?at))
    (object (is-a EP-attack) (type OUT) (name ?at) (state UNDEFEATED))
    =>
    (send ?creature put-state DISCARD)
    (debug Creature ?creature has not been defeated, moving it to enemy's DISCARD)
)


; E-select-strike
(defclass MAIN::E-select-strike (is-a EVENT)
    (slot char (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot attackable (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes ATTACKABLE))
)


; E-select-strike
(defclass MAIN::E-strike (is-a EVENT)
    (slot char (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot attackable (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes ATTACKABLE))
    (slot decl-event (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes E-select-strike))
)

(defrule MAIN::E-strike (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-strike) (type IN) 
        (char ?char) (attackable ?attackable) (decl-event ?decl))
    =>
    (send ?e complete)
    (send ?decl complete)
    (make-instance (gen-name EP-strike) of EP-strike (char ?char) (attackable ?attackable))
    (debug Strike of ?attackable faced by ?char)
)


; E-select-strike
(defclass MAIN::E-face-strike-hindered (is-a EVENT)
    (slot strike (visibility public) (type INSTANCE-NAME) (default ?NONE) (allowed-classes EP-strike))
)

(defrule MAIN::E-face-strike-hindered (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-face-strike-hindered) (type IN) 
        (strike ?ep-strike))
    (player ?p)
    =>
    (send ?e complete)
    (send ?ep-strike put-hindered TRUE)
    (debug ?p chose to face the strike hindered)
)



; ; RECOLECTOR DE BASURA
; (defrule MAIN::event-garbage-collector (declare (auto-focus TRUE) 
; 		(salience ?*garbage-collector-salience*))
; 	; Destruye los eventos marcados como terminados
; 	?e <- (object (is-a EVENT | EVENT-PHASE) (type OUT))
; 	=>
; 	(send ?e delete)
; )