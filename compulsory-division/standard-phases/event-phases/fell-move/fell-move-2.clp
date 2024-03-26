(defmodule fell-move-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule calculate-adversity-limit
    (object (is-a EP-fell-move) (active TRUE) (fellowship ?fell) (name ?fm))
    =>
    (E-modify ?fm hazard-limit (max 2 (send ?fell get-companions)) fell-move-2::calculate-adversity-limit)
)

; CALCULA LA RUTA TOMADA (no hay ruta si no se mueve)
(defrule calculate-route
    (object (is-a EP-fell-move) (active TRUE) (reason ~P-1-1-2-1::a-fell-decl-remain) (fellowship ?fell) (to ?to) (name ?fm))
    =>
    (bind ?from (send ?fell get-position))
    (bind ?route nil)
    ; Si se va a refugio
    (if (eq HAVEN (send ?to get-place)) then
        ; si ademas se viene de un refugio
        (if (eq HAVEN (send ?from get-place)) then
            ; ahora queda elegir que representa la conexion, si A o B

            (if (eq (send ?from get-site-pathA) ?to) then
                (bind ?route (send ?from get-routeA))
                ; else
                ; (bind ?route (send ?from get-routeB))  
            )
            else
            ; se va por la ruta de la carta fuente
            (bind ?route (send ?from get-route))
        )
        else  
        ; se va por la ruta de la carta destino      
        (bind ?route (send ?to get-route))
    )
    (E-modify ?fm route ?route fell-move-2::calculate-route)
)


; Calcula cuantas cartas debe robar cada jugador (no se roba si no se mueve)
(defrule calculate-cards-to-draw
	(object (is-a EP-fell-move) (active TRUE) (reason ~P-1-1-2-1::a-fell-decl-remain) (fellowship ?fell) (to ?to) (name ?fm))
    (object (is-a PLAYER) (name ?p))
    =>
    (bind ?draw 0)
    (bind ?player (send ?fell get-player))
	(bind ?from (send ?fell get-position))

    (if (eq ?p ?player) then
        (if (eq HAVEN (send ?to get-place)) then
            (bind ?draw (send ?from get-player-draw))
            else
            (bind ?draw (send ?to get-player-draw))
        )
        (E-modify ?fm player-draw ?draw fell-move-2::calculate-cards-to-draw)
        else
        (if (eq HAVEN (send ?to get-place)) then
            (bind ?draw (send ?from get-enemy-draw))
            else
            (bind ?draw (send ?to get-enemy-draw))
        )
        (E-modify ?fm enemy-draw ?draw fell-move-2::calculate-cards-to-draw)
    )
)