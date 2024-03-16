let addon = require('bindings')('addon.node');
const uuid = require("uuid");
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

let CLIPSEnvs = new Map();
//let port = 8080;

function enemy(player){
    let res;
    if (player === "player1"){
        res = "player2";
    }else if (player === "player2"){
        res = "player1";
    }
    return res;
}

function updatePlayer(player, env, room){
    return new Promise((resolve,reject)=>{
        let content, announce, choice;
        env.wrapEval("(get-debug)")
        .then((debug)=>{
            //TODO: fix that the debug buffer is shared, so it mustn't be emptied when one player
            //      reads it
            let data = debug.replaceAll("crlf","\n");
            if (data != "") io.sockets.in(room).emit("log", "Debug buffer\n"+data);
        })
        .then(()=>{
            content = (player==="player1")? "announce-p1" : "announce-p2";
            return env.wrapEval("(get-"+content+")");
        })
        .then((rawAnnounce)=>{
            announce = rawAnnounce.replaceAll("crlf","\n");
            content = (player==="player1")? "choose-p1" : "choose-p2";
            return env.wrapEval("(get-"+content+")");
        })
        .then((rawChoose)=>{
            choice = rawChoose.replaceAll("crlf","\n");
            io.sockets.in(room).except(enemy(player)).emit("satm_ok", `{ "announces" : ${announce} , "choice" : ${choice} }`);
            resolve("Player "+player+"'s of room "+room+" update successful")
        })
        .catch(reject);
    });
}

function updateBothPlayers(wrap,room){
    return new Promise((resolve,reject)=>
        updatePlayer("player1", wrap, room)
        .then(()=>{
            return updatePlayer("player2", wrap, room);
        })
        .then(()=>resolve("Both players updated"))
        .catch((error)=>reject(error))
    );
}

// const io = new Server(port, { /* options */ });

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/www/room.html');
});

app.get('/:resource', (req, res) => {
    let resource = req.params.resource;
    res.sendFile(__dirname + '/www/' + resource);
});

app.get('/tw/:img', (req, res) => {
    let img = req.params.img;
    res.sendFile(__dirname + '/tw/' + img);
});

app.get('/tw/icons/:icon', (req, res) => {
    let icon = req.params.icon;
    res.sendFile(__dirname + '/tw/icons/' + icon);
});

io.engine.generateId = (req) => {
    return uuid.v4(); // must be unique across all Socket.IO servers
  }

io.on('connection', (socket) => {
    console.log('\nA user connected on socket '+socket.id);
    let player, room, dev=false;
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
            let wrap = new addon.ClipsWrapper();
            wrap.createEnvironment()
            .then((value)=>{
                console.log(value);
                CLIPSEnvs.set(room, wrap);
                console.log("CLIPS enviroment created for " + room);
                console.log("There are %d enviroments",CLIPSEnvs.size);
                return updateBothPlayers(wrap, room);
            })
            .then(console.log)
            .catch((err)=>console.log("[ADDON ERROR]:\t"+err));
        }
    });

    socket.on("orders", (orders) => {
        let env = CLIPSEnvs.get(room);
        console.log("\nPlayer "+player+" commands: {"+orders+"}");
        env.wrapEval("(play-action "+player+" "+orders+")")
        .then((result)=>{
            if(result=="TRUE"){
                updateBothPlayers(env,room)
                .then(console.log)
                .catch(console.error);
            }else{
                console.log("\t^-- The command is rejected");
                io.sockets.in(room).except(enemy(player)).emit("satm_error", orders);
            }
        })
        .catch(console.error);
    });

    socket.on("disconnecting", (reason) => {
        console.log("\nDisconnecting "+socket.id);
        if(!CLIPSEnvs.has(room))
            console.log("User exited");
        else
            CLIPSEnvs.get(room).wrapDestroyEnvironment()
            .then(()=>{
                console.log("Environment of %s successfully destroyed",socket.id);
                CLIPSEnvs.delete(room);
            })
            .catch((err)=>{
                console.error("Environment of %s not destroyed",socket.id);
                console.error(err);
            })
            .finally(()=>console.log("There are %d enviroments",CLIPSEnvs.size));
    });

});

server.listen(3000, () => {
  console.log('listening on *:3000');
});