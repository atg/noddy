var os = require('os');
var vm = require('vm');
var fs = require('fs');
var path = require('path');

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

function Mixin(mixinPath, mixinID, vmContext) {
    this.path = mixinPath;
    this.vmCtx = vmContext;
    this.id = mixinid;
}

global.sayHelloTo = function(person) {
    console.log("Hello, " + person + "!");
}

global.load_initjs = function(mixinPath, mixinID) {
    
    // Look in loadedMixins for this mixin
    // Remove any that match mixinPath
    loadedMixins = loadedMixins.filter(function (aMixin) { return a.Min.path === mixinPath; });
    
    // Read the source from disk
    var initJSSource = fs.readFileSync(path.join(mixinPath, "init.js"));
    
    // Load in a new context with `api` as the root
    var vmContext = vm.createContext(api);
    
    // Set up require.js in vmContext
    vm.runInContext(
        "var nodeRequire = require; " +
        "var requireJS = nodeRequire(\"r.js\"); " +
        "requireJS.config({ " +
            "nodeRequire: nodeRequire, baseUrl: mixinPath " +
        "}); " +
        "require = function() { " +
            "try { " +
                "return nodeRequire.apply({}, arguments); " +
            "} " +
            "catch (e) { " +
                "return requireJS.apply({}, arguments); " +
            "} " +
        "} ", vmContext);
    
    // Add our new Mixin
    var mixin = new Mixin(mixinPath, mixinID, vmContext);
    loadedMixins.push(mixin);
    
    // Run init.js
    vm.runInContext(initJSSource, vmContext, pathToInitjs)
}
