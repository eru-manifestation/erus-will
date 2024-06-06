module.exports = (io, addon) => {

    const CLIPSEnvs = new Map();

    function enemy(player) {
        let res;
        if (player === "player1") {
            res = "player2";
        } else if (player === "player2") {
            res = "player1";
        }
        return res;
    }

    function updatePlayer(player, env, room) {
        return new Promise((resolve, reject) => {
            let content, announce, choice;
            env.wrapEval("(get-debug)")
                .then((debug) => {
                    let data = debug.replaceAll("crlf", "\n");
                    if (data != "") io.sockets.in(room).emit("log", "Debug buffer\n" + data);
                })
                .then(() => {
                    content = (player === "player1") ? "announce-p1" : "announce-p2";
                    return env.wrapEval("(get-" + content + ")");
                })
                .then((rawAnnounce) => {
                    announce = rawAnnounce.replaceAll("crlf", "\n");
                    content = (player === "player1") ? "choose-p1" : "choose-p2";
                    return env.wrapEval("(get-" + content + ")");
                })
                .then((rawChoose) => {
                    choice = rawChoose.replaceAll("crlf", "\n");
                    io.sockets.in(room).except(enemy(player)).emit("satm_ok", `{ "announces" : ${announce} , "choice" : ${choice} }`);
                    resolve("Player " + player + "'s of room " + room + " update successful")
                })
                .catch(() => reject("An error ocurred when updating players"));
        });
    }

    function updateBothPlayers(wrap, room) {
        return new Promise((resolve, reject) =>
            updatePlayer("player1", wrap, room)
                .then(() => updatePlayer("player2", wrap, room))
                .then(() => resolve("Both players updated"))
                .catch((error) => reject(error))
        );
    }

    const serverError = (socket, reason) => {
        console.error("Server error: socket " + socket.id + " disconnecting.", reason);
        socket.disconnect(true);
    }

    const connectPlayer = (socket) => new Promise(async (res, rej) => {
        let room = socket.data.room;
        let connectedClients = await io.sockets.in(room).fetchSockets();
        switch (connectedClients.length) {
            case 0:
                socket.data.player = "player1";
                socket.join("player1");
                console.log("Player1 connected in room " + room);
                socket.join(room);
                socket.emit("player","player1");
                console.log("Joined room: " + room);
                res();
                break;
            case 1:
                socket.data.player = "player2";
                socket.join("player2");
                socket.join(room);
                console.log("Player2 connected in room " + room);
                socket.emit("player","player2");
                const wrap = new addon.ClipsWrapper();
                wrap.createEnvironment()
                    .then((value) => {
                        console.log(value);
                        CLIPSEnvs.set(room, wrap);
                        console.log("CLIPS enviroment created for " + socket.id + " in room " + room);
                        console.log("There are %d enviroments", CLIPSEnvs.size);
                        return updateBothPlayers(wrap, room);
                    })
                    .then(console.log)
                    .catch((err) => console.log("[ADDON ERROR]:\t" + err));
                console.log("Joined room: " + room);
                res();
                break;
            case 2:
                rej("Both players already connected");
                break;
            default:
                rej("Unexpected number of clients");
        }
    });

    const disconnectPlayer = (socket, reason) => {
        let room = socket.data.room;
        console.log("\nDisconnecting " + socket.id, reason.toString());
        if (!CLIPSEnvs.has(room))
            console.log("User exited");
        else
            CLIPSEnvs.get(room).wrapDestroyEnvironment()
                .then(() => {
                    console.log("Environment in room %s of %s successfully destroyed", room, socket.id);
                    CLIPSEnvs.delete(room);
                })
                .catch((err) => {
                    console.error("Environment of %s not destroyed", socket.id);
                    console.error(err);
                })
                .finally(() => {
                    console.log("There are %d enviroments", CLIPSEnvs.size);
                    io.sockets.in(room).disconnectSockets();
                });
    }

    const receiveOrders = (socket, orders) => {
        let player = socket.data.player;
        let room = socket.data.room;
        let env = CLIPSEnvs.get(room);
        console.log(`\nPlayer ${player} of room ${room} commands: ${orders}`);
        env.wrapEval("(play-action " + player + " " + orders + ")")
            .then((result) => {
                if (result == "TRUE") {
                    updateBothPlayers(env, room)
                        .then(console.log)
                        .catch(() => serverError(socket, "Error when updating players in room " + room));
                } else {
                    console.log("\t^-- The command is rejected");
                    io.sockets.in(room).except(enemy(player)).emit("satm_error", orders);
                }
            })
            .catch(console.error);
    }

    return {
        serverError, disconnectPlayer, connectPlayer, receiveOrders
    }
    
}