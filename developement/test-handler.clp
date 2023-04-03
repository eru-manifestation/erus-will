(defclass clase (is-a USER)
    (slot propiedad (type INTEGER)
    (create-accessor ?NONE) (default 2))
)

(defmessage-handler clase get-propiedad primary ()
    3
)
(defrule r2 
    (object (is-a clase) (propiedad 2))
    =>
    (printout "Se imprime")
)
(defrule r3 
    (object (is-a clase) (propiedad 3))
    =>
    (printout "Se imprime")
)
(defrule r2-test
    (object (is-a clase) (name ?n))
    (test (eq 2 (send ?n get-propiedad)))
    =>
    (printout "Se imprime")
)
(defrule r3-test
    (object (is-a clase) (name ?n))
    (test (eq 3 (send ?n get-propiedad)))
    =>
    (printout "Se imprime")
)