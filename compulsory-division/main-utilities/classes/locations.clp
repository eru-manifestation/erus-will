; HAVENS
(defclass MAIN::RIVENDELL (is-a HAVEN)
    (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
    (slot site-pathA (source composite) (default [lorien]))
    ;(slot site-pathB (source composite) (default [grey-havens]))
    (multislot routeA (source composite) (default (create$ WILDERNESS 3 BORDER-LAND 1)))
    ;(multislot routeB (source composite) (default (create$ WILDERNESS 2 FREE-LAND 1)))
)
; (defclass MAIN::EDHELLOND (is-a HAVEN)
;     (slot closest-haven (source composite) (default (symbol-to-instance-name edhellond)))
;     (slot site-pathA (source composite) (default [lorien] ))
;     (slot site-pathB (source composite) (default [grey-havens]))
;     (multislot routeA (source composite) (default (create$ WILDERNESS 2 FREE-LAND 2 BORDER-LAND 2)))
;     (multislot routeB (source composite) (default (create$ FREE-LAND 1 COAST 4 WILDERNESS 1)))
; )
; (defclass MAIN::GREY-HAVENS (is-a HAVEN)
;     (slot closest-haven (source composite) (default (symbol-to-instance-name grey-havens)))
;     (slot site-pathA (source composite) (default [rivendell] ))
;     (slot site-pathB (source composite) (default [edhellond]))
;     (multislot routeA (source composite) (default (create$ WILDERNESS 2 FREE-LAND 1)))
;     (multislot routeB (source composite) (default (create$ FREE-LAND 1 COAST 4 WILDERNESS 1)))
; )
(defclass MAIN::LORIEN (is-a HAVEN)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot site-pathA (source composite) (default [rivendell]))
    ;(slot site-pathB (source composite) (default [edhellond]))
    (multislot routeA (source composite) (default (create$ WILDERNESS 3 BORDER-LAND 1)))
    ;(multislot routeB (source composite) (default (create$ WILDERNESS 2 FREE-LAND 2 BORDER-LAND 2)))
)

; OTHER LOCATIONS
; (defclass MAIN::AMON-HEN (is-a LOCATION)
;     (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
;     (slot enemy-draw (source composite) (default 1))
;     (slot player-draw (source composite) (default 1))
;     (slot place (source composite) (default RUINS))
;     (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1)))
;     ;(multislot automatic-attacks (source composite) (default [attackable-amon-hen]))
;     (multislot playable-items (source composite) (default MINOR-ITEM))
; )
; (defclass MAIN::BAG-END (is-a LOCATION)
;     (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
;     (slot enemy-draw (source composite) (default 2))
;     (slot player-draw (source composite) (default 2))
;     (slot place (source composite) (default FREE-HOLD))
;     (multislot route (source composite) (default (create$ WILDERNESS 2 FREE-LAND 1)))
; )
; (defclass MAIN::BANDIT-LAIR (is-a LOCATION)
;     (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
;     (slot enemy-draw (source composite) (default 2))
;     (slot player-draw (source composite) (default 1))
;     (slot place (source composite) (default RUINS))
;     (multislot route (source composite) (default (create$ WILDERNESS 1 SHADOW-LAND 1)))
;     ;(multislot automatic-attacks (source composite) (default [attackable-bandit-lair]))
;     (multislot playable-items (source composite) (default MINOR-ITEM))
; )
; (defclass MAIN::BARAD-DUR (is-a LOCATION)
;     (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
;     (slot enemy-draw (source composite) (default 9))
;     (slot player-draw (source composite) (default 3))
;     (slot place (source composite) (default SHADOW-HOLD))
;     (multislot route (source composite) (default (create$ WILDERNESS 2 BORDER-LAND 1 FREE-LAND 1 SHADOW-LAND 1 DARK-LAND 1)))
;     ;(multislot automatic-attacks (source composite) (default [attackable-barad-dur1] [attackable-barad-dur2]))
;     (multislot playable-items (source composite) (default MINOR-ITEM MAJOR-ITEM GREATER-ITEM))
; )
(defclass MAIN::BARROW--DOWNS (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default RUINS))
    (multislot route (source composite) (default (create$ WILDERNESS 2)))
    ;(multislot automatic-attacks (source composite) (default (create$ [attackable-barrow--downs1])))
    (multislot playable-items (source composite) (default MINOR-ITEM MAJOR-ITEM))
)
; (defclass MAIN::BEORNS-HOUSE (is-a LOCATION)
;     (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
;     (slot enemy-draw (source composite) (default 1))
;     (slot player-draw (source composite) (default 1))
;     (slot place (source composite) (default FREE-HOLD))
;     (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1)))
; )
(defclass MAIN::DUNNISH-CLAN--HOLD (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 2))
    (slot place (source composite) (default BORDER-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 3)))
)
(defclass MAIN::BREE (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
    (slot enemy-draw (source composite) (default 1))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default BORDER-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 2)))
)
(defclass MAIN::GOBLIN--GATE (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default SHADOW-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 2)))
    (multislot playable-items (source composite) (default MINOR-ITEM GOLD-RING))
)
(defclass MAIN::ISENGARD (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 2))
    (slot place (source composite) (default RUINS))
    (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 2)))
    (multislot playable-items (source composite) (default MINOR-ITEM MAJOR-ITEM GOLD-RING))
)
(defclass MAIN::WELLINGHALL (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 1))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default FREE-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 2)))
)
(defclass MAIN::EDORAS (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 1))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default FREE-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1)))
)
(defclass MAIN::MINAS-TIRITH (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 2))
    (slot place (source composite) (default FREE-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1 FREE-LAND 1)))
)
(defclass MAIN::DEAD-MARSHES (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 3))
    (slot player-draw (source composite) (default 2))
    (slot place (source composite) (default SHADOW-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 1 SHADOW-LAND 2)))
    (multislot playable-items (source composite) (default MINOR-ITEM MAJOR-ITEM GREATER-ITEM))
)
(defclass MAIN::THRANDUILS-HALLS (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 2))
    (slot place (source composite) (default FREE-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 2)))
)
(defclass MAIN::MOUNT-GUNDABAD (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 3))
    (slot player-draw (source composite) (default 2))
    (slot place (source composite) (default SHADOW-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1 DARK-LAND 1)))
    (multislot playable-items (source composite) (default MINOR-ITEM MAJOR-ITEM GREATER-ITEM))
)
(defclass MAIN::MORIA (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 3))
    (slot player-draw (source composite) (default 2))
    (slot place (source composite) (default SHADOW-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 2)))
    (multislot playable-items (source composite) (default MINOR-ITEM MAJOR-ITEM GREATER-ITEM GOLD-RING))
)

