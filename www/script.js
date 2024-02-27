//var W3CWebSocket = require('websocket').w3cwebsocket;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const socket = io.connect(window.location.origin,{query:urlParams.toString()});
const dev = urlParams.get("dev");
var choice = [];

var closeUp, game_space, locations, events;

document.getElementsByTagName('head')[0].insertAdjacentHTML('beforeend', '<link rel="stylesheet" href="'+(dev? 'dev-':'')+'styles.css" />');

function fire(title,text,icon){
    Swal.fire({
        title:title,
        text:text,
        icon:icon,
        toast:true,
        position: "top-end",
        showConfirmButton: false,
        timer:3000
    })
}
function showChoiceDescription(e){
    fire("Choose to:", e.target.getAttribute("choiceDescription"), "info");
}

function upcaseFirst(str){
    if (["a","an","and","of","the","or","in","out"].includes(str))
        return str;
    else return str.charAt(0).toUpperCase() + str.slice(1);
}

function classToImg(cls){
    return cls.replaceAll("--","").split("-").reduce((a,b)=>a+upcaseFirst(b),"");
}

function makeElement(announce){
    var id = announce.id;
    var classes = announce.classes;
    var res = `<div id=${id} class="${classes.reduce((a,b)=>a+" "+b,"")}"`;
    if(classes.includes("card"))
        res+=`style=background-image:url('../tw/icons/${classToImg(classes[0])}.jpg')`;
    
    var map = new Map(Object.entries(announce));
    map.delete("operation");
    map.delete("id");
    map.delete("classes");
    map.delete("instance-#");
    map.delete("position");

    if(classes.includes("event")){
        map.delete("reason");
        map.forEach((value,key) => res+=` ${key}=${value}`);
        res += ` draggable=true>`;
    }else{
        res += ` draggable=true>`;
        map.forEach((value,key) => res+=`<div id="${id}__${key}" class="attribute ${key}"><span>${value}</span></div>`);
    }
    res += "</div>";
    return res;
}

function insertingData(announce){
    var msDelay = 20;
    var animationFunction;
    
    if(announce.position != "[nil]"){
        animationFunction = () => 
            document.getElementById(announce.position)
            .insertAdjacentHTML("beforeend", makeElement(announce));
    }else{
        if(announce.classes.includes("location")){
            animationFunction = () => 
                locations.insertAdjacentHTML("beforeend", makeElement(announce));
        }else if(announce.classes.includes("event")){
            msDelay = 1000 + msDelay;
            animationFunction = () => {
                events.insertAdjacentHTML("beforeend", makeElement(announce));
                var element = document.getElementById(announce.id);
                element.classList.add("eventppanimation");
                setTimeout(() => element.classList.remove("eventppanimation"), msDelay);
            };
        } else {
            animationFunction = () =>
                game_space.insertAdjacentHTML("beforeend", makeElement(announce));
        }
    }

    return {msDelay, animationFunction};
}

function modifyElement(announce){
    var msDelay = 20;
    var animationFunction = () => {
        var elementAtt = document.getElementById(announce.id+"__"+announce.slot).firstChild;
        elementAtt.textContent = announce.value;
    };
    // TODO: cambiar
    if (announce.id.includes("e-phase") || announce.id.includes("e-modify")){
        animationFunction = () => {
            var element = document.getElementById(announce.id);
            element.setAttribute(announce.slot,announce.value);
        };
    }
    return {msDelay, animationFunction};
}



function emitSimpleChoice(event){
    send_orders(event.target.id);
    event.preventDefault();
    event.stopPropagation();
}


function removeAllChoiceStyles(){
    document.querySelectorAll(".choosable")
        .forEach((choosable)=>choosable.classList.remove("choosable"));
    document.querySelectorAll(".choosable-final")
        .forEach((choosable)=>{
            choosable.classList.remove("choosable-final");
            choosable.removeAttribute("choiceDescription");
            choosable.removeEventListener("dragenter", showChoiceDescription);
            choosable.removeEventListener("mouseenter", showChoiceDescription);
        });
}

