;/////////////////// FELLWOSHIP MOVE 2: CALCULAR LIMITE ADVERSIDADES, CARTAS POR ROBAR E ITINERARIO ////////////////////////
(defmodule fell-move-2 (import MAIN ?ALL) (import fell-move-1 ?ALL) (export ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic (get-focus)))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule calculate-adversity-limit
    (data (data fellowship ?fell))
    =>
    (assert (data (data hazard-limit (max 2 (send ?fell get-companions)))))
)

; CALCULA LA RUTA TOMADA (no hay ruta si no se mueve)
(defrule calculate-route
    (data (data fellowship ?fell))
    (data (data to ?to))
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
                else
                (bind ?route (send ?from get-routeB))  
            )
            else
            ; se va por la ruta de la carta fuente
            (bind ?route (send ?from get-route))
        )
        else  
        ; se va por la ruta de la carta destino      
        (bind ?route (send ?to get-route))
    )
    (assert (data (data route ?route)))
)


; Calcula cuantas cartas debe robar cada jugador (no se roba si no se mueve)
(defrule calculate-cards-to-draw
	(data (data fellowship ?fell))
	(data (data to ?to))
    =>
    (bind ?player (send ?fell get-player))
    (bind ?enemy (enemy ?player))
	(bind ?from (send ?fell get-position))

    (if (eq HAVEN (send ?to get-place)) then
        (assert (data (data draw-ammount (send ?from get-player-draw) ?player)))
        (assert (data (data draw-ammount (send ?from get-enemy-draw) ?enemy)))
        else
        (assert (data (data draw-ammount (send ?to get-player-draw) ?player)))
        (assert (data (data draw-ammount (send ?to get-enemy-draw) ?enemy)))
    )
)

(defrule populate-draw-ammount
    (data (data draw-ammount ?n&:(< 1 ?n) ?p))
    =>
    (assert (data (data draw-ammount (- ?n 1) ?p)))
)