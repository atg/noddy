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

var _ = require('underscore.js');
var api = require('api.js');
var loadedMixins = [];

function Mixin(mixinPath, mixinID, vmContext) {
    this.path = mixinPath;
    this.vmCtx = vmContext;
    this.id = mixinID;
}


/*function clone(obj){
    if(obj == null || typeof(obj) != 'object')
        return obj;
    
    var temp = obj.constructor(); // changed
    
    for(var key in obj)
        temp[key] = clone(obj[key]);
    return temp;
}
*/

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
    var sandbox = _.clone(global);
//    console.log(sandbox.require);
    
    sandbox.mixinPath = mixinPath;
    sandbox.nodeRequire = sandbox.require;
    sandbox.requireJS = require("r.js");
    sandbox.requireJS.config({
        'nodeRequire': sandbox.nodeRequire, 'baseUrl': sandbox.mixinPath
    });
    sandbox.require = function() {
        try {
            return sandbox.nodeRequire.apply({}, arguments);
        }
        catch (e) {
            return sandbox.requireJS.apply({}, arguments);
        }
    };
    var vmContext = vm.createContext(sandbox);
    
    /*
    // Set up require.js in vmContext
    vm.runInContext(
        "global.nodeRequire = global.require; " +
        "global.requireJS = global.nodeRequire(\"r.js\"); " + 
        "global.requireJS.config({ " +
            "'nodeRequire': global.nodeRequire, 'baseUrl': global.mixinPath " +
        "}); " +
        "global.require = function() { " +
            "try { " +
                "return global.nodeRequire.apply({}, arguments); " +
            "} " +
            "catch (e) { " +
                "return global.requireJS.apply({}, arguments); " +
            "} " +
        "} ", vmContext);
    */
    
    // Add our new Mixin
    var mixin = new Mixin(mixinPath, mixinID, vmContext);
    loadedMixins.push(mixin);
    
    // Run init.js
    vm.runInContext(initJSSource, vmContext, pathToInitjs)
}
