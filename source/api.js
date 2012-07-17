var Alert = {};
global.Alert = Alert;


/**
 * Shows an alert.
 *
 * Example:
 * 
 *     Alert.show("My Title", "My awesome body!", ["Yes", "No"]);
 *
 * @param {String} title the title of your alert.
 * @param {String} message the body of your alert message.
 * @param {Array} buttons an array of buttons to display.
 * @memberOf Alert
 *
 */
Alert.show = function(title, message, buttons) {
    
    return global.objc_msgSendSync(private_get_mixin(), "showAlert:", {
        "title": title,
        "message": message,
        "buttons": buttons
    });
};

var Clipboard = {};
global.Clipboard = Clipboard;

/**
 * Copy a string into the clipboard so that it can be pasted later.
 * @memberOf Clipboard
 * @param {String} value the value to copy.
 */
Clipboard.copy = function(value) {
    global.objc_msgSendSync(private_get_mixin(), "clipboard_copy", value);
};


/**
 * Returns the last string that was copied to the clipboard.
 * @memberOf Clipboard
 * @returns {String} the last item from the clipboard.
 */
Clipboard.paste = function() {
    return global.objc_msgSendSync(private_get_mixin(), "clipboard_paste");
};

var Storage = function() {
    this.storage = {};
};

global.Storage = Storage;

/**
 * Retrieves a value in the storage.
 *
 * @param {String} k the key to retrieve.
 * @return {Object} the value for the given key.
 * @memberOf Storage
 */
Storage.prototype.get = function(k) {
    return this.storage[k];
};

/**
 * Sets a value in the storage.
 *
 * @param {String} k the key to set.
 * @param {Object} v the value to set it to (can be anything).
 * @memberOf Storage
 */
Storage.prototype.set = function(k, v) {
    this.storage[k] = v;
}

/**
 * Returns the number of keys in the storage.
 *
 * @return {Number} number of keys in storage.
 * @memberOf Storage
 */
Storage.prototype.count = function() {
    return Object.keys(this.storage).length;
}

/**
 * Applies function `f` to every items in the storage. The function should
 * have the following signature: `f(k, v)` where k is the key for the item
 * and v is its value.
 *
 * @param {Function} f the function to apply to each items `f(k,v)`.
 * @memberOf Storage
 */
Storage.prototype.forall = function(f) {
    for (var k in this.storage) {
        f(k, this.storage[k]);
    }
}/**
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
 * Creates a new Range.
 * 
 * @param {Number} loc the starting location (or index) of the range.
 * @param {Number} len the length of the range.
 */
var Range = function(loc, len) {
    this.location = loc;
    this.length = len;
}

global.Range = Range;

/**
 * Returns the end of the range (i.e. location + length)
 * 
 * @return {Number} the end of the range.
 * @memberOf Range
 */
Range.prototype.max = function() {
    return this.location + this.length;
};

/**
 * Returns the range's location
 * 
 * @return {Number} the location of the range.
 * @memberOf Range
 */
Range.prototype.min = function() {
    return this.location;
};

/**
 * Check if a range is contained in another range.
 *
 * @param {Object} rng a range.
 * @return {Bool} whether the given range is contained within this range.
 * @memberOf Range
 */
Range.prototype.containsRange = function(rng) {
    return (this.location >= rng.location && this.length <= rng.length);
};

// Implement the Recipe class
var Recipe = function() {
    
};

global.Recipe = Recipe;

Recipe.run = function() {
    
};

Recipe.prototype.length = function() {
    
};

Recipe.prototype.text = function() {
    
};

Recipe.prototype.rangeOfLinesInRange = function(rng) {
    
};// Implement the UI class
var UI = {};
global.UI = UI;

/**
 * Add a menu item at the given path.
 * 
 * @param {String} path the path of the new menu item.
 * @param {String} shortcut keyboard shortcut, e.g. `ctrl-alt-cmd-b`.
 * @param {Function} callback a callback to be executed when the menu item is selected.
 * @memberOf UI
 */
UI.addMenuItem = function(path, shortcut, options, callback) {
    
};

/**
 * Add a keyboard shortcut.
 *
 * @param {String} shortcut the keyboard shortcut, e.g. `ctrl-alt-cmd-b`
 * @param {Function} callback the callback function to execute.
 * @memberOf UI
 */
UI.addKeyboardShortcut = function(shortcut, callback) {
    
};

/**
 * Add an item in the bottom status bar.
 * @param {String} name the name of the item to add.
 * @param {Function} valueFunction a function that will return the value to display in the status bar.
 * @param {String} selector a scope selector e.g. `source.objc`
 * @memberOf UI
 */
UI.addStatusItem = function (name, valueFunction, selector) {
    
};

// Implement the MainWindow, Tab, Editor and Document classes

