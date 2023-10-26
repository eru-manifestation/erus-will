console.log("inicio")
var addon = require('bindings')('addon');

console.log("llega aqui")
var obj = new addon.ClipsWrapper();
console.log("llega tambien")
console.log( obj.getDebugBuffer().replaceAll("crlf","\n") )
console.log("\n\n")
console.log( obj.getAnnounceBuffer().replaceAll("crlf","\n") )
console.log( obj.getAnnounceBuffer().replaceAll("crlf","\n") )
console.log( obj.getFacts() )
console.log( obj.getFacts() )
console.log( obj.getFacts() )