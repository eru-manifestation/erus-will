;/////////////////// FASE 0 1 1: EJECUCION ENDEREZAR PERSONAJES GIRADOS ////////////////////////
(defmodule EP-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule cast (declare (salience ?*universal-rules-salience*)) =>  (instances)
(announce (sym-cat DEV - (get-focus)) Fase eventual mover compañía)(halt))