(deffunction MAIN::init-locations ()
    (message Starting locations)
    
    ; ATAQUES AUTOMATICOS

    ; (make-instance attackable-amon-hen1 of ATTACKABLE (race UNDEAD) (prowess 6))

    ; (make-instance attackable-bandit-lair1 of ATTACKABLE (race MAN) (prowess 6) (strikes 3))

    ; (make-instance attackable-barad-dur1 of ATTACKABLE (race ORC) (prowess 7) (strikes 4))
    ; (make-instance attackable-barad-dur2 of ATTACKABLE (race TROLL) (prowess 9) (strikes 3))

    (make-instance attackable-barrow--downs of ATTACKABLE (race UNDEAD) (prowess 8))
    (make-instance attackable-goblin--gate of ATTACKABLE (race ORC) (prowess 6) (strikes 3))
    (make-instance attackable-isengard of ATTACKABLE (race WOLF) (prowess 7) (strikes 3))
    (make-instance attackable-dead-marshes of ATTACKABLE (race ORC) (prowess 8) (strikes 2))
    (make-instance attackable-gundabad of ATTACKABLE (race ORC) (prowess 8) (strikes 2))
    (make-instance attackable-moria of ATTACKABLE (race ORC) (prowess 7) (strikes 4))

    ; LOCALIZACIONES

    (make-instance rivendell of RIVENDELL)
    ; (make-instance edhellond of EDHELLOND)
    ; (make-instance grey-havens of GREY-HAVENS)
    (make-instance lorien of LORIEN)

    ; (make-instance amon-hen of AMON-HEN)
    ; (send [amon-hen] put-automatic-attacks [attackable-amon-hen1])
    ; (make-instance bag-end of BAG-END)
    ; (make-instance bandit-lair of BANDIT-LAIR)
    ; (send [bandit-lair] put-automatic-attacks [attackable-bandit-lair1])
    ; (make-instance barad-dur of BARAD-DUR)
    ; (send [barad-dur] put-automatic-attacks [attackable-barad-dur1] [attackable-barad-dur2])
    (make-instance barrow--downs of BARROW--DOWNS (automatic-attacks [attackable-barrow--downs]))
    ; (send [barrow--downs] put-automatic-attacks [attackable-barrow--downs1])
    ; (make-instance beorns-house of BEORNS-HOUSE)

    (make-instance dunnish-clan--hold of DUNNISH-CLAN--HOLD)
    (make-instance bree of BREE)
    (make-instance goblin--gate of GOBLIN--GATE (automatic-attacks [attackable-goblin--gate]))
    (make-instance isengard of ISENGARD (automatic-attacks [attackable-isengard]))
    (make-instance wellinghall of WELLINGHALL)
    (make-instance edoras of EDORAS)
    (make-instance minas-tirith of MINAS-TIRITH)
    (make-instance dead-marshes of DEAD-MARSHES (automatic-attacks [attackable-dead-marshes]))
    (make-instance thranduils-halls of THRANDUILS-HALLS)
    (make-instance mount-gundabad of MOUNT-GUNDABAD (automatic-attacks [attackable-gundabad]))
    (make-instance moria of MORIA (automatic-attacks [attackable-moria]))


    (message Locations started)
)