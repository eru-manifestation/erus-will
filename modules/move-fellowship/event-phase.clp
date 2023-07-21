(defclass TOOLS::MOVE-FELLOWSHIP-EP (is-a EVENT-PHASE)
    (slot fell (type INSTANCE-NAME) (allowed-classes FELLOWSHIP) (default ?NONE))
    (slot from (type INSTANCE-NAME) (allowed-classes LOCATION) (default ?NONE))
)
