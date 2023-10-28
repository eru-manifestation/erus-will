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
    res.sendFile(__dirname + '/www/index.html');
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
    console.log('a user connected: '+socket.id);
    var env = initializeClipsEnv(socket.id);

    socket.emit("log",env.getDebugBuffer().replaceAll("crlf","\n"));
    socket.emit("log",env.getAnnounceBuffer().replaceAll("crlf","\n"));

    socket.on("orders", (orders) => {
        socket.emit("log", "\nEval result:"+env.wrapEval(orders));
        socket.emit("log", "\nDebug buffer"+env.getDebugBuffer().replaceAll("crlf","\n"));
        socket.emit("log", "\nAnnounce buffer"+env.getAnnounceBuffer().replaceAll("crlf","\n"));
        console.log(orders);
    });

    socket.on("disconnecting", (reason) => {
        console.log("Disconnecting "+socket.id);
        if(env.wrapDestroyEnvironment()){
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