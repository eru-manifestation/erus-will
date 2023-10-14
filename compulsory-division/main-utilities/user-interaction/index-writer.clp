(deffunction MAIN::upcase-first (?word)
    (sym-cat (str-cat (upcase (sub-string 1 1 ?word)) (sub-string 2 (str-length ?word) ?word)))
)



(deffunction MAIN::instance-name-to-file (?instance)
    ;Primera letra siempre en mayuscula
    (bind ?instance (upcase-first ?instance))
    ;Guion a espacio y doble guion desaparece porque la siguiente comienza en minuscula
    (bind ?instance (str-cat ?instance))
    (bind ?instance (str-replace ?instance "--" ""))
    (bind ?instance (str-replace ?instance "-" " "))
    ;Letra despues de espacio a mayuscula si su palabra no es "a an and the of or ..."
    ;Convertir "A fair travel in the border lands" en ("A" "fair" "travel" "in" "border" "lands")
    (println ?instance)
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
        (println "html" "<div class='level-" ?level " game-element' style=\"background-image: url('../tw/" (instance-name-to-file ?in:under) ".jpg');\">") 
        (update-under ?in:under (+ 1 ?level))
        (println "html" "</div>")
    )
)



; Escribe el archivo index.html
(deffunction MAIN::update-index ()
    (open "..\\..\\..\\www\\index.html" "html" "w")
    (println "html" "<!DOCTYPE html> <html lang='en-us'> <head> <meta charset='utf-8'> <meta name='viewport' content='width=device-width'> <title>CSS Grid starting point</title> <link rel='stylesheet' href='styles.css'> </head> <body> <h1>Simple grid example</h1> <div class='container'>")
    (do-for-all-instances ((?loc LOCATION)) (any-instancep ((?in in)) (eq ?in:over (instance-name ?loc)))
        (println "html" "<div class='level-0 game-element' style=\"background-image: url('../tw/" (instance-name-to-file ?loc) ".jpg');\">") 
        (update-under (instance-name ?loc) 1)
        (println "html" "</div>")
    )
)