(defclass clase (is-a USER)
    (slot propiedad (type INTEGER) (default 2))
)

(defrule if-cierto-+1
    (logical 
        (cierto)
        (object (is-a clase) (name ?n))
    )
    =>
    ; Vemos que se retracta el hecho pero no se deshace el cambio al modificar
    ; la estadística
    (assert (escierto))
    (send ?n put-propiedad (+ 1 (send ?n get-propiedad)))
)