function startComplexChoice(event){
    var draggable = event.target;
    event.dataTransfer.setData("text/plain", draggable.id);
    removeAllChoiceStyles();

    choice
    .filter((singleChoice) => singleChoice.vector[0]===draggable.id & singleChoice.vector.length===2)
    .forEach((singleChoice) => {
        var complexChoiceTarget = document.getElementById(singleChoice.vector[1])
        complexChoiceTarget.classList.add("choosable-final");
        complexChoiceTarget.setAttribute("choiceDescription",singleChoice.description);
        complexChoiceTarget.addEventListener("dragenter", showChoiceDescription);

        //TODO: Activar aquí el listener sólo para los que les interese?
    });
    event.stopPropagation();
}

function applyStyles(){
    choice
    .forEach((singleChoice)=>{
        if(singleChoice.vector.length===1) {
            var simpleChoiceTarget = document.getElementById(singleChoice.vector[0]);
            simpleChoiceTarget.classList.add("choosable-final");
            simpleChoiceTarget.setAttribute("choiceDescription",singleChoice.description);
            simpleChoiceTarget.addEventListener("mouseenter", showChoiceDescription);
        }
        else document.getElementById(singleChoice.vector[0]).classList.add("choosable");
    });
}

function restartStyles(event){
    removeAllChoiceStyles();
    applyStyles();
    event.stopPropagation();
}

function completeComplexChoice(event){
    if (event.dataTransfer.types.includes("text/plain")){
        var data = event.dataTransfer.getData("text/plain")+" "+event.target.id;
        send_orders(data);
    }
    event.stopPropagation();
    event.preventDefault();
}

function prevention(event){
    event.preventDefault();
    event.stopPropagation();
}

function send_orders(orders){
    console.log("Orders: {"+orders+"}");
    socket.emit("orders",orders);
    orders.value="";
    disableChoices();
}


function disableChoices(){
    removeAllChoiceStyles();

    document.querySelectorAll("*[draggable=true]").forEach(
        (draggable) => {
            draggable.removeEventListener("click", emitSimpleChoice);
            draggable.removeEventListener("dragstart", startComplexChoice);
            draggable.removeEventListener("dragend", restartStyles);
            draggable.removeEventListener("dragenter", prevention);
            draggable.removeEventListener("dragover", prevention);
            draggable.removeEventListener("dragleave", prevention);
            draggable.removeEventListener("drop", completeComplexChoice);
        }
    );
}

function enableChoices(){
    applyStyles();

    document.querySelectorAll("*[draggable=true]").forEach(
        (draggable) => {
            draggable.addEventListener("click", emitSimpleChoice);
            draggable.addEventListener("dragstart", startComplexChoice);
            draggable.addEventListener("dragend", restartStyles);
            draggable.addEventListener("dragenter", prevention);
            draggable.addEventListener("dragover", prevention);
            draggable.addEventListener("dragleave", prevention);
            draggable.addEventListener("drop", completeComplexChoice);
        }
    );
}


function animate(announces){
    var accumDelay = 0;
    var operationData;

    announces.forEach((announce) => {
        if(announce!=null)
            switch(announce.operation){
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
                        const target = document.getElementById(announce.id);
                        if (target != null)
                            document.getElementById(announce.to).appendChild(target);
                    };
                    break;

                default:
                    console.error("error in operation type");
                    break;
            }
        else {
            operationData = {msDelay : 20, animationFunction : enableChoices};
        }
        setTimeout(operationData.animationFunction, accumDelay);
        accumDelay += operationData.msDelay;
    });
}

function closeUpListener(e){
    if(closeUp.style.display === "block"){
        closeUp.style.display = "none";
    } else if(e.button === 2 && e.target.classList.contains("card")){
        closeUp.style.backgroundImage = `url("../tw/${classToImg(e.target.classList[0])}.jpg")`;
        closeUp.style.display = "block";
    }
}

document.addEventListener("DOMContentLoaded", ()=>{
    closeUp = document.getElementById("close-up");
    game_space = document.getElementById("game-space");
    locations = document.getElementById("locations");
    events = document.querySelector(".events");

    window.addEventListener("mousedown", closeUpListener)
    document.addEventListener("contextmenu", (e)=>e?.cancelable && e.preventDefault())

    socket.on("log", (data)=>{
        console.log("Mensaje recibido:\n"+data);
    });

    socket.on("satm_error", (data)=>{
        console.log("STAM error:\n"+data);
        fire("Invalid action", data, "error");
        enableChoices();
    });

    socket.on("satm_ok", (data)=>{
        data = JSON.parse(data);
        choice = data.choice.slice(0,-1);
        
        console.log("Choose:", data.choice);
        console.log("Announces:", data.announces);
        animate(data.announces);
    });

});