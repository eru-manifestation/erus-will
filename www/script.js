//var W3CWebSocket = require('websocket').w3cwebsocket;
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const socket = io.connect(window.location.origin,{query:urlParams.toString()});
const dev = urlParams.get("dev");
var choice = [[]];

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

document.addEventListener("DOMContentLoaded", ()=>{
    var game_space = document.getElementById("game-space");


    function send_orders(orders){
        console.log("Orders: {"+orders+"}");
        socket.emit("orders",orders);
        orders.value="";
    }

    socket.on("log", (data)=>{
        console.log("Mensaje recibido:\n"+data);
    });

    socket.on("satm_error", (data)=>{
        console.log("STAM error:\n"+data);
        fire("Invalid action", data, "error");
    });

    socket.on("announce", (data)=>{
        console.log(JSON.parse(data));
        data.trimEnd().split("\n").forEach((value,index) => {
            setTimeout(() => fire("Announce", value, "info"),index*1700);
        });
    });

    socket.on("choose", (data)=>{
        console.log("Choose:\n"+data);
        choice = data.trimEnd().split("\n").map((string)=>string.split(" -- ")[0].trimEnd().split(" "));
        choice.forEach((singleChoice)=>{
            if(singleChoice.length===1) document.getElementById(singleChoice[0]).classList.add("choosable-final");
            else document.getElementById(singleChoice[0]).classList.add("choosable");
        });
    });

    socket.on("state", (data)=>{
        console.log("Estado recibido:\n"+data);
        game_space.innerHTML=data;

        document.querySelectorAll("*[draggable=true]").forEach(
            (draggable) => {
                draggable.addEventListener("click", (event) =>{
                    send_orders(draggable.id);
                    event.preventDefault();
                    event.stopPropagation();
                });


                draggable.addEventListener("dragstart", (event) => {
                    event.dataTransfer.setData("text/plain", draggable.id);
                    document.querySelectorAll(".choosable, .choosable-final")
                        .forEach((node)=>{
                            node.classList.remove("choosable");
                            node.classList.remove("choosable-final");
                        });
                    choice.filter((singleChoice)=>singleChoice[0]===draggable.id & singleChoice.length===2).forEach((singleChoice)=>{
                        document.getElementById(singleChoice[1]).classList.add("choosable-final");
                    });
                    event.stopPropagation();
                });

                draggable.addEventListener("dragend", (event) => {
                    document.querySelectorAll(".choosable, .choosable-final")
                        .forEach((node)=>{
                            node.classList.remove("choosable");
                            node.classList.remove("choosable-final");
                        });
                    choice.forEach((singleChoice)=>{
                        if(singleChoice.length===1) document.getElementById(singleChoice[0]).classList.add("choosable-final");
                        else document.getElementById(singleChoice[0]).classList.add("choosable");
                    });
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
