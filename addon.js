var addon = require('bindings')('addon.node');
const uuid = require("uuid");
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

var CLIPSEnvs = new Map();
//var port = 8080;

function enemy(player){
    var res;
    if (player === "player1"){
        res = "player2";
    }else if (player === "player2"){
        res = "player1";
    }
    return res;
}

function updatePlayer(player, env, room){
    var data;
    data =env.getDebugBuffer().replaceAll("crlf","\n");
    if (data != "") io.sockets.in(room).except(enemy(player)).emit("log", "Debug buffer\n"+data);

    data = env.getStateBuffer(player).replaceAll("crlf","\n");
    if (data != "") io.sockets.in(room).except(enemy(player)).emit("state", data)
    
    data = env.getAnnounceBuffer(player).replaceAll("crlf","\n");
    if (data != "") io.sockets.in(room).except(enemy(player)).emit("announce", data)
    
    data = env.getChooseBuffer(player).replaceAll("crlf","\n");
    if (data != "") io.sockets.in(room).except(enemy(player)).emit("choose", data);
}

// const io = new Server(port, { /* options */ });

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/www/room.html');
});

app.get('/:resource', (req, res) => {
    var resource = req.params.resource;
    res.sendFile(__dirname + '/www/' + resource);
});

app.get('/tw/:img', (req, res) => {
    var img = req.params.img;
    res.sendFile(__dirname + '/tw/' + img);
});

app.get('/tw/icons/:icon', (req, res) => {
    var icon = req.params.icon;
    res.sendFile(__dirname + '/tw/icons/' + icon);
});

io.engine.generateId = (req) => {
    return uuid.v4(); // must be unique across all Socket.IO servers
  }

io.on('connection', (socket) => {
    console.log('\nA user connected on socket '+socket.id);
    var player, room, dev=false;
    if(socket.handshake.query["room"] == "null" || socket.handshake.query["room"] == undefined){
        player = "player1";
        room = socket.id;
        socket.join("player1");
        console.log("player1 connected");
    }else{
        player = "player2";
        room = socket.handshake.query.room;
        socket.join("player2");
        console.log("player2 connected");
    }
    if(socket.handshake.query["dev"] === "true"){
        dev=true;
        console.log("Connected as dev");
    }
    socket.join(room);
    console.log("On room: "+room);

    io.sockets.in(room).fetchSockets().then((value)=>{
        //Si ambos jugadores ya están conectados
        if(value.length===2){
            var wrap = new addon.ClipsWrapper();
            console.log(wrap.createEnvironment());
                console.log(value);
                CLIPSEnvs.set(room, wrap);
                console.log("CLIPS enviroment created for " + room);
                console.log("There are %d enviroments",CLIPSEnvs.size);
                console.log("LLega aqui");
                console.log(wrap.getDebugBuffer());
                updatePlayer("player1", wrap, room);
                updatePlayer("player2", wrap, room);
            
        }
    });

    socket.on("orders", (orders) => {
        var env = CLIPSEnvs.get(room);
        var result = env.wrapEval("(play-action "+player+" "+orders+")");
        console.log("\nPlayer "+player+" commands: {"+orders+"}");
        if(result=="TRUE"){
            updatePlayer("player1", env, room);
            updatePlayer("player2", env, room);
        }else{
            console.log("\t^-- The command is rejected");
            io.sockets.in(room).except(enemy(player)).emit("satm_error", orders);
        }
    });

    socket.on("disconnecting", (reason) => {
        console.log("\nDisconnecting "+socket.id);
        var env = CLIPSEnvs.get(room);
        if(env==undefined){
            console.log("User exited");
        }else if(env.wrapDestroyEnvironment()){
            console.log("Environment of %s successfully destroyed",socket.id);
            CLIPSEnvs.delete(socket.id);
        }else{
            console.log("Environment of %s not destroyed",socket.id);
        }
        console.log("There are %d enviroments",CLIPSEnvs.size);
    });

});

server.listen(3000, () => {
  console.log('listening on *:3000');
});