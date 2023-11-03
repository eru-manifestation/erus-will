//var W3CWebSocket = require('websocket').w3cwebsocket;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const room = urlParams.get('room');
console.log(room);
var socket = io.connect(window.location.origin,{query:"room="+room});

document.addEventListener("DOMContentLoaded", ()=>{
    var log = document.getElementById("log");
    var orders = document.getElementById("orders");
    var button = document.getElementById("send");
    var game_space = document.getElementById("game-space");

    button.onclick=()=>{
        var data = orders.value;
        console.log(data);
        socket.emit("orders",data);
        orders.value="";
    };

    socket.on("log", (data)=>{
        console.log("Mensaje recibido:\n"+data);
        log.innerText+=data;
    });

    socket.on("state", (data)=>{
        console.log("Estado recibido:\n"+data);
        game_space.innerHTML=data;
    });
});



// socket.on('connect', function (data) {
//     socket.emit('storeClientInfo', { customId:"000CustomIdHere0000" });
// });
