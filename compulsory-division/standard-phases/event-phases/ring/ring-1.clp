(defmodule ring-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock*)) => (tic))

;/////ACTION MANAGEMENT
(defrule choose-action (declare (salience ?*a-selection*))
	?inf<-(infinite) (object (is-a PLAYER) (name ?p)) (exists (action (player ?p))) => 
	(retract ?inf) (assert (infinite)) (collect-actions ?p))


(defrule roll-dices => (E-roll-dices ring-test-roll ring-1::roll-dices))

; TODO: TESTING
(defrule a-play-magic-ring (declare (salience ?*a-population*))
	(logical
		(object (is-a EP-ring) (state EXEC) (ring ?ring))
		(object (is-a EP-ring-test-roll) (state DONE) (name ?dices))
		(object (name ?ring) (magic-ring ?mr))
		(object (is-a MAGIC-RING) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p)))
			(name ?magic-ring))
		(test (eq ?p (send ?ring get-player)))
		(test (<= (send ?dices get-res) ?mr))
	)
	=>
	(assert (action
		(player ?p)
		(event-def play)
		(description (sym-cat "Jugar anillo magico " ?magic-ring))
		(identifier ?magic-ring)
		(data ?magic-ring (send ?ring get-position)) 
		(reason ring-1::a-play-magic-ring)
	))
)

(defrule a-play-dwarven-ring (declare (salience ?*a-population*))
	(logical
		(object (is-a EP-ring) (state EXEC) (ring ?ring))
		(object (is-a EP-ring-test-roll) (state DONE) (name ?dices))
		(object (name ?ring) (dwarven-ring ?dr))
		(object (is-a DWARVEN-RING) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p)))
			(name ?dwarven-ring))
		(test (eq ?p (send ?ring get-player)))
		(test (>= (send ?dices get-res) ?dr))
	)
	=>
	(assert (action
		(player ?p)
		(event-def play)
		(description (sym-cat "Jugar anillo enano " ?dwarven-ring))
		(identifier ?dwarven-ring)
		(data ?dwarven-ring (send ?ring get-position)) 
		(reason ring-1::a-play-dwarven-ring)
	))
)

(defrule a-play-the-one-ring (declare (salience ?*a-population*))
	(logical
		(object (is-a EP-ring) (state EXEC) (ring ?ring))
		(object (is-a EP-ring-test-roll) (state DONE) (name ?dices))
		(object (name ?ring) (one-ring ?or))
		(object (is-a THE-ONE-RING) (player ?p) (position ?pos&:(eq ?pos (handsymbol ?p)))
			(name ?one-ring))
		(test (eq ?p (send ?ring get-player)))
		(test (>= (send ?dices get-res) ?or))
	)
	=>
	(assert (action
		(player ?p)
		(event-def play)
		(description (sym-cat "Jugar El Anillo Unico"))
		(identifier ?one-ring)
		(data ?one-ring (send ?ring get-position)) 
		(reason ring-1::a-play-the-one-ring)
	))
)

(defrule a-lesser-ring (declare (salience ?*a-population*))
	(logical
		(object (is-a EP-ring) (state EXEC) (ring ?ring))
		(object (is-a EP-ring-test-roll) (state DONE))
		(object (name ?ring) (player ?p) (position ?pos))
		(not (object (is-a STACK) (name ?pos)))
	)
	=>
	(assert (action
		(player ?p)
		(event-def discard)
		(description (sym-cat "Descartar el anillo, es solo un anillo menor"))
		(identifier PASS)
		(data ?ring) 
		(reason ring-1::a-lesser-ring)
		(blocking TRUE)
	))
)



(defrule EI-discard-ring (declare (salience ?*E-intercept*))
	?ep <- (object (is-a EP-ring) (state EXEC-HOLD) (ring ?ring))
    ?e <- (object (is-a E-play) (position ?ep) (active TRUE) (target ?si))
	(object (is-a SPECIAL-ITEM) (name ?si))
    (not (object (is-a EVENT) (position ?e) (reason ring-1::EI-discard-ring)))
	=>
	(message "El anillo de oro se ha transformado")
	(E-discard ?ring ring-1::EI-discard-ring)
)