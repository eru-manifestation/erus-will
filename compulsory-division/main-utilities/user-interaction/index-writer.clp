(deffunction MAIN::upcase-first (?word)
    (sym-cat (str-cat (upcase (sub-string 1 1 ?word)) (sub-string 2 (str-length ?word) ?word)))
)



(deffunction MAIN::instance-name-to-file (?instance)
    ;Elimina numero, utilizo el nombre de la clase
    (bind ?instance (lowcase (class ?instance)))
    ;Primera letra siempre en mayuscula
    (bind ?instance (upcase-first ?instance))
    ;Guion a espacio y doble guion desaparece porque la siguiente comienza en minuscula
    (bind ?instance (str-cat ?instance))
    (bind ?instance (str-replace ?instance "--" ""))
    (bind ?instance (str-replace ?instance "-" " "))
    ;Letra despues de espacio a mayuscula si su palabra no es "a an and the of or ..."
    ;Convertir "A fair travel in the border lands" en ("A" "fair" "travel" "in" "border" "lands")
    (bind ?instance (explode$ ?instance))
    (bind ?res (create$))
    (foreach ?word ?instance do
        (if (member$ (str-cat ?word) (create$ "a" "an" "and" "of" "the" "or" "in" "out")) then
            (bind ?res (insert$ ?res (+ 2 (length$ ?res)) ?word))
            else
            (bind ?res (insert$ ?res (+ 2 (length$ ?res)) (upcase-first ?word)))
        )
    )
    (bind ?res (implode$ ?res))
    (return (str-replace ?res " " ""))
)

(deffunction MAIN::update-under (?card ?level)
    (do-for-all-facts ((?in in)) 
        (and
            (eq ?in:transitive FALSE)
            (eq ?in:over ?card)
        )
        (bind ?game-element "")
        (bind ?style "")
        (if (not (member$ (class ?in:under) (create$ FELLOWSHIP PLAYER))) then 
            (bind ?game-element " game-element")
            (bind ?style (str-cat "style=\"background-image: url('../tw/" (instance-name-to-file ?in:under) ".jpg');\"")))
        (loop-for-count ?level (printout html tab))
        (printout html (str-cat "<div class='level-" ?level " " (class ?in:under) ?game-element "'" ?style ">") crlf) 
        (update-under ?in:under (+ 1 ?level))
        (loop-for-count ?level (printout html tab))
        (printout html "</div>" crlf)
    )
)



; Escribe el archivo index.html
(deffunction MAIN::update-index ()
    (open "www\\index.html" html "w")
    (printout html "<!DOCTYPE html> <html lang='en-us'> <head> <meta charset='utf-8'> <meta name='viewport' content='width=device-width'> <title>CSS Grid starting point</title> <link rel='stylesheet' href='styles.css'> </head> <body> <h1>Simple grid example</h1> <div class='container'>" crlf)
    (do-for-all-instances ((?loc LOCATION)) (any-factp ((?in in)) (and (eq ?in:transitive FALSE) (eq ?in:over (instance-name ?loc)) (eq (send ?in:under get-empty) FALSE)))
        (printout html "<div class='level-0 game-element' style=\"background-image: url('../tw/" (instance-name-to-file ?loc) ".jpg');\">" crlf) 
        (update-under (instance-name ?loc) 1)
        (printout html "</div>" crlf)
    )
    (printout html "</div> </body> </html>" crlf)
    (close html)
)