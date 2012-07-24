/**
 * @api private
 */
function private_get_mixin() {
    var stacktrace = new Error().stack;
    
    // Find things named /X.chocmixin
    var m = new RegExp("/([^/]+)\\.chocmixin", "i").exec(stacktrace);
    if (m.length >= 2)
        return "NODDYID$$MIXIN$$" + m[1];
    
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
function inherit(sub, super) {
 var newSubPrototype = createObject(super.prototype); 
 newSubPrototype.constructor = sub; 
 sub.prototype = newSubPrototype;
}

