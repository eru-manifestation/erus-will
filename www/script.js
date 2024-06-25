//let W3CWebSocket = require('websocket').w3cwebsocket;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const socket = io.connect(window.location.origin, { query: urlParams.toString() });
const dev = urlParams.get("dev")!=null;
let choice = [];
let player = undefined;

let closeUp, phase, game_space, locations, events, focusedLocation = "rivendell", focusedFellowship = "fellowship1";

document.getElementsByTagName('head')[0]
    .insertAdjacentHTML('beforeend',
        '<link rel="stylesheet" href="' + (dev ? 'dev-' : '') + 'styles.css" />');


function fire(title, text, icon) {
    Swal.fire({
        title: title,
        text: text,
        icon: icon,
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        timer: 3000
    })
}
function showChoiceDescription(e) {
    fire("Choose to:", e.target.getAttribute("choiceDescription"), "info");
}

function upcaseFirst(str) {
    if (["a", "an", "and", "of", "the", "or", "in", "out"].includes(str))
        return str;
    else return str.charAt(0).toUpperCase() + str.slice(1);
}

function classToImg(cls) {
    return cls.replaceAll("--", "")
        .split("-")
        .reduce((a, b) => a + upcaseFirst(b), "");
}

function cardClass(cls) {
    return cls.replaceAll("--", "\\")
        .split("-")
        .reduce((a, b) => a + " " + b, "")
        .replaceAll("\\", "-");
}

function makeElement(announce) {
    let id = announce.id;
    let fl = (focusedLocation === id) ? "location__focused" : "";
    let ff = (focusedFellowship === id) ? "fellowship__focused" : "";
    let classes = announce.classes;
    let res = `<div id=${id} class="${classes.reduce((a, b) => a + " " + b, "") + " " + fl + ff}"`;
    if (classes.includes("card"))
        res += ` card="${cardClass(classes[0])}" style=background-image:url('../tw/icons/${classToImg(classes[0])}.jpg')`;

    let map = new Map(Object.entries(announce));
    map.delete("operation");
    map.delete("id");
    map.delete("classes");
    map.delete("instance-#");
    map.delete("position");
    map.delete("motive") // El campo motivo de los data-item puede dar problemas en el arbol HTML

    if (classes.includes("event")) {
        map.set("reason", map.get("reason").split(" ")[0]);
        map.forEach((value, key) => res += ` ${key}=${value}`);
        res += ` draggable=true>`;
    } else {
        res += ` draggable=true>`;
        map.forEach((value, key) => res += `<div id="${id}__${key}" class="attribute ${key}" content=${value}></div>`);
    }
    res += "</div>";
    return res;
}

function insertingData(announce) {
    let msDelay = 0;
    let animationFunction;

    if (announce.position != "nil") {
        animationFunction = () =>
            document.getElementById(announce.position)
                .insertAdjacentHTML("beforeend", makeElement(announce));
    } else {
        if (announce.classes.includes("location")) {
            animationFunction = () =>
                locations.insertAdjacentHTML("beforeend", makeElement(announce));
        } else if (announce.classes.includes("event")) {
            msDelay = 0; // Los eventos hasta que se estilen ocurren de golpe
            animationFunction = () => {
                events.insertAdjacentHTML("beforeend", makeElement(announce));
            };
        } else {
            animationFunction = () =>
                game_space.insertAdjacentHTML("beforeend", makeElement(announce));
        }
    }

    return { msDelay, animationFunction };
}

function modifyElement(announce) {
    let msDelay = 20;
    let animationFunction = () => {
        let elementAtt = document.getElementById(announce.id + "__" + announce.slot);
        elementAtt.setAttribute("content", announce.value);
    };
    let element = document.getElementById(announce.id);
    let classes = element.classList;
    if (classes.contains("event")) {
        if(classes.contains("ep-dices") && announce.slot==="res" && element.getAttribute('state')==="EXEC"){
            // Estilos de generación del resultado de dados
            msDelay=2000;
            animationFunction = () => {
                let element = document.getElementById(announce.id);
                element.classList.add("resultRoll");
                element.setAttribute(announce.slot, announce.value);
                setTimeout(()=>element.classList.remove("resultRoll"),msDelay);
            };
        }else if(classes.contains("ep-dices") && announce.slot==="res" && element.getAttribute('state')==="DONE" && true){//TODO
            // Estilos de modificación de la tirada
            msDelay=1000;
            animationFunction = () => {
                let element = document.getElementById(announce.id);
                element.classList.add("modifyRoll");
                setTimeout(()=>element.setAttribute(announce.slot, announce.value),msDelay/3);
                setTimeout(()=>element.classList.remove("modifyRoll"),msDelay);
            };
        }else{

            msDelay = 0; // Para cambios en eventos sin estilar
            animationFunction = () => {
                let element = document.getElementById(announce.id);
                element.setAttribute(announce.slot, announce.value);
            };
        }
    }
    return { msDelay, animationFunction };
}



