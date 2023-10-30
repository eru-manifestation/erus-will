//var W3CWebSocket = require('websocket').w3cwebsocket;
var socket = io();

document.addEventListener("DOMContentLoaded", ()=>{
    var log = document.getElementById("log");
    var orders = document.getElementById("orders");
    var button = document.getElementById("send");

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
});



// socket.on('connect', function (data) {
//     socket.emit('storeClientInfo', { customId:"000CustomIdHere0000" });
// });
