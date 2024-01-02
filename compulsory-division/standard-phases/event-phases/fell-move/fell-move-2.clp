;/////////////////// FELLWOSHIP MOVE 2: CALCULAR LIMITE ADVERSIDADES, CARTAS POR ROBAR E ITINERARIO ////////////////////////
(defmodule fell-move-2 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////INI
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))
(debug Calcular limite de adversidades, cartas por robar e itinerario))
;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*action-selection-salience*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule calculate-adversity-limit
    ?e<-(object (is-a EP-fell-move) (type ONGOING) (fell ?fell))
    (object (is-a CHARACTER) (name ?char) (race ?race))
    (in (over ?fell) (under ?char))
    =>
    (if (eq ?race HOBBIT) then
        (send ?e modify adversity-limit (+ 0.5 (send ?e get-adversity-limit)))
        else
        (send ?e modify adversity-limit (+ 1 (send ?e get-adversity-limit)))
    )
)

; ; DE BASE EL PLAYER-DRAW Y ENEMY-DRAW ES 0
; (defrule calculate-cards-to-draw#stay
;     ?e<-(object (is-a EP-fell-move) (type ONGOING) (fell ?fell) (from ?from) (to ?to&:(eq ?to ?from)))
;     =>
;     (send ?e modify player-draw 0)
;     (send ?e modify enemy-draw 0)
; )


; Calcula cuantas cartas debe robar cada jugador (no se roba si no se mueve)
(defrule calculate-cards-to-draw#move
    ?e<-(object (is-a EP-fell-move) (type ONGOING) (from ?from) (to ?to&:(neq ?to ?from)))
    =>
    (if (eq HAVEN (send ?to get-place)) then
        (send ?e modify player-draw (send ?from get-player-draw))
        (send ?e modify enemy-draw (send ?from get-enemy-draw))
        else
        (send ?e modify player-draw (send ?to get-player-draw))
        (send ?e modify enemy-draw (send ?to get-enemy-draw))
    )
)

; CALCULA LA RUTA TOMADA (no hay ruta si no se mueve)
(defrule calculate-route
    ?e<-(object (is-a EP-fell-move) (type ONGOING) (from ?from) (to ?to&:(neq ?to ?from)))
    =>
    ; Si se va a refugio
    (if (eq HAVEN (send ?to get-place)) then
        ; si ademas se viene de un refugio
        (if (eq HAVEN (send ?from get-place)) then
            ; ahora queda elegir que representa la conexion, si A o B

            (if (eq (send ?from get-site-pathA) ?to) then
                (send ?e modify route (send ?from get-routeA))
                else
                (send ?e modify route (send ?from get-routeB))  
            )
            else
            ; se va por la ruta de la carta fuente
            (send ?e modify route (send ?from get-route))
        )
        else  
        ; se va por la ruta de la carta destino      
        (send ?e modify route (send ?to get-route))
    )
)