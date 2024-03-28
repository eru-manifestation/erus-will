//let W3CWebSocket = require('websocket').w3cwebsocket;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const socket = io.connect(window.location.origin,{query:urlParams.toString()});
const dev = urlParams.get("dev");
let choice = [];

let closeUp, phase, game_space, locations, events, focusedLocation = "[rivendell]", focusedFellowship = "[fellowship1]";

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
    let id = announce.id;
    let fl = (focusedLocation===id)? "location__focused" : ""; // TODO: mejorar un poco
    let ff = (focusedFellowship===id)? "fellowship__focused" : "";
    let classes = announce.classes;
    let res = `<div id=${id} class="${classes.reduce((a,b)=>a+" "+b,"") + " " + fl + ff}"`;
    if(classes.includes("card"))
        res+=` style=background-image:url('../tw/icons/${classToImg(classes[0])}.jpg')`;
    
    let map = new Map(Object.entries(announce));
    map.delete("operation");
    map.delete("id");
    map.delete("classes");
    map.delete("instance-#");
    map.delete("position");

    if(classes.includes("event")){
        map.set("reason", map.get("reason").split(" ")[0]);
        map.forEach((value,key) => res+=` ${key}=${value}`);
        res += ` draggable=true>`;
    }else{
        res += ` draggable=true>`;
        map.forEach((value,key) => res+=`<div id="${id}__${key}" class="attribute ${key}" content=${value}></div>`);
    }
    res += "</div>";
    return res;
}

function insertingData(announce){
    let msDelay = 20;
    let animationFunction;
    
    if(announce.position != "[nil]"){
        animationFunction = () => 
            document.getElementById(announce.position)
            .insertAdjacentHTML("beforeend", makeElement(announce));
    }else{
        if(announce.classes.includes("location")){
            animationFunction = () => 
                locations.insertAdjacentHTML("beforeend", makeElement(announce));
        }else if(announce.classes.includes("event")){
            msDelay = 300;
            animationFunction = () => {
                events.insertAdjacentHTML("beforeend", makeElement(announce));
            };
        } else {
            animationFunction = () =>
                game_space.insertAdjacentHTML("beforeend", makeElement(announce));
        }
    }

    return {msDelay, animationFunction};
}

function modifyElement(announce){
    let msDelay = 20;
    let animationFunction = () => {
        let elementAtt = document.getElementById(announce.id+"__"+announce.slot);
        elementAtt.setAttribute("content",announce.value);
    };
    if (document.getElementById(announce.id).classList.contains("event")){
        msDelay = 300;
        animationFunction = () => {
            let element = document.getElementById(announce.id);
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
    let draggable = event.target;
    event.dataTransfer.setData("text/plain", draggable.id);
    removeAllChoiceStyles();

    choice
    .filter((singleChoice) => singleChoice.vector[0]===draggable.id & singleChoice.vector.length===2)
    .forEach((singleChoice) => {
        let complexChoiceTarget = document.getElementById(singleChoice.vector[1])
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
            let simpleChoiceTarget = document.getElementById(singleChoice.vector[0]);
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
        let data = event.dataTransfer.getData("text/plain")+" "+event.target.id;
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

function animateAnnounce(announce){
    return new Promise((resolve) =>{
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
            operationData = {msDelay : 20, animationFunction : enableChoices};
        }
        operationData.animationFunction();
        setTimeout(resolve, operationData.msDelay);
    })
}

async function animate(announces){
    for await (announce of announces){
        await animateAnnounce(announce);
    }
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
    phase = document.getElementById("phase");
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