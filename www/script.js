//var W3CWebSocket = require('websocket').w3cwebsocket;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const socket = io.connect(window.location.origin,{query:urlParams.toString()});
const dev = urlParams.get("dev");
var choice = [[]];

var game_space,
    player, enemy, 
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


function upcaseFirst(str){
    if (["a","an","and","of","the","or","in","out"].includes(str))
        return str;
    else return str.charAt(0).toUpperCase() + str.slice(1);
}

function classToImg(cls){
    return cls.replaceAll("--","").split("-").reduce((a,b)=>a+upcaseFirst(b),"");
}

function makeElement(announce){
    var res = `<div id=${announce.id} class="${announce.classes.reduce((a,b)=>a+" "+b,"")}"`
    if(announce.classes.includes("card"))
        res+=`style=background-image:url('../tw/icons/${classToImg(announce.classes[0])}.jpg'`
    res+=` draggable=true`;
    announce = new Map(Object.entries(announce));
    announce.delete("operation");
    announce.delete("id");
    announce.delete("classes");
    announce.delete("instance-#");
    announce.forEach((value,key) => res+=` ${key}="${value}"`)
    res += "></div>"
    return res;
}

function insertElement(announce){
    var destination = game_space;
    if(announce.id=="[player1]"){
        destination=player;
    }else if(announce.id=="[player2]"){
        destination=enemy;
    }else if(announce.classes.includes("location")){
        destination=locations;
    }else if(announce.classes.includes("card")){
        if(announce.player=="[player1]"){
            destination=player_draw;
        }else{
            destination=enemy_draw;
        }
    }else{
        destination=events;
    }
    destination.insertAdjacentHTML("beforeend", makeElement(announce));
}

function modifyElement(announce){
    if(announce.slot="state"){
        var element = document.getElementById(announce.id);
        var player = element.getAttribute("player");
        var destination=null;
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
    element.setAttribute(announce.slot,announce.value);
}



function emitSimpleChoice(event){
    send_orders(event.target.id);
    event.preventDefault();
    event.stopPropagation();
}


function removeChoiceStyles(){
    document.querySelectorAll(".choosable")
        .forEach((choosable)=>choosable.classList.remove("choosable"));
    document.querySelectorAll(".choosable-final")
        .forEach((choosable)=>choosable.classList.remove("choosable-final"));
}

function startComplexChoice(event){
    var draggable = event.target;
    event.dataTransfer.setData("text/plain", draggable.id);
    removeChoiceStyles();

    choice.filter((singleChoice)=>singleChoice[0]===draggable.id & singleChoice.length===2).forEach((singleChoice)=>{
        document.getElementById(singleChoice[1]).classList.add("choosable-final");
        //TODO: Activar aquí el listener?
    });
    event.stopPropagation();
}

function restartStyles(event){
    removeChoiceStyles();

    choice.forEach((singleChoice)=>{
        if(singleChoice.length===1) document.getElementById(singleChoice[0]).classList.add("choosable-final");
        else document.getElementById(singleChoice[0]).classList.add("choosable");
    });
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
    removeChoiceStyles();

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
    choice.forEach((singleChoice)=>{
        if(singleChoice.length===1) document.getElementById(singleChoice[0]).classList.add("choosable-final");
        else document.getElementById(singleChoice[0]).classList.add("choosable");
    });

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
    var index = 0;
    announces.forEach((announce) => setTimeout(()=>{
        if(announce!=null)
        switch(announce.operation){
            case "create":
                insertElement(announce);
                break;
            case "modify":
                modifyElement(announce);
                break;
            case "delete":
                document.getElementById(announce.id).remove();
                break;
            case "move":
                document.getElementById(announce.to).appendChild(document.getElementById(announce.id));
                break;
            default:
                console.error("error in operation type");
                break;
        }
        else enableChoices();
        
    },index++*50));
}

document.addEventListener("DOMContentLoaded", ()=>{
    game_space = document.getElementById("game-space");
    player = document.getElementById("player");
    enemy = document.getElementById("enemy");
    locations = document.getElementById("locations");
    player_hand = document.getElementById("PLAYERHAND");
    enemy_hand = document.getElementById("ENEMYHAND");
    player_draw = document.getElementById("PLAYERDRAW");
    enemy_draw = document.getElementById("ENEMYDRAW");
    player_discard = document.getElementById("PLAYERDISCARD");
    enemy_discard = document.getElementById("ENEMYDISCARD");
    player_mp = document.getElementById("PLAYERMP");
    enemy_mp = document.getElementById("ENEMYMP");
    out_of_game = document.getElementById("OUTOFGAME");
    events = document.querySelector(".events");



    socket.on("log", (data)=>{
        console.log("Mensaje recibido:\n"+data);
    });

    socket.on("satm_error", (data)=>{
        console.log("STAM error:\n"+data);
        fire("Invalid action", data, "error");
        enableChoices();
    });

    socket.on("choose", (data)=>{
        console.log("Choose:\n"+data);
        choice = data.trimEnd().split("\n").map((string)=>string.split(" -- ")[0].trimEnd().split(" "));
    });

    socket.on("announce", (data)=>{
        var announces = JSON.parse(data);
        console.log(announces);
        animate(announces);
        // data.trimEnd().split("\n").forEach((value,index) => {
        //     setTimeout(() => fire("Announce", value, "info"),index*1700);
        // });
    });

});



// socket.on('connect', function (data) {
//     socket.emit('storeClientInfo', { customId:"000CustomIdHere0000" });
// });
