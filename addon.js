var WebSocketServer = require("websocket").server;
var http = require('http');
var addon = require('bindings')('addon');

var CLIPSEnvs = new Map();
var port = 8080;

function clientID(connection){
    return connection.socket.remoteAddress+":"+connection.socket.remotePort;
}

function initializeClipsEnv(origin){
    var obj = new addon.ClipsWrapper();
    CLIPSEnvs.set(origin, obj);
    console.log("CLIPS enviroment created for "+origin);

    console.log( obj.getDebugBuffer().replaceAll("crlf","\n") );
    console.log("\n\n");
    console.log( obj.getAnnounceBuffer().replaceAll("crlf","\n") );
    console.log( obj.getAnnounceBuffer().replaceAll("crlf","\n") );
    console.log( obj.getFacts() );
    console.log( obj.getFacts() );
    console.log( obj.getFacts() );
    console.log( obj.wrapEval("(instances)"));
}


var server = http.createServer(function(request, response) {
    console.log((new Date()) + ' Received request for ' + request.url);
    response.writeHead(404);
    response.end();
});
server.listen(port, function() {
    console.log((new Date()) + ' Server is listening on port '+port);
});


wsServer = new WebSocketServer({
    httpServer: server,
    // You should not use autoAcceptConnections for production
    // applications, as it defeats all standard cross-origin protection
    // facilities built into the protocol and the browser.  You should
    // *always* verify the connection's origin and decide whether or not
    // to accept it.
    autoAcceptConnections: false
});

function originIsAllowed(origin) {
  // put logic here to detect whether the specified origin is allowed.
  return true;
}

wsServer.on('request', function(request) {
    if (!originIsAllowed(request.origin)) {
      // Make sure we only accept requests from an allowed origin
      request.reject();
      console.log((new Date()) + ' Connection from origin ' + request.origin + ' rejected.');
      return;
    }
    
    var connection = request.accept('echo-protocol', request.origin);
    console.log((new Date()) + ' Connection accepted.');

    initializeClipsEnv(clientID(connection));

    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log('Received Message: ' + message.utf8Data);
            connection.sendUTF(message.utf8Data);
        }
        else if (message.type === 'binary') {
            console.log('Received Binary Message of ' + message.binaryData.length + ' bytes');
            connection.sendBytes(message.binaryData);
        }
    });
    connection.on('close', function(reasonCode, description) {
        CLIPSEnvs.delete(clientID(connection));
        console.log("CLIPS enviroment deleted for " + clientID(connection));
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});