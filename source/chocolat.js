// MUST DO FIRST: Grab a global context to use later
var _underscorejs_ = require('underscore.js');
var cloned_global = _underscorejs_.clone(global);


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
    this.id = mixinID;
}


global.sayHelloTo = function(person) {
    console.log("Hello, " + person + "!");
}


global.load_initjs = function(mixinPath, mixinID) {
    
    // Look in loadedMixins for this mixin
    // Remove any that match mixinPath
    loadedMixins = loadedMixins.filter(function (aMixin) { return a.Min.path === mixinPath; });
    
    // Read the source from disk
    var pathToInitjs = path.join(mixinPath, "init.js");
    var initJSSource = fs.readFileSync(pathToInitjs);
    
    // Load in a new context with `api` as the root
    var sandbox = _underscorejs_.clone(cloned_global);
    
    sandbox.mixinPath = path.normalize(mixinPath);
    sandbox.require = require;
    sandbox.global = sandbox;
    
    var vmContext = vm.createContext(sandbox);
    
    // Set up require.js in vmContext
    vm.runInContext(
        "var nodeRequire = require; " +
        "require = function() { " +
            "try { " +
                "return nodeRequire.apply({}, arguments); " +
            "} " +
            "catch (e) { " +
                "return nodeRequire(mixinPath + \"/\" + arguments[0]); " +
            "} " +
        "} ", vmContext);

    // Add our new Mixin
    var mixin = new Mixin(mixinPath, mixinID, vmContext);
    loadedMixins.push(mixin);
    
    // Run init.js
    vm.runInContext(initJSSource, vmContext, pathToInitjs)
}
