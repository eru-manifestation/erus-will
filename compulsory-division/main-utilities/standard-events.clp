; E-card-untap
(defclass MAIN::E-card-untap (is-a EVENT)
    (slot card (type INSTANCE-NAME) (default ?NONE) (allowed-classes CARD))
)

(defrule MAIN::E-card-untap (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-card-untap) (type IN)
		(card ?c))
    =>
    (send ?e complete)
    (send ?c put-state UNTAPPED)

    (debug Untapping ?c)
)

; E-cure
(defclass MAIN::E-cure (is-a EVENT)
    (slot card (type INSTANCE-NAME) (default ?NONE))
)

(defrule MAIN::E-cure (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-cure) (type IN)
		(card ?c))
    =>
    (send ?e complete)
    (send ?c put-state TAPPED)

    (debug Healing ?c)
)


; E-char-play
(defclass MAIN::E-char-play (is-a EVENT)
    (slot card (type INSTANCE-NAME) (default ?NONE) (allowed-classes CARD))
    (slot under (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP CHARACTER))
)


(defrule MAIN::E-char-play (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-char-play) (type IN)
		(card ?c) (under ?u))
    =>
    (send ?e complete)
    (in-move ?c ?u)
    (send ?c put-state UNTAPPED)
    (debug Playing character ?c under ?u)
)


; E-item-transfer
(defclass MAIN::E-item-transfer (is-a EVENT)
    (slot item (type INSTANCE-NAME) (default ?NONE) (allowed-classes ITEM))
    (slot disposer (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot receiver (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    ; TODO: Puede un aliado tener un objeto??
)

(defrule MAIN::E-item-transfer (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-item-transfer) (type IN) 
        (item ?item) (receiver ?rec) (disposer ?disp))
    =>
    (send ?e complete)
    ;TODO: corruption check para ?disp
    (in-move ?item ?rec)

    (debug Transfering item ?item from ?rec to ?disp)
)


; E-item-store
(defclass MAIN::E-item-store (is-a EVENT)
    (slot item (type INSTANCE-NAME) (default ?NONE) (allowed-classes ITEM))
    (slot bearer (type INSTANCE-NAME) (default ?NONE) (allowed-classes CHARACTER))
    (slot haven (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-item-store (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-item-store) (type IN) 
        (item ?item) (bearer ?bearer) (haven ?haven))
    =>
    (send ?e complete)
    ;TODO: corruption check para ?bearer
    (send ?item put-state MP)
    ;TODO: Lo de arriba es así??? Hacer regla en 

    (debug Storing item ?item in ?haven by ?bearer)
)


; E-loc-organize
(defclass MAIN::E-loc-organize (is-a EVENT)
    (slot player (type INSTANCE-NAME) (default ?NONE) (allowed-classes PLAYER))
    (slot loc (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

(defrule MAIN::E-loc-organize (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-loc-organize) (type IN) 
        (player ?p) (loc ?loc))
    =>
    (send ?e complete)
    ;TODO: fase eventual de organización

    (debug Organizing fellowships of player ?p in ?loc)
)


; E-r-long-event-discard
(defclass MAIN::E-r-long-event-discard (is-a EVENT)
    (slot r-long-event (type INSTANCE-NAME) (default ?NONE) (allowed-classes R-LONG-EVENT))
)

(defrule MAIN::E-r-long-event-discard (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-r-long-event-discard) (type IN) 
        (r-long-event ?rle))
    =>
    (send ?e complete)
    (send ?rle put-state DISCARD)

    (debug Discarding long-event resoure ?rle)
)


; E-r-long-event-play
(defclass MAIN::E-r-long-event-play (is-a EVENT)
    (slot r-long-event (type INSTANCE-NAME) (default ?NONE) (allowed-classes R-LONG-EVENT))
)

(defrule MAIN::E-r-long-event-play (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-r-long-event-play) (type IN) 
        (r-long-event ?rle))
    =>
    (send ?e complete)
    ; TODO: Qué siginifica jugar un r-long event?
    (send ?rle put-state UNTAPPED)

    (debug Playing long-event resoure ?rle)
)


; E-a-long-event-discard
(defclass MAIN::E-a-long-event-discard (is-a EVENT)
    (slot a-long-event (type INSTANCE-NAME) (default ?NONE) (allowed-classes R-LONG-EVENT))
)

(defrule MAIN::E-a-long-event-discard (declare (auto-focus TRUE) (salience ?*event-handler-salience*))
    ?e <- (object (is-a E-a-long-event-discard) (type IN) 
        (a-long-event ?ale))
    =>
    (send ?e complete)
    ; TODO: Qué siginifica jugar un r-long event?
    (send ?ale put-state DISCARD)

    (debug Discarding long-event adversity ?ale)
)


; E-fell-decl-move
(defclass MAIN::E-fell-decl-move (is-a EVENT)
    (slot fell (type INSTANCE-NAME) (default ?NONE) (allowed-classes FELLOWSHIP))
    (slot from (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
    (slot to (type INSTANCE-NAME) (default ?NONE) (allowed-classes LOCATION))
)

