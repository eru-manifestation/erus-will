
; INICIO
(defclass LOCATION (is-a USER))
(defclass RIVENDELL (is-a LOCATION))
(defclass SHIRE (is-a LOCATION))
(make-instance rivendell of RIVENDELL)
(make-instance shire of SHIRE)
(defclass PLAYER (is-a USER))
(make-instance p1 of PLAYER)
(make-instance p2 of PLAYER)
(defclass FELLOWSHIP (is-a USER) 
    (slot player (type INSTANCE-NAME)) 
    (slot empty (type SYMBOL))
) 
(make-instance f1 of FELLOWSHIP (player [p1]) (empty TRUE))
(deftemplate in (slot over (type INSTANCE-NAME)) (slot under (type INSTANCE-NAME)))
;(assert (in (over [rivendell]) (under [f1])))

(defrule regla1
    (object (is-a LOCATION) (name ?location))
    (object (is-a PLAYER)  (name ?player))
    (not (in (over ?location) (under ?fell&:(and
        (eq (send ?fell get-empty) TRUE)
        (eq (send ?fell get-player) ?player)
    ))))
    =>
    (printout t "Creando compañía de " ?player " en " ?location crlf)
); FIN