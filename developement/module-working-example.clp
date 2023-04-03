(clear)
(watch focus)
(watch rules)
(set-salience-evaluation when-activated)
(defmodule MAIN (export ?ALL))
(deftemplate fire
    (slot letter) (slot any))
(defmodule B (import MAIN ?ALL))
(defrule set-B (declare (auto-focus TRUE) )
    (fire (letter B))
    =>
)
(defrule print-B (declare (auto-focus FALSE)(salience (length$ (get-focus-stack))))
    (fire (letter B))
    =>
    (println Se imprime B)
    (pop-focus)
)
(defmodule C (import MAIN ?ALL))
(defrule set-C (declare (auto-focus TRUE))
    (fire (letter C))
    =>
)
(defrule print-C (declare (auto-focus FALSE)(salience (length$ (get-focus-stack))))
    (fire (letter C))
    =>
    (println Se imprime C)
    (pop-focus)
)