;/////////////////// FASE 0 1 1: EJECUCION ENDEREZAR PERSONAJES GIRADOS ////////////////////////
(defmodule EP-1 (import MAIN ?ALL))
;/////CLOCK
(defrule clock (declare (salience ?*clock-salience*)) => (tic (get-focus)))
;/////CAST
(defrule ini (declare (salience ?*universal-rules-salience*)) ?ini<-(ini) => (retract ?ini)
(foreach ?rule (get-defrule-list) (refresh ?rule))  (instances)
(debug Fase eventual mover compañía)(halt))
