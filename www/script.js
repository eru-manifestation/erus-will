//var W3CWebSocket = require('websocket').w3cwebsocket;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const room = urlParams.get('room');
console.log(room);
var socket = io.connect(window.location.origin,{query:"room="+room});


document.addEventListener("DOMContentLoaded", ()=>{
    var game_space = document.getElementById("game-space");


    function send_orders(orders){
        console.log(orders);
        socket.emit("orders",orders);
        orders.value="";
    }

    socket.on("log", (data)=>{
        console.log("Mensaje recibido:\n"+data);
    });

    socket.on("state", (data)=>{
        console.log("Estado recibido:\n"+data);
        game_space.innerHTML=data;

        document.querySelectorAll("*[draggable=true]").forEach(
            (draggable) => {
                draggable.addEventListener("dragstart", (event) => {
                    event.dataTransfer.setData("text/plain", draggable.id);
                    event.stopPropagation();
                });
                
                draggable.addEventListener("dragenter", (event) => {
                    event.preventDefault();
                    event.stopPropagation();
                });
                
                draggable.addEventListener("dragover", (event) => {
                    event.preventDefault();
                    event.stopPropagation();
                });

                draggable.addEventListener("dragleave", (event) => {
                    event.preventDefault();
                    event.stopPropagation();
                });
                
                draggable.addEventListener("drop", (event) => {
                    if (event.dataTransfer.types.includes("text/plain")){
                        data = event.dataTransfer.getData("text/plain")+" "+draggable.id;
                        send_orders(data);
                        console.log("drop");
                        event.stopPropagation();
                    }
                    event.preventDefault();
                });
            }
        );
    });

});



// socket.on('connect', function (data) {
//     socket.emit('storeClientInfo', { customId:"000CustomIdHere0000" });
// });
