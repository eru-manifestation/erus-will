; HAVENS
(defclass MAIN::RIVENDELL (is-a HAVEN)
    (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
    (slot site-pathA (source composite) (default [lorien]))
    (slot site-pathB (source composite) (default [grey-havens]))
    (multislot routeA (source composite) (default (create$ WILDERNESS 3 BORDER-LAND 1)))
    (multislot routeB (source composite) (default (create$ WILDERNESS 2 FREE-LAND 1)))
)
(defclass MAIN::EDHELLOND (is-a HAVEN)
    (slot closest-haven (source composite) (default (symbol-to-instance-name edhellond)))
    (slot site-pathA (source composite) (default [lorien] ))
    (slot site-pathB (source composite) (default [grey-havens]))
    (multislot routeA (source composite) (default (create$ WILDERNESS 2 FREE-LAND 2 BORDER-LAND 2)))
    (multislot routeB (source composite) (default (create$ FREE-LAND 1 COAST 4 WILDERNESS 1)))
)
(defclass MAIN::GREY-HAVENS (is-a HAVEN)
    (slot closest-haven (source composite) (default (symbol-to-instance-name grey-havens)))
    (slot site-pathA (source composite) (default [rivendell] ))
    (slot site-pathB (source composite) (default [edhellond]))
    (multislot routeA (source composite) (default (create$ WILDERNESS 2 FREE-LAND 1)))
    (multislot routeB (source composite) (default (create$ FREE-LAND 1 COAST 4 WILDERNESS 1)))
)
(defclass MAIN::LORIEN (is-a HAVEN)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot site-pathA (source composite) (default [rivendell] ))
    (slot site-pathB (source composite) (default [edhellond]))
    (multislot routeA (source composite) (default (create$ WILDERNESS 3 BORDER-LAND 1)))
    (multislot routeB (source composite) (default (create$ WILDERNESS 2 FREE-LAND 2 BORDER-LAND 2)))
)

; OTHER LOCATIONS
(defclass MAIN::AMON-HEN (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 1))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default RUINS))
    (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1)))
)
(defclass MAIN::BAG-END (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 2))
    (slot place (source composite) (default FREE-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 2 FREE-LAND 1)))
)
(defclass MAIN::BANDIT-LAIR (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default RUINS))
    (multislot route (source composite) (default (create$ WILDERNESS 1 SHADOW-LAND 1)))
)
(defclass MAIN::BARAD-DUR (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 9))
    (slot player-draw (source composite) (default 3))
    (slot place (source composite) (default SHADOW-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 2 BORDER-LAND 1 FREE-LAND 1 SHADOW-LAND 1 DARK-LAND 1)))
)
(defclass MAIN::BARROW--DOWNS (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name rivendell)))
    (slot enemy-draw (source composite) (default 2))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default RUINS))
    (multislot route (source composite) (default (create$ WILDERNESS 2)))
)
(defclass MAIN::BEORNS-HOUSE (is-a LOCATION)
    (slot closest-haven (source composite) (default (symbol-to-instance-name lorien)))
    (slot enemy-draw (source composite) (default 1))
    (slot player-draw (source composite) (default 1))
    (slot place (source composite) (default FREE-HOLD))
    (multislot route (source composite) (default (create$ WILDERNESS 1 BORDER-LAND 1)))
)

(deffunction MAIN::init-locations ()
    (debug Starting locations)

    (make-instance rivendell of RIVENDELL)
    (make-instance edhellond of EDHELLOND)
    (make-instance grey-havens of GREY-HAVENS)
    (make-instance lorien of LORIEN)

    (make-instance amon-hen of AMON-HEN)
    (make-instance bag-end of BAG-END)
    (make-instance bandit-lair of BANDIT-LAIR)
    (make-instance barad-dur of BARAD-DUR)
    (make-instance barrow--downs of BARROW--DOWNS)
    (make-instance beorns-house of BEORNS-HOUSE)

    (debug Locations started)
)