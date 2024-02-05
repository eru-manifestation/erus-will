//var W3CWebSocket = require('websocket').w3cwebsocket;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const socket = io.connect(window.location.origin,{query:urlParams.toString()});
const dev = urlParams.get("dev");
var choice = [];

var closeUp, game_space,
    invisible,
    locations, 
    player_hand, enemy_hand, 
    player_draw, enemy_draw, 
    player_discard, enemy_discard, 
    player_mp, enemy_mp, 
    out_of_game, 
    events;

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
    var res = `<div id=${id} class="${announce.classes.reduce((a,b)=>a+" "+b,"")}"`
    if(announce.classes.includes("card"))
        res+=`style=background-image:url('../tw/icons/${classToImg(announce.classes[0])}.jpg'`
    res+=` draggable=true>`;
    announce = new Map(Object.entries(announce));
    announce.delete("operation");
    announce.delete("id");
    announce.delete("classes");
    announce.delete("instance-#");
    announce.forEach((value,key) => res+=`<div id="${id}__${key}" class="attribute ${key}"><span>${value}</span></div>`)
    res += "</div>"
    return res;
}

function insertingData(announce){
    var destination = invisible;
    var msDelay = 20;
    var animationFunction = () => destination.insertAdjacentHTML("beforeend", makeElement(announce));

    if(announce.id=="[player1]" || announce.id=="[player2]"){
        destination=game_space;
    }else if(announce.classes.includes("location")){
        destination=locations;
    }else if(announce.classes.includes("card")){
        if(announce.player=="[player1]"){
            destination=player_draw;
        }else{
            destination=enemy_draw;
        }
    }else if(announce.classes.includes("event")){
        destination = events;
        msDelay = 2000 + msDelay;
        animationFunction = () => {
            destination.insertAdjacentHTML("beforeend", makeElement(announce))
            var element = document.getElementById(announce.id);
            // element.textContent += JSON.stringify(announce);
            element.classList.add("eventppanimation");
            setTimeout(() => element.classList.remove("eventppanimation"), msDelay);
        };
    }
    return {msDelay, animationFunction};
}

function modifyElement(announce){
    var msDelay = 20;
    var animationFunction = () => {
        if(announce.slot=="state"){
            var element = document.getElementById(announce.id);
            var player = document.getElementById(announce.id+"__player").textContent;
            var destination = null;
            switch(announce.value){
                case "HAND":
                    if(player=="[player1]") destination = player_hand;
                    else destination = enemy_hand;
                    destination.appendChild(element);
                    break;
                case "DRAW":
                    if(player=="[player1]") destination = player_draw;
                    else destination = enemy_draw;
                    destination.appendChild(element);
                    break;
                case "DISCARD":
                    if(player=="[player1]") destination = player_discard;
                    else destination = enemy_discard;
                    destination.appendChild(element);
                    break;
                case "MP":
                    if(player=="[player1]") destination = player_mp;
                    else destination = enemy_mp;
                    destination.appendChild(element);
                    break;
                case "OUTOFGAME":
                    destination = out_of_game;
                    destination.appendChild(element);
                    break;
            }
        }
        var elementAtt = document.getElementById(announce.id+"__"+announce.slot).firstChild;
        elementAtt.textContent = announce.value;
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
                    operationData.animationFunction = () => document.getElementById(announce.to).appendChild(document.getElementById(announce.id));
                    break;

                default:
                    console.error("error in operation type");
                    break;
            }
        else {
            operationData.msDelay = 20;
            operationData.animationFunction = enableChoices;
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
    invisible = document.getElementById("invisible");
    closeUp = document.getElementById("close-up");
    game_space = document.getElementById("game-space");
    locations = document.getElementById("locations");
    player_hand = document.getElementById("[PLAYERHAND]");
    enemy_hand = document.getElementById("[ENEMYHAND]");
    player_draw = document.getElementById("[PLAYERDRAW]");
    enemy_draw = document.getElementById("[ENEMYDRAW]");
    player_discard = document.getElementById("[PLAYERDISCARD]");
    enemy_discard = document.getElementById("[ENEMYDISCARD]");
    player_mp = document.getElementById("[PLAYERMP]");
    enemy_mp = document.getElementById("[ENEMYMP]");
    out_of_game = document.getElementById("[OUTOFGAME]");
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



// socket.on('connect', function (data) {
//     socket.emit('storeClientInfo', { customId:"000CustomIdHere0000" });
// });
