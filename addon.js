const addon = require('bindings')('addon.node');
const uuid = require("uuid");
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);
const {serverError, connectPlayer, disconnectPlayer, receiveOrders} = require("./gameServer.js")(io, addon);

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

io.on('connection', async (socket) => {
    console.log('\nA user connected on socket ' + socket.id);
    socket.data.room = socket.handshake.query["room"];
    if (socket.data.room == "null" || socket.data.room == undefined)
        serverError(socket, "Empty room name");
    else {
        try {
            await connectPlayer(socket);
            if (socket.handshake.query["dev"] === "true") {
                socket.data.dev = true;
                console.log("Connected as dev");
            }
            socket.on("orders", (orders) => receiveOrders(socket, orders));
            socket.on("disconnecting", (reason) => disconnectPlayer(socket, reason));
        } catch (e) {
            serverError(socket, "Error on connecting: " + e.toString());
        }
    }
})

server.listen(3000, () => {
    console.log('listening on *:3000');
});