; Conseguir que se de:
;   * En cada localización debe haber siempre una ÚNICA compañía vacía (para cada jugador):
;       - Al añadir un individuo a una compañía vacía, debe crearse otra vacía
;       - Al vaciarse una compañía, debe quedar solo 1 compañía vacía
;       - Las acciones del reglamento de juego deben siempre concernir solo a las compañías
;           con integrantes, lo cual debe ser fácilmente verificable y ser estable



(deffunction MAIN::gen-fell (?player ?location)
    (bind ?fell (gen-name FELLOWSHIP))
    (make-instance ?fell of FELLOWSHIP (player ?player) (position ?location))
)

(defrule MAIN::empty-fell-tagging (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (object (is-a FELLOWSHIP) (empty FALSE) (name ?fell))
    ; Cuidado, cualquier cosa que haya bajo una compañía lo invalida, no personajes solo
    (not (in (over ?fell)))
    =>
    (send ?fell modify empty TRUE)
)

(defrule MAIN::empty-fell-untagging (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (object (is-a FELLOWSHIP) (empty TRUE) (name ?fell))
    ; Cuidado, cualquier cosa que haya bajo una compañía lo invalida, no personajes solo
    (exists (in (over ?fell)))
    =>
    (send ?fell modify empty FALSE)
)


(defrule MAIN::empty-fell-creation (declare (auto-focus TRUE) (salience ?*universal-rules*))
    ; Por cada jugador en cada localización
    (object (is-a LOCATION) (name ?loc))
    (object (is-a PLAYER) (name ?p))
    
    ; Si o existe ningun elemento de localización directo entre la localización
    ; y una compañía del jugador
    (not (exists
        (object (is-a FELLOWSHIP) (position ?loc) (name ?fell) (player ?p) (empty TRUE))
    ))
    =>
    (message Creating empty fellowship for player ?p in ?loc)
    (gen-fell ?p ?loc)
)

(defrule MAIN::empty-fell-deletion (declare (auto-focus TRUE) (salience ?*universal-rules*))
    (object (is-a PLAYER) (name ?p))
    (object (is-a LOCATION) (name ?loc))
    (object (is-a FELLOWSHIP) (name ?fell)
        (player ?p) (empty TRUE) (position ?loc))
    (object (is-a FELLOWSHIP) (name ?other-fell&:(neq ?other-fell ?fell))
        (player ?p) (empty TRUE) (position ?loc))
    =>
    (message Deleting extra empty fellowship ?fell of player ?p in ?loc)
    (send ?other-fell delete)
)

