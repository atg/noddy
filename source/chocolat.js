var os = require('os');
console.log("Bite my shiny metal ass [" + os.platform() + " " + os.release() + "]");

/*
var vm = require('vm');
var api = require('api.js');
var loadedMixins = [];

function Mixin(mixinPath, mixinID, vmContext) {
    this.path = mixinPath;
    this.vmCtx = vmContext;
    this.id = mixinid;
}

function load_initjs(mixinPath, mixinID, pathToInitjs) {
    
    // Look in loadedMixins for this mixin
    // Remove any that match mixinPath
    for (...) {
        if (mixin.path === mixinPath) {
            // Remove
            ...
            break;
        }
    }
    
    // Read the source from disk
    var initJSSource = ...;
    
    // Load in a new context with `api` as the root
    var vmContext = vm.createContext(api);
    
    // Set up require.js in vmContext
    vm.runInContext("var nodeRequire = require; var requireJS = nodeRequire(\"r.js\"); requireJS.config({ nodeRequire: nodeRequire, baseUrl: mixinPath }); require = function() { try { return nodeRequire.apply({}, arguments); } catch (e) { return requireJS.apply({}, arguments); } } ");
    
    // Add our new Mixin
    var mixin = new Mixin(mixinPath, mixinID, vmContext);
    loadedMixins.push(mixin);
    
    // Run init.js
    vm.runInContext(initJSSource, vmContext, pathToInitjs)
}
*/