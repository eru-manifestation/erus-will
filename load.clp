(defmodule MAIN (export ?ALL))

(deffunction load-classes ()
    (and
        (load* "compulsory-division/main-utilities/classes/object-prelude.clp")
        (load* "compulsory-division/main-utilities/classes/objects.clp")
        
        ;locations
        (load* "compulsory-division/main-utilities/classes/locations.clp")

        ;other cards
        (load* "compulsory-division/main-utilities/classes/cards-def.clp")
        
        ;events
        (load* "compulsory-division/main-utilities/classes/event-class.clp")
    )
)

; Cargo el modulo main
(deffunction load-utilities ()
    (and
        ;global-constants
        (load* "compulsory-division/main-utilities/game-settings/global-constants.clp")

        ;interactions and debug
        (load* "compulsory-division/main-utilities/user-interaction/interaction.clp")

        (load-classes)

        ;game-settings
        (load* "compulsory-division/main-utilities/game-settings/game-settings.clp")

        ;in manager
        (load* "compulsory-division/main-utilities/in.clp")

        ;fellowship manager
        (load* "compulsory-division/main-utilities/fellowships.clp")

        ;events
        (load* "compulsory-division/main-utilities/events.clp")
        
        ;clock manager
        (load* "compulsory-division/main-utilities/clock.clp")

        ;action manager
        (load* "compulsory-division/main-utilities/user-interaction/actions.clp")
        ;(load* "compulsory-division/main-utilities/user-interaction/index-writer.clp")
        
        ;standard-events
        ;(load* "compulsory-division/main-utilities/standard-event-phases.clp")
        (load* "compulsory-division/main-utilities/standard-events.clp")

        
        ;data items
        (load* "compulsory-division/main-utilities/data-items.clp")
    )
)

(deffunction load-standard()
    (and
        (load* "compulsory-division/standard-phases/start-game-0.clp")
        (load* "compulsory-division/standard-phases/start-game-1.clp")

        (load* "compulsory-division/standard-phases/phase-0-1-1.clp")
        (load* "compulsory-division/standard-phases/phase-0-2-1.clp")
        (load* "compulsory-division/standard-phases/phase-1-1-1.clp")
        (load* "compulsory-division/standard-phases/phase-1-1-2-0.clp")
        (load* "compulsory-division/standard-phases/phase-1-1-2-1.clp")
        (load* "compulsory-division/standard-phases/phase-2-1-1.clp")
        (load* "compulsory-division/standard-phases/phase-2-2-1.clp")
        (load* "compulsory-division/standard-phases/phase-2-3-1.clp")
        (load* "compulsory-division/standard-phases/phase-3-1-1.clp")
        (load* "compulsory-division/standard-phases/phase-4.clp")
        (load* "compulsory-division/standard-phases/phase-5-1-1.clp")
        (load* "compulsory-division/standard-phases/phase-5-2-1.clp")
        (load* "compulsory-division/standard-phases/phase-5-3.clp")
        (load* "compulsory-division/standard-phases/phase-5-4.clp")
        ;(load* "compulsory-division/standard-phases/phase-5-5.clp")


        (load* "compulsory-division/standard-phases/event-phases/corruption-check/corruption-check-1-1-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/corruption-check/corruption-check-1-2.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/corruption-check/corruption-check-2.clp")

        (load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-2.clp")
        (load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-3-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-3-2.clp")
        (load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-3-3.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-4-0.clp")
        (load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-4-1.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-4-2.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-5-0.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-5-1.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-6.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/fell-move/fell-move-7.clp")

        (load* "compulsory-division/standard-phases/event-phases/draw/draw-0.clp")

        (load* "compulsory-division/standard-phases/event-phases/standarize-hand/standarize-hand-0.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/standarize-hand/standarize-hand-1.clp")

        (load* "compulsory-division/standard-phases/event-phases/loc-phase/loc-phase-1-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/loc-phase/loc-phase-2-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/loc-phase/loc-phase-3-1.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/loc-phase/loc-phase-4.clp")

        (load* "compulsory-division/standard-phases/event-phases/faction-play/faction-play-1-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/faction-play/faction-play-2-1.clp")

        (load* "compulsory-division/standard-phases/event-phases/free-council/free-council-1-0.clp")
        (load* "compulsory-division/standard-phases/event-phases/free-council/free-council-1-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/free-council/free-council-2-1.clp")

        ;(load* "compulsory-division/standard-phases/event-phases/attack/attack-0.clp")
        (load* "compulsory-division/standard-phases/event-phases/attack/attack-1.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/attack/attack-2-0.clp")
        (load* "compulsory-division/standard-phases/event-phases/attack/attack-2-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/attack/attack-2-2.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/attack/attack-2-3.clp")
        (load* "compulsory-division/standard-phases/event-phases/attack/attack-3.clp")
        (load* "compulsory-division/standard-phases/event-phases/attack/attack-4.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/attack/attack-5.clp")
        
        (load* "compulsory-division/standard-phases/event-phases/strike/strike-1-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/strike/strike-2.clp")
        (load* "compulsory-division/standard-phases/event-phases/strike/strike-3-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/strike/strike-3-2.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/strike/strike-4.clp")

        ;(load* "compulsory-division/standard-phases/event-phases/resistance-check/resistance-check-0.clp")
        (load* "compulsory-division/standard-phases/event-phases/resistance-check/resistance-check-1.clp")
        (load* "compulsory-division/standard-phases/event-phases/resistance-check/resistance-check-2.clp")
        ;(load* "compulsory-division/standard-phases/event-phases/resistance-check/resistance-check-3.clp")
    )
)

; Cargo todas los archivos
(deffunction load-all ()
    (set-strategy breadth)
    (and
        (load-utilities)
        (load-standard)
    )
)

(deffunction MAIN::debug ($?n)
    ; Despues del lanzamiento de esta funcion, se sobreescribira para no poder lanzarla mas
    (if (load-all) then
        (dribble-on (str-cat "debug/log" (expand$ ?n) ".txt"))
        (batch "debug/debug.clp")
    )
)
