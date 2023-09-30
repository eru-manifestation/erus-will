# erus-will
A project dedicated to SATM

Para iniciar el juego, abrir el ejecutable load.bat

Seguir los pasos:
    * Cargar todos los elementos del juego: (load-all)

    * Iniciar localizaciones: (init-locations)

    * Iniciar mano de Gandalf: (init-handG)

    * Arrancar funcionamiento: (run)

Gestionar el modo debug en compulsory-division/main-utilities/game-settings/game-settings.clp


# GUIA DE DESARROLLO:

El sistema está dividido de forma que cada uno de las fases están expresadas declarativamente de forma que a cada subfase mínima se le asigna un módulo CLIPS en el que se ejecuten sus reglas. De esta forma se obtiene:

    I) Independencia en la ejecución de las fases: Las reglas de cada módulo solo pueden activarse si dicho módulo tiene el "foco". Esta estructura idea clips para separar el programa en tareas independientes con la capacidad de alternarse mediante llamadas. Con esto, se evita el uso de un elemento "fase" que itere con su valor entre los nombres de las distintas subfases del programa, lo cual resulta computacionalmente costoso en el algoritmo RETE que implementa CLIPS.

    II) Interactividad entre las fases: Si bien existen maneras de hacer que ciertos datos se mantengan propios y privados a cada fase (módulo CLIPS), existen elementos llamados "instancias", los cuales son propiamente instancias de clases CLIPS que se comparten en todo el "CLIPS enviroment".

    III) Mantener el panorama declarativo en términos de escalado: La razón principal para llevar a cabo este proyecto con CLIPS y no con un lenguaje de programación funcional más usual y de más fácil acceso (como Java, C, C++ o python) radica en la sencillez de adaptar el lenguaje humano al paradigma de programación declarativo. Este además permite la inserción de nuevos preceptos (o "reglas" CLIPS), conceptos (estructuras de datos como "template" o "class") que permiten al programa aumentar su capacidad de representación del problema (en este caso, sería aumentar la diversidad de elementos de juego) sin necesidad de reformar iterativamente la estructura del programa base (o juego con los elementos más básicos posibles).

# Mantener y estabilizar el flujo del programa con módulos
Si bien el sistema modular elegido es atractivo por las propiedades descritas anteriormente, son necesarios ciertos ajustes para conseguir un funcionamiento ajustado a las características desadas del programa, las cuales se resumen en:

    I) Existencia de un flujo principal del programa, que recorra todas las fases del juego en orden. Debe de ser lo suficientemente robusto como para no permitir errores en la selección de fase pero flexible a su vez para permitir pequeñas "trampas" o comportamientos disruptivos previstos con antelación por reglas futuramente añadidas.

    II) Capacidad de albergar un flujo temporal. No solo el juego debe fluir hacia adelante, sino hacia arriba a veces, implicando la existencia de lo que llamo "fases eventuales". Estas serían pequeños fragmentos de flujo del programa que se llaman arbitrariamente durante la ejecución del mismo. Una fase enventual debe ser concisa y tener una tarea firmemente definida, aceptar la división en varias subfases que la compongan, no disrumpir la estructura de datos o flujo subyacente, permitir a su vez la llamada de otras "fases eventuales" (hemos supuesto, siempre una diferente a la anterior y no repetida en la pila de foco actual), mantener el panorama declarativo (pues ciertos futuros elementos del programa podrán necesitar actuar en esas fases o incluso interactuar diréctamente con su flujo de ejecución) y devolver el foco a la fase o fase eventual que la llamó.

    III) Capacidad de ejecutar la tarea asignada a cada fase las veces que sea necesaria, permitiendo su reinicio, de ser necesario.

Después de varios intentos, pruebas y estimaciones se ha decidido llevar a cabo lo siguiente:

    * Hacer una estructura unificada que mantenga la integridad del flujo del programa "clock.clp", con herramientas para asegurar las funciones:
        - Avance del flujo del programa
        - Salto entre distintas fases del mismo
        - Reconocimiento de la fase actual
    
    * Confeccionar un elemento representativo de los datos a transmitir en el flujo de una fase eventual, ya que debe estar encapsulada en sí misma para no destruir la estructura de datos subyacente.



# Sobre el sistema de información

De la necesidad de adaptar el programa base a sus futuras (e impredecibles) expansiones surge el sistema de información pseudo-dinámico. Podemos dividir el modo en el que se recibe la información que posee el programa en dos partes fundamentales: consistente e inconsistente.

La información consistente es aquella que promueve una concepción fidedigna del estado del programa, donde se puede asimilar al estado de una partida real del juego de mesa.

La información inconsistente es obtenida disrumpiendo la ejecución de las reglas diseñadas para dar apoyo y coherencia al programa. Estas reglas acostumbran a ejecutarse independientemente del módulo que esté en acción al momento. Su función es crear un sistema de información estable y confiable en el que las demás reglas (las que añada el juego) puedan activarse sin temor a permanecer en un estado indeterminado, solo concebible en el mundo computacional y no el real. Un ejemplo de esto sería una regla que realice en un juego de última generación el ajuste gravitatorio de los personajes, en general, hablan de verdades que se suponen y evitan inconsistencias. Estan marcadas con la saliencia "?*universal-rules-salience*".

Como se puede atisbar según la división de información anterior, las reglas que forman la ejecución del programa están estratificadas según su propósito. De mayor prioridad a menor:
    * universal-rules: reglas para mantener la coherencia del sistema.
    * action-population: exclusivo para reglas con como único resultado la presentación al usuario de una posible acción a realizar.
    * action-selection: exclusivo para la interacción con el usuario. Debe ocurrir después de que se hayan propuesto todas las opciones para el jugador.
    * event-interception: mecanismo para intervenir eventos, tanto antes de haberse manejado como después.
    * event-handler: acción principal de un evento, para el cuál fue diseñado. Inicio de fases eventuales.
    * garbage-collector: mecanismo eliminador de eventos.
    * clock: Cambio de fase, con la menor saliencia para que toda acción ocurra antes de que se altere la fase en la que podrían ocurrir.