function emitSimpleChoice(event) {
    let classes = event.target.classList;
    if (classes.contains("location") && !classes.contains("location__focused")) {
        let lastLocation = document.getElementById(focusedLocation);
        if (lastLocation != null) lastLocation.classList.remove("location__focused");
        focusedLocation = event.target.id;
        classes.add("location__focused");

        let lastFellowship = document.getElementById(focusedFellowship);
        if (lastFellowship != null) lastFellowship.classList.remove("fellowship__focused");
        focusedFellowship = document.querySelector(`#${event.target.id}>.fellowship`).id;
        document.getElementById(focusedFellowship).classList.add("fellowship__focused");

    } else if (classes.contains("fellowship") && !classes.contains("fellowship__focused")) {
        let lastFellowship = document.getElementById(focusedFellowship);
        if (lastFellowship != null) lastFellowship.classList.remove("fellowship__focused");
        classes.add("fellowship__focused");
        focusedFellowship = event.target.id;
    } else {
        send_orders("[" + event.target.id + "]");
    }
    event.preventDefault();
    event.stopPropagation();
}


function removeAllChoiceStyles() {
    document.querySelectorAll(".choosable")
        .forEach((choosable) => choosable.classList.remove("choosable"));
    document.querySelectorAll(".choosable-final")
        .forEach((choosable) => {
            choosable.classList.remove("choosable-final");
            choosable.removeAttribute("choiceDescription");
            choosable.removeEventListener("dragenter", showChoiceDescription);
            choosable.removeEventListener("mouseenter", showChoiceDescription);
        });
}

function startComplexChoice(event) {
    let draggable = event.target;
    event.dataTransfer.setData("text/plain", draggable.id);
    removeAllChoiceStyles();

    choice
        .filter((singleChoice) => singleChoice.vector[0] === draggable.id & singleChoice.vector.length === 2)
        .forEach((singleChoice) => {
            let complexChoiceTarget = document.getElementById(singleChoice.vector[1])
            complexChoiceTarget.classList.add("choosable-final");
            complexChoiceTarget.setAttribute("choiceDescription", singleChoice.description);
            complexChoiceTarget.addEventListener("dragenter", showChoiceDescription);

            //TODO: Activar aquí el listener sólo para los que les interese?
        });
    event.stopPropagation();
}

function applyStyles() {
    choice
        .forEach((singleChoice) => {
            if (singleChoice.vector.length === 1) {
                let simpleChoiceTarget = document.getElementById(singleChoice.vector[0]);
                simpleChoiceTarget.classList.add("choosable-final");
                simpleChoiceTarget.setAttribute("choiceDescription", singleChoice.description);
                simpleChoiceTarget.addEventListener("mouseenter", showChoiceDescription);
            }
            else document.getElementById(singleChoice.vector[0]).classList.add("choosable");
        });
}

function restartStyles(event) {
    removeAllChoiceStyles();
    applyStyles();
    event.stopPropagation();
}

function completeComplexChoice(event) {
    if (event.dataTransfer.types.includes("text/plain")) {
        let data = "[" + event.dataTransfer.getData("text/plain") + "] [" + event.target.id + "]";
        send_orders(data);
    }
    prevention(event);
}

function dragInteractions(event) {
    let classes = event.target.classList;
    // Trigger World View
    if (event.target.id === "PASS") {
        document.getElementById(focusedLocation)?.classList.remove("location__focused");
        focusedLocation = null;
    // Change fellowship focus
    } else if (classes.contains("fellowship") && !classes.contains("fellowship__focused")) {
        setTimeout(() => {
            let lastFellowship = document.getElementById(focusedFellowship);
            if (lastFellowship != null) lastFellowship.classList.remove("fellowship__focused");
            classes.add("fellowship__focused");
            focusedFellowship = event.target.id;
        }, 1000);
    }
    prevention(event);
}

function prevention(event) {
    event.preventDefault();
    event.stopPropagation();
}

function send_orders(orders) {
    console.log("Orders: {" + orders + "}");
    socket.emit("orders", orders);
    orders.value = "";
    disableChoices();
}


