var os = require('os');
//var vm = require('vm');
var fs = require('fs');
var path = require('path');

global.current_mixin_name = null;

console.log("Bite my shiny metal ass [" + os.platform() + " " + os.release() + "]");

// Temporary way to stop node.js quitting immediately until we add an events.EventEmitter
process.stdin.resume();

/*
 TODO: Handle uncaught exceptions
process.on('uncaughtException', function () {
    
});
*/

var api = require('api.js');
var loadedMixins = [];

// Keep the event loop running until uv_async is less buggy
setInterval(function () {}, 500);


global.objc_msgSend = function() {
    global.private_objc_msgSend.apply({ sync: false }, arguments);
}
global.objc_msgSendSync = function() {
    return global.private_objc_msgSend.apply({ sync: true }, arguments);
}

global.sayHelloTo = function(person) {
    console.log("Hello, " + person + "!");
}


global.call_function_as = function(mixinname, func, args) {
    try {
        global.current_mixin_name = mixinname;
        func.apply({}, args);
    }
    finally {
        global.current_mixin_name = null;
    }
}

global.load_initjs = function(mixinPath, mixinID) {
    
    // Look in loadedMixins for this mixin
    // Remove any that match mixinPath
    loadedMixins = loadedMixins.filter(function (aMixin) { return aMixin.path !== mixinPath; });
    
    // Read the source from disk
    var pathToInitjs = path.join(mixinPath, "init.js");
    
    // Add our new Mixin
    loadedMixins.push({ path:mixinPath, id:mixinID });
    
    // Remove from the module cache
    var keys = Object.keys(require.cache);
    for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        delete require.cache[key];
    }
    
    // Run the code!
    require(pathToInitjs);

}
