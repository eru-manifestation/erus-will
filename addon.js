var addon = require('bindings')('addon');
const uuid = require("uuid");
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

var CLIPSEnvs = new Map();
//var port = 8080;


function initializeClipsEnv(origin){
    var obj = new addon.ClipsWrapper();
    CLIPSEnvs.set(origin, obj);
    console.log("CLIPS enviroment created for " + origin);
    console.log("There are %d enviroments",CLIPSEnvs.size);
    return obj;
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
    console.log('A user connected: '+socket.id);
    var player, room;
    if(socket.handshake.query["room"] == "null"){
        console.log("player1 connected");
        player = "player1";
        room = socket.id;
        socket.join("player1");
        //env = initializeClipsEnv(room);
    }else{
        console.log("player2 connected");
        player = "player2";
        room = socket.handshake.query.room;
        socket.join("player2");
        //env = CLIPSEnvs.get(room);
    }
    console.log("Room: "+room);
    socket.join(room);

    io.sockets.in(room).fetchSockets().then((value)=>{
        //Si ambos jugadores ya están conectados
        if(value.length===2){
            var env = initializeClipsEnv(room);
            io.sockets.in(room).emit("log", "\nDebug buffer\n"+env.getDebugBuffer().replaceAll("crlf","\n"));
            io.sockets.in(room).except("player2").emit("log", "\nAnnounce buffer\n"+env.getAnnounceBuffer("player1").replaceAll("crlf","\n"));
            io.sockets.in(room).except("player1").emit("log", "\nAnnounce buffer\n"+env.getAnnounceBuffer("player2").replaceAll("crlf","\n"));
            io.sockets.in(room).except("player2").emit("log", "\nChoose buffer\n"+env.getChooseBuffer("player1").replaceAll("crlf","\n"));
            io.sockets.in(room).except("player1").emit("log", "\nChoose buffer\n"+env.getChooseBuffer("player2").replaceAll("crlf","\n"));
        }
    });

    socket.on("orders", (orders) => {
        var env = CLIPSEnvs.get(room);
        io.sockets.in(room).emit("log", "\nChoose result:\n"+env.wrapEval("(play-action "+player+" "+orders+")"));
        io.sockets.in(room).emit("log", "\nDebug buffer\n"+env.getDebugBuffer().replaceAll("crlf","\n"));
        io.sockets.in(room).except("player2").emit("log", "\nAnnounce buffer\n"+env.getAnnounceBuffer("player1").replaceAll("crlf","\n"));
        io.sockets.in(room).except("player1").emit("log", "\nAnnounce buffer\n"+env.getAnnounceBuffer("player2").replaceAll("crlf","\n"));
        io.sockets.in(room).except("player2").emit("log", "\nChoose buffer\n"+env.getChooseBuffer("player1").replaceAll("crlf","\n"));
        io.sockets.in(room).except("player1").emit("log", "\nChoose buffer\n"+env.getChooseBuffer("player2").replaceAll("crlf","\n"));
        console.log("Player "+player+" commands: {"+orders+"}");
    });

    socket.on("disconnecting", (reason) => {
        console.log("Disconnecting "+socket.id);
        var env = CLIPSEnvs.get(room);
        if(env==undefined){
            console.log("User exited");
        }else if(env.wrapDestroyEnvironment()){
            console.log("Environment of %s successfully destroyed",socket.id);
        }else{
            console.log("Environment of %s not destroyed",socket.id);
        }
        CLIPSEnvs.delete(socket.id);
    });

});

server.listen(3000, () => {
  console.log('listening on *:3000');
});