function disableChoices() {
    removeAllChoiceStyles();

    document.querySelectorAll("*[draggable=true]").forEach(
        (draggable) => {
            draggable.removeEventListener("click", emitSimpleChoice);
            draggable.removeEventListener("dragstart", startComplexChoice);
            draggable.removeEventListener("dragend", restartStyles);
            draggable.removeEventListener("dragenter", dragInteractions);
            draggable.removeEventListener("dragover", prevention);
            draggable.removeEventListener("dragleave", prevention);
            draggable.removeEventListener("drop", completeComplexChoice);
        }
    );
}

function enableChoices() {
    applyStyles();

    document.querySelectorAll("*[draggable=true]").forEach(
        (draggable) => {
            draggable.addEventListener("click", emitSimpleChoice);
            draggable.addEventListener("dragstart", startComplexChoice);
            draggable.addEventListener("dragend", restartStyles);
            draggable.addEventListener("dragenter", dragInteractions);
            draggable.addEventListener("dragover", prevention);
            draggable.addEventListener("dragleave", prevention);
            draggable.addEventListener("drop", completeComplexChoice);
        }
    );
}

function animateAnnounce(announce) {
    return new Promise((resolve) => {
        if (announce != null)
            switch (announce.operation) {
                case "create":
                    operationData = insertingData(announce);
                    break;

                case "modify":
                    operationData = modifyElement(announce);
                    break;

                case "delete":
                    operationData.msDelay = 20;
                    operationData.animationFunction = () => document.getElementById(announce.id).remove();
                    break;

                case "move":
                    operationData.msDelay = 20;
                    operationData.animationFunction = () => {
                        let target = document.getElementById(announce.id);
                        if (target != null)
                            document.getElementById(announce.to).appendChild(target);
                    };
                    break;

                case "phase":
                    operationData.msDelay = 1020;
                    operationData.animationFunction = () => {
                        phase.firstChild.textContent = announce.description;
                        phase.classList.add("phaseanimation");
                        setTimeout(() => phase.classList.remove("phaseanimation"), 1000);
                    };
                    break;

                default:
                    console.error("error in operation type");
                    break;
            }
        else {
            operationData = { msDelay: 20, animationFunction: enableChoices };
        }
        operationData.animationFunction();
        setTimeout(resolve, operationData.msDelay);
    })
}

async function animate(announces) {
    for await (announce of announces) {
        await animateAnnounce(announce);
    }
}

function closeUpListener(e) {
    if (closeUp.style.display === "block") {
        closeUp.style.display = "none";
    } else if (e.button === 2 && e.target.classList.contains("card")) {
        closeUp.style.backgroundImage = `url("../tw/${classToImg(e.target.classList[0])}.jpg")`;
        closeUp.style.display = "block";
    }
}

document.addEventListener("DOMContentLoaded", () => {
    closeUp = document.getElementById("close-up");
    phase = document.getElementById("phase");
    game_space = document.getElementById("game-space");
    locations = document.getElementById("locations");
    events = document.querySelector(".events");

    window.addEventListener("mousedown", closeUpListener);
    document.addEventListener("contextmenu", (e) => e?.cancelable && e.preventDefault());

    socket.on("player", (playerN) => {
        console.log("Iniciando partida como " + playerN + (dev? " en modo desarrollador":""));
        player = playerN;
        const target = player === "player2" ?
            "#player2__hand, #hand1, #draw1, #discard1" :
            "#player1__hand, #hand2, #draw2, #discard2";
        if(!dev)
            document.styleSheets[0].insertRule(target + "{display:none !important;}");
    });

    socket.on("log", (data) => {
        console.log("Mensaje recibido:\n" + data);
    });

    socket.on("satm_error", (data) => {
        console.log("STAM error:\n" + data);
        console.log(data)
        msg = upcaseFirst(player)+": There is no available action associated to ";
        if(data.includes(" ")){
            let index = data.indexOf(" ")
            msg += "dragging "+data.substring(0,index)+" to "+data.substring(index);
        }else
            msg += data;
        fire("Invalid action", msg, "error");
        enableChoices();
    });

    socket.on("satm_ok", (data) => {
        data = JSON.parse(data);
        choice = data.choice.slice(0, -1);

        console.log("Choose:", data.choice);
        console.log("Announces:", data.announces);
        animate(data.announces);
    });

    socket.on("disconnect", (reason) => {
        alert("Conexión terminada: "+reason.toString());
        window.location.href = '/';
    });

});