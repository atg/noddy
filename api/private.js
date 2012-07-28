var _ = require("underscore.js");
/**
 * @api private
 */
function private_get_mixin() {
    var stacktrace = new Error().stack;
    
    // Find things named /X.chocmixin
    var m = new RegExp("/([^/]+)\\.chocmixin", "i").exec(stacktrace);
    if (m.length >= 2 && m[1].length)
        return "NODDYID$$MIXIN$$" + m[1];
    if (current_mixin_name != null)
        return "NODDYID$$MIXIN$$" + global.current_mixin_name;
    return null;
}

/**
* @api private
*/
function createObject(parent) {
 function TempClass() {}
 TempClass.prototype = parent;
 var child = new TempClass();
 return child;
}

/**
* @api private
*/
function noddyInherit(sub, superObj) {
 var newSubPrototype = createObject(superObj.prototype); 
 newSubPrototype.constructor = sub; 
 sub.prototype = newSubPrototype;
}

