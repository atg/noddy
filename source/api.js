var _ = require("underscore.js");
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
 * @param {Array} buttons an array of buttons to display. Buttons are displayed from right to left.
 * @return {Number} the index of the button that was clicked. 0 is the right-most button. 
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
    global.objc_msgSend(private_get_mixin(), "clipboard_copy:", value);
};


/**
 * Returns the last string that was copied to the clipboard.
 * @memberOf Clipboard
 * @returns {String} the last item from the clipboard.
 */
Clipboard.text = function() {
    return global.objc_msgSendSync(private_get_mixin(), "clipboard_paste");
};

// Implement the UI class
var Hooks = {};
global.Hooks = Hooks;

/**
 * Add a menu item at the given path.
 * 
 * @param {String} path the path of the new menu item.
 * @param {String} shortcut keyboard shortcut, e.g. `ctrl-alt-cmd-b`.
 * @param {Function} callback a callback to be executed when the menu item is selected.
 * @memberOf Hooks
 */
Hooks.addMenuItem = function(path, shortcut, callback) {
    global.objc_msgSend(private_get_mixin(), "ui_addMenuItem:", {
        "path": path,
        "shortcut": shortcut,
        "callback": callback
    });
};

/**
 * Add a keyboard shortcut.
 *
 * @param {String} shortcut the keyboard shortcut, e.g. `ctrl-alt-cmd-b`
 * @param {Function} callback the callback function to execute.
 * @memberOf Hooks
 */
Hooks.addKeyboardShortcut = function(shortcut, callback) {
    global.objc_msgSend(private_get_mixin(), "ui_addKeyboardShortcut:", {
        "shortcut": shortcut,
        "callback": callback
    });
};

/**
 * Add an item in the bottom status bar.
 * @param {String} name the name of the item to add.
 * @param {Function} valueFunction a function that will return the value to display in the status bar.
 * @param {String} selector a scope selector e.g. `source.objc`
 * @memberOf Hooks
 */
Hooks.addStatusItem = function (name, valueFunction, selector) {
    
};


/**
 * Remap a menu item to a new keyboard shortcut.
 * 
 * Example:
 * 
 *     UI.setShortcutForMenuItem("Go/Go To File...", "cmd-t");
 *
 * @param {String} path the path of the menu item to change.
 * @param {String} shortcut keyboard shortcut, e.g. `ctrl-alt-cmd-b`.
 * @memberOf Hooks
 */
Hooks.setShortcutForMenuItem = function(path, shortcut) {
    global.objc_msgSend(private_get_mixin(), "ui_setShortcutForMenuItem:", {
        "shortcut": shortcut,
        "path": path
    });
};var Storage = function(nid) {
    this.nid = nid;
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
    return global.objc_msgSendSync(this.nid, "valueForKey", k);
};

/**
 * Sets a value in the storage.
 *
 * @param {String} k the key to set.
 * @param {Object} v the value to set it to (can be anything).
 * @memberOf Storage
 */
Storage.prototype.set = function(k, v) {
    global.objc_msgSend(this.nid, "setValue:forKey:", v, k);
};

/**
 * Returns the number of keys in the storage.
 *s
 * @return {Number} number of keys in storage.
 * @memberOf Storage
 */
Storage.prototype.count = function() {
    return global.objc_msgSendSync(this.nid, "count");
};

/**
 * Applies function `f` to every items in the storage. The function should
 * have the following signature: `f(k, v)` where k is the key for the item
 * and v is its value.
 *
 * @param {Function} f the function to apply to each items `f(k,v)`.
 * @memberOf Storage
 */
Storage.prototype.forall = function(f) {
    var storage = global.objc_msgSendSync(this.nid, "dictionary");
    for (var k in storage) {
        f(k, storage[k]);
    }
};

var Util = function() {
    
};

Util.indentation = function(str) {
  
};

Util.spliceSubstring = function(str, part, loc, len) {
  
};

Util.slugifyString = function(str) {
    
};
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

// See https://github.com/fileability/chocolat/blob/master/code/multicursor/multicursor.hh#L6
// and https://github.com/fileability/chocolat/blob/master/code/multicursor/multicursor.cc
// for a well proven implementation.

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
 * Is the range valid?
 * 
 * - To be valid, both the `length` and `location` must be >= 0.
 *
 * - `length`, `location` and `length + location` must all be "small" (less than 2^30).
 *
 * - If `documentLength` is specified, `location + length` must not exceed it.
 * 
 * @param {Number} documentLength (optional) check that the indexes of this range are in <code>[0,&nbsp;documentLength)</code>.
 * @return {Boolean} whether the range is valid.
 * @memberOf Range
 */
Range.prototype.isValid = function(documentLength) {
    if (this.length < 0 || this.location < 0)
        return false;
    if (this.length >= 0x40000000 || this.location >= 0x40000000 || this.length + this.location >= 0x40000000)
        return false;
    if (typeof documentLength !== "undefined" && this.length + this.location > documentLength)
        return false;
    return true;
};

/**
 * Is the range's length 0?
 *
 * @return {Boolean} whether the range is empty.
 * @memberOf Range
 */
Range.prototype.isEmpty = function() {
    return this.length === 0;
};

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
 * Returns the last index in the range (`length + location - 1`), or `location` if the range is empty.
 * 
 * @return {Number} the last index in the range.
 * @memberOf Range
 */
Range.prototype.lastIndex = function() {
    if (this.length === 0)
        return this.location;
    return this.location + this.length - 1;
};

/**
 * Test whether the range has a given index. *If the range is empty (`length` is 0), then returns `false`.*
 * 
 * @param {Number} idx the index.
 * @return {Boolean} true if the range contains the given index.
 * @memberOf Range
 */
Range.prototype.hasIndex = function(idx) {
    return this.isValid() && idx >= this.location && this.length > 0 && idx < this.location + this.length;
};

/**
 * Test whether the range has a given index. *If the range is empty (`length` is 0), then it treats it as a range of `length == 1`.*
 * 
 * @param {Number} idx the index.
 * @return {Boolean} true if the range contains the given index.
 * @memberOf Range
 */
Range.prototype.containsIndex = function(idx) {
    return this.isValid() && idx >= this.location && (idx < this.location + this.length || this.length === 0);
};

/**
 * Checks if two ranges's indexes overlap. *If either range is empty, returns `false`.*
 *
 * @param {Range} rng a range.
 * @return {Boolean} whether the given range is overlaps with this range.
 * @memberOf Range
 */
Range.prototype.overlapsWith = function(rng) {
    if (this.length === 0 || rng.length === 0)
        return false;
    return rng.hasIndex(this.lastIndex()) || rng.hasIndex(this.location);
};

/**
 * Checks if two ranges's indexes overlap. *Considers empty ranges as if they were of length `1`.*
 *
 * @param {Range} rng a range.
 * @return {Boolean} whether the given range intersects with this range.
 * @memberOf Range
 */
Range.prototype.intersectsWith = function(rng) {
    if (this.length === 0 && rng.length === 0)
        return this.location === rng.location;
    if (rng.length === 0)
        return this.hasIndex(rng.location);
    if (this.length === 0)
        return rng.hasIndex(this.location);
    
    return rng.hasIndex(this.lastIndex()) || rng.hasIndex(this.location);
};


/**
 * Checks if all indexes of a given range are contained in this range.
 *
 * @param {Range} rng a range.
 * @return {Boolean} whether the given range is contained within this range.
 * @memberOf Range
 */
Range.prototype.containsRange = function(rng) {
    if (!this.isValid() || !rng.isValid())
        return false;
    if (this.isEmpty() && !rng.isEmpty())
        return false;
    return (this.location <= rng.location && rng.lastIndex() <= this.lastIndex());
};

/**
 * Checks if both ranges are equal (treats any two invalid ranges as equal).
 *
 * @param {Range} rng a range.
 * @return {Boolean} whether the given range is equal to this range.
 * @memberOf Range
 */
Range.prototype.equals = function(rng) {
    var thisvalid = this.isValid();
    var rngvalid = rng.isValid();
    if (thisvalid != rngvalid)
        return false;
    if (thisvalid && rngvalid)
        return true;
    return this.location == rng.location && this.length == rng.length;
};

/**
 * Returns a string in the form of `{loc, len}`. For debugging only, do not attempt to parse this string.
 *
 * @return {String} a string representation of the range.
 * @memberOf Range
 */
Range.prototype.toString = function() {
    if (!this.isValid())
        return "{invalid; " + String(this.location) + ", " + String(this.length) + "}";
    else
        return "{" + String(this.location) + ", " + String(this.length) + "}";
};

/**
 * Compare first by `location`, then by `length`. Treats any two invalid ranges as equal.
 *
 * @param {Range} a a range.
 * @param {Range} b another range.
 * @return {Number} <code>-1</code> if <code>a < b</code>, <code>1</code> if <code>a > b</code> or <code>0</code> if <code>a</code> and <code>b</code> are equal.
 * @memberOf Range
 */
Range.compare = function(a, b) {
    if (a.equals(b)) return 0;
    if (!a.isValid()) return 1;
    if (!b.isValid()) return -1;
    else if (a.location < b.location) return -1;
    else if (a.location > b.location) return 1;
    else if (a.length < b.length) return -1;
    else if (a.length > b.length) return 1;
    else return 0;
};

// Implement the Recipe class
var Recipe = function(nid) {
    this.nid = nid;
    this.jumpToShowSelection = false;
    this.showYellowIndicator = false;
};

global.Recipe = Recipe;

/**
 * Run a text recipe.
 *
 * Example:
 *     Recipe.run(function(recipe) {
 *         recipe.insertTextAtLocation(recipe.length, "Hello World!");
 *     });
 *
 * @param {Function(Recipe)} callback A callback function in which to make the changes. The function will be given an instance of Recipe as its argument, and may return false at any time in order to cancel the changes.
 * @memberOf Recipe
 */
Recipe.run = function(callback) {
    global.objc_msgSend(private_get_mixin(), "runRecipe:", function (nid) {
        callback(new Recipe(nid));
    });
};

/**
 * Get or set the editor's selected range.
 *
 * @return {Range} the selected character range.
 * @memberOf Recipe
 * @isproperty
 */
Recipe.prototype.selection = function() {
    global.objc_msgSendSync(this.nid, "selectionValue");
};
Recipe.prototype.setSelection = function(newText) {
    global.objc_msgSend(this.nid, "setSelectionValue:", newSelection);
};

Recipe.prototype.__defineGetter__("selection", Recipe.prototype.selection);
Recipe.prototype.__defineSetter__("selection", Recipe.prototype.setSelection);


/**
 * Get the length of the document.
 *
 * @return {Number} the length of the document.
 * @memberOf Recipe
 * @isproperty
 */
Recipe.prototype.length = function() {
    return global.objc_msgSendSync(this.nid, "numberLength");
};

Recipe.prototype.__defineGetter__("length", Recipe.prototype.length);


/**
 * Get or set the text of the document.
 *
 * @return {String} the content of the document.
 * @memberOf Recipe
 * @isproperty
 */
Recipe.prototype.text = function() {
    return global.objc_msgSendSync(this.nid, "text");
};

Recipe.prototype.setText = function(newText) {
    global.objc_msgSend(this.nid, "setText:", String(newText));
};

Recipe.prototype.__defineGetter__("text", Recipe.prototype.text);
Recipe.prototype.__defineSetter__("text", Recipe.prototype.setText);


/**
 * Returns text in range.
 *
 * @param {Range} rng the desired range.
 * @memberOf Recipe
 */
Recipe.prototype.textInRange = function(rng) {
    return global.objc_msgSendSync(this.nid, "textInRange:", rng);
};

/**
 * Expands a given range to cover the entire range of each line, *including* ending newlines.
 *
 * @param {Range} rng a range of characters to expand.
 * @memberOf Recipe
 */
Recipe.prototype.rangeOfLinesInRange = function(rng){
    return global.objc_msgSendSync(this.nid, "rangeOfLinesInRange:", rng);
};

/**
* Expands a given range to cover the entire range of each line, *excluding* ending newlines.
*
* @param {Range} rng a range of characters to expand.
* @memberOf Recipe
*/
Recipe.prototype.contentRangeOfLinesInRange = function(rng){
    return global.objc_msgSendSync(this.nid, "contentRangeOfLinesInRange:", rng);
};

/**
* Gives a range of line indexes (line numbers starting from zero) for the given character range.
*
* @param {Range} rng a range of characters.
* @memberOf Recipe
*/
Recipe.prototype.lineIndexesForCharacterRange = function(rng){
    return global.objc_msgSendSync(this.nid, "lineIndexesForCharacterRange:", rng);
};

/**
* Gives a character range for the given range of line indexes (line numbers starting from zero).
*
* @param {Range} rng a range of line indexes.
* @memberOf Recipe
*/
Recipe.prototype.characterRangeForLineIndexes = function(rng) {
    return global.objc_msgSendSync(this.nid, "characterRangeForLineIndexes:", rng);
};

/* Not sure we need this
Recipe.prototype.lineMarkersForCharacterRange = function(rng) {
  
};
*/

/**
 * Execute function `f` on lines in character range `rng`. If no range is passed, execute the function
 * on all the lines in the document.
 *
 * Example:
 *     // Wrap each line in brackets
 *     Recipe.run(function(recipe) {
 *             
 *         recipe.foreachLine(function(marker) {
 *             return "(" + marker.text + ")";
 *         });
 *     });
 *
 * @param {Function} f a function that is given a <a href="linemarker.html">LineMarker</a>. Return a new string to modify the line, null to delete the line, or undefined to keep the line the same.
 * @param {Range} rng an optional range. Defaults to the whole document if omitted.
 * @return {Number} the total number of characters added or deleted (0 if nothing was changed).
 * @memberOf Recipe
 */
Recipe.prototype.foreachLine = function(rng, f) {
    if (typeof rng === "undefined")
        rng = Range(0, this.length);
    
    return global.objc_msgSendSync(this.nid, "foreachLineInRange:callback:", rng, f);
};

/**
 * Replace text in `rng` with `replacement`, optionally recording the operation for undo.
 *
 * @param {Range} rng the range of text you want to replace.
 * @param {String} replacement the text to replace it with.
 * @param {Bool} recordUndo (optional) whether or not to record the operation for undo. The default is true.
 * @memberOf Recipe
 */
Recipe.prototype.replaceTextInRange = function(rng, replacement, recordUndo) {
    if (typeof recordUndo === "undefined")
        recordUndo = true;
    global.objc_msgSend(this.nid, "replaceText:inRangeValue:recordUndo:", replacement, rng, recordUndo);
};

/**
 * Delete text in range `rng`, optionally recording the operation for undo.
 *
 * @param {Range} rng the range of text to delete.
 * @param {Bool} recordUndo (optional) whether or not to record the operation for undo. The default is true.
 * @memberOf Recipe
 */
Recipe.prototype.deleteTextInRange = function(rng, recordUndo) {
    if (typeof recordUndo === "undefined")
        recordUndo = true;
    global.objc_msgSend(this.nid, "replaceText:inRangeValue:recordUndo:", "", rng, recordUndo);
};

/*
 * Insert text at specified location, optionally recording the operation for undo.
 *
 * @param {Number} location the location at which to insert the new text.
 * @param {String} newText the text to insert at <code>location</code>.
 * @param {Bool} recordUndo (optional) whether or not to record the operation for undo. The default is true.
 * @memberOf Recipe
 */
Recipe.prototype.insertTextAtLocation = function(location, newText, recordUndo) {
    if (typeof recordUndo === "undefined")
        recordUndo = true;
    global.objc_msgSend(this.nid, "replaceText:inRangeValue:recordUndo:", newText, Range(location, 0), recordUndo);
};

/**
 * Create a new window.
 * @memberOf Window
 * @isconstructor
 * @section Setup
 */
var Window = function() {
    this.nid = global.objc_msgSendSync(private_get_mixin(), "createWindow:", "Window");
};

global.Window = Window;

/**
 * Set up and display the window.
 *
 * Example:
 *     var win = new Window();
 *     win.html = "<!DOCTYPE html><h1>Test</h1>";
 *     win.buttons = ["OK"];
 *     win.onButtonClick = function() { win.close(); }
 *     win.run();
 *     win.maximize();
 *
 * @memberOf Window
 * @section Setup
 */
Window.prototype.run = function() {
    global.objc_msgSend(this.nid, "run");
};

/**
 * Get or set the title of the window.
 * 
 * Example:
 *     var win = new Window();
 *     win.title = "My window";
 * 
 * @return {String} the title of the window.
 * @isproperty
 * @memberOf Window
 * @section Basics
 */
Window.prototype.title = function() {
    return global.objc_msgSendSync(this.nid, "title");
};
Window.prototype.setTitle = function(callback) {
    global.objc_msgSend(this.nid, "setTitle:", callback);
};
Window.prototype.__defineGetter__("title", Window.prototype.title);
Window.prototype.__defineSetter__("title", Window.prototype.setTitle);


/**
 * Get or set the window's frame. Setter is equivalent to `.setFrame(rect, false)`.
 * @return {Rect} the window's frame.
 * @isproperty
 * @memberOf Window
 * @section Basics
 */
Window.prototype.frame = function() {
    return global.objc_msgSendSync(this.nid, "frame");
};

/**
 * Set the window's frame. The frame should be an object with the x, y, width and
 * height properties. e.g. `{x: 0, y: 0, width: 250, height: 300}`
 * @param {Rect} newFrame the new window's frame.
 * @param {Bool} shouldAnimate optional, whether to animate the resizing or not (default: false)
 * @memberOf Window
 * @section Basics
 */
Window.prototype.setFrame = function(newFrame, shouldAnimate) {
    if (typeof shouldAnimate === 'undefined') {
        shouldAnimate = false;
    }
    global.objc_msgSend(this.nid, "setFrame:animate:", newFrame, shouldAnimate);
};
Window.prototype.__defineGetter__("frame", Window.prototype.frame);
Window.prototype.__defineSetter__("frame", Window.prototype.setFrame);

/**
 * Center the window on screen. Must be called after run() has been invoked.
 * @memberOf Window
 * @section Basics
 */
Window.prototype.center = function() {
    global.objc_msgSend(this.nid, "center");
};

/**
 * Maximize the window so that it takes up the entire size of the screen.
 * @memberOf Window
 * @section Basics
 */
Window.prototype.maximize = function() {
    global.objc_msgSend(this.nid, "maximize");
};


/**
 * Permanently close the window. After a window is closed all resources are freed. Use `.hide()` to temporarily hide a window.
 * @memberOf Window
 * @section Visibility
 */
Window.prototype.close = function() {
    global.objc_msgSend(this.nid, "close");
};


/**
 * Show the window if it was previously hidden.
 * @memberOf Window
 * @section Visibility
 */
Window.prototype.show = function() {
    global.objc_msgSend(this.nid, "show");
};

/**
 * Hide the window offscreen but don't close it.
 * @memberOf Window
 * @section Visibility
 */
Window.prototype.hide = function() {
    global.objc_msgSend(this.nid, "hide");
};

/**
 * Hides a visible window or show a hidden window.
 * @return {Boolean} whether the window is *now* onscreen.
 * @memberOf Window
 * @section Visibility
 */
Window.prototype.toggleShown = function() {
    return global.objc_msgSendSync(this.nid, "toggle");
};

/**
 * Is this window onscreen?
 * @return {Boolean} whether the window is onscreen.
 * @memberOf Window
 * @section Visibility
 */
Window.prototype.isVisible = function() {
    return global.objc_msgSendSync(this.nid, "isVisible");
};

/**
 * Is this the key window? The key window receives key events.
 * @return {Boolean} whether the window is the key window.
 * @memberOf Window
 * @section Visibility
 */
Window.prototype.isKeyWindow = function() {
    return global.objc_msgSendSync(this.nid, "isKeyWindow");
};

/**
 * Is this the main window?
 * @return {Boolean} whether the window is the main window.
 * @memberOf Window
 * @section Visibility
 */
Window.prototype.isMainWindow = function() {
    return global.objc_msgSendSync(this.nid, "isMainWindow");
};

/**
 * Minimize the window into the dock.
 * @memberOf Window
 * @section Minimization
 */
Window.prototype.minimize = function() {
    global.objc_msgSend(this.nid, "minimize");
};

/**
 * Unminimize the window out of the dock.
 * @memberOf Window
 * @section Minimization
 */
Window.prototype.unminimize = function() {
    global.objc_msgSend(this.nid, "unminimize");
};

/**
 * Return whether the window is minimized.
 * @return {Boolean} whether the window is minimized.
 * @memberOf Window
 * @section Minimization
 */
Window.prototype.isMinimized = function() {
    return global.objc_msgSendSync(this.nid, "isMinimized");
};

/**
 * Get or set an `Array` of button names to be shown at the bottom of the window. Buttons are shown from right-to-left.
 * 
 * Example:
 *     var win = new Window();
 *     win.buttons = ["OK", "Cancel"];
 * 
 * @return {Array} the names of the buttons. Note that you cannot mutate the return value of this property, you must set it for it to be updated.
 * @isproperty
 * @memberOf Window
 * @section Setup
 */
Window.prototype.buttons = function() {
    return global.objc_msgSendSync(this.nid, "buttons");
};
Window.prototype.setButtons = function(newButtons) {
    global.objc_msgSend(this.nid, "setButtons:", newButtons);
};
Window.prototype.__defineGetter__("buttons", Window.prototype.buttons);
Window.prototype.__defineSetter__("buttons", Window.prototype.setButtons);

/**
 * Get or set a callback function that will be called when a button is clicked.
 * 
 * Example:
 *     var win = new Window();
 *     win.buttons = ["OK", "Cancel"];
 *     win.onButtonClick = function (buttonName) {
 *         console.log("Clicked " + buttonName);
 *     }
 * 
 * @return {Function(String)} a callback function with one argument: the name of the button that was clicked.
 * @isproperty
 * @memberOf Window
 * @section Events
 */
Window.prototype.onButtonClick = function() {
    return global.objc_msgSendSync(this.nid, "onButtonClick");
};
Window.prototype.setOnButtonClick = function(callback) {
    global.objc_msgSend(this.nid, "setOnButtonClick:", callback);
};
Window.prototype.__defineGetter__("onButtonClick", Window.prototype.onButtonClick);
Window.prototype.__defineSetter__("onButtonClick", Window.prototype.setOnButtonClick);

/**
 * Get or set a callback function that will be called when the client JS sends a message.
 * 
 * Example:
 *     // Client code
 *     window.sendMessage("hello", [1, 2, 3]);
 *     
 *     // Server code
 *     win.onMessage = function (name, arguments) {
 *         // name == "hello", arguments == [1, 2, 3]
 *     }
 * 
 * @return {Function(String, Array or Object)} a callback function with two arguments: the first is the name of the message, the second is the arguments passed to it
 * @isproperty
 * @memberOf Window
 * @section Events
 */
Window.prototype.onMessage = function() {
    return global.objc_msgSendSync(this.nid, "onMessage");
};
Window.prototype.setOnMessage = function(callback) {
    global.objc_msgSend(this.nid, "setOnMessage:", function (name, args) {
        return callback(name, JSON.parse(args)[0]);
    });
};
Window.prototype.__defineGetter__("onMessage", Window.prototype.onMessage);
Window.prototype.__defineSetter__("onMessage", Window.prototype.setOnMessage);


/**
 * Get or set a function that will be called *in the client context* when the page loads. Equivalent to setting an onload attribute. Useful if using default.html to build up the page exclusively in JS.
 * 
 * Example:
 *     var win = new Window()
 *     win.htmlPath = "default.html";
 *     win.onLoad = function () {
 *         document.body.innerHTML = "<h1>Hello World</h1>";
 *     };
 *     win.run();
 * 
 * @return {Function} a function that will run in the client JS. Referencing anything in the server JS won't work.
 * @isproperty
 * @memberOf Window
 * @section Events
 */
Window.prototype.onLoad = function() {
    return global.objc_msgSendSync(this.nid, "onLoad");
};
Window.prototype.setOnLoad = function(callback) {
    global.objc_msgSend(this.nid, "setOnLoad:", callback.toString());
};
Window.prototype.__defineGetter__("onLoad", Window.prototype.onLoad);
Window.prototype.__defineSetter__("onLoad", Window.prototype.setOnLoad);



/**
 * Get or set a path to the HTML file that will be shown in the window. Can be either absolute or relative. Relative paths are relative to the mixin's directory.
 * 
 * Example:
 *     var win = new Window();
 *     win.htmlPath = "index.html";
 * 
 * @return {String} the path to the HTML file.
 * @isproperty
 * @memberOf Window
 * @section Setup
 */
Window.prototype.htmlPath = function() {
    return global.objc_msgSendSync(this.nid, "htmlPath");
};
Window.prototype.setHtmlPath = function(newHtml) {
    global.objc_msgSend(this.nid, "setHtmlPath:", (newHtml != null ? String(newHtml) : null));
};
Window.prototype.__defineGetter__("htmlPath", Window.prototype.htmlPath);
Window.prototype.__defineSetter__("htmlPath", Window.prototype.setHtmlPath);


/**
 * Set the source of HTML file that will be shown in the window. Mutually exclusive with `.htmlPath`.
 * 
 * Example:
 *     var win = new Window();
 *     win.html = "<!DOCTYPE html><h1>Test</h1>";
 * 
 * @return {String} the path to the HTML file.
 * @isproperty
 * @memberOf Window
 * @section Setup
 */
Window.prototype.html = function() {
    return global.objc_msgSendSync(this.nid, "html");
};
Window.prototype.setHtml = function(newHtml) {
    global.objc_msgSend(this.nid, "setHtml:", (newHtml != null ? String(newHtml) : null));
};

Window.prototype.__defineGetter__("html", Window.prototype.html);
Window.prototype.__defineSetter__("html", Window.prototype.setHtml);

/**
 * Eval some code on the client-side.
 * 
 * Example:
 *     win.eval("document.write('Some text')");
 * 
 * @param {String} code some code to evaluate on the client-side.
 * @memberOf Window
 * @section Communication
 */
Window.prototype.eval = function(code) {
    global.objc_msgSend(this.nid, "client_eval:", code);
};

/**
 * Add a function to the client-side JS.
 * 
 * Example:
 *     win.eval("document.write('Some text')");
 * 
 * @param {String} code some code to evaluate on the client-side.
 * @memberOf Window
 * @section Communication
 */
Window.prototype.addFunction = function(name, f) {
    if (arguments.length == 1) {
        f = name;
        name = f.name;
    }
    global.objc_msgSend(this.nid, "client_addFunction:named:", f.toString(), name);
};

/**
 * Send a message to the window that you can catch with the window.onMessage attribute.
 * 
 * Example:
 *     win.sendMessage("I'm sending a message", [42]);
 * 
 * @param {String} msg the name of the message to send.
 * @param {Value} args an argument to pass to the callback function.
 * @memberOf Window
 * @section Communication
 */
Window.prototype.sendMessage = function (msg, args) {
    if (arg == null) {
        arg = [];
    }
    
    global.objc_msgSend(this.nid, "client_sendMessage:arguments:", msg, JSON.stringify([args]));
};

/**
 * Call a named function or a function literal on the client side.
 * 
 * Example:
 *     win.applyFunction("updateData", [42, 3.14, 2.71828]);
 *     
 *     win.applyFunction(function(data) {
 *         document.write(data.join("<br>"));
 *     }, [42, 3.14, 2.71828]);
 * 
 * @param {String|Function} f either the name of a client function, or a function literal to call in the client context.
 * @param {Array} args a list of arguments to pass to the function.
 * @memberOf Window
 * @section Communication
 */
Window.prototype.applyFunction = function(f, args) {
    if (args == null) {
        args = [];
    }
    
    if (typeof f === "string") {
        global.objc_msgSend(this.nid, "client_callFunctionNamed:jsonArguments:", f, JSON.stringify([args]));
    }
    else {
        global.objc_msgSend(this.nid, "client_callFunctionCode:jsonArguments:", f.toString(), JSON.stringify([args]));
    }
};

/**
* Create a new sheet.
* @memberOf Sheet
*/
var Sheet = function(w) {
  Window.call(this);
  this.parentWindow = w;
};

noddyInherit(Sheet, Window);

global.Sheet = Sheet;

/**
 * Creates a new Popover.
 * 
 * @param {Range} range the range of text over which the popover should appear.
 * @param {Editor} editor the editor containing the text.
 * @memberOf Popover
 */
var Popover = function(range, editor) {
  Window.call(this);
  this.range = range;
  this.editor = editor;
};

noddyInherit(Popover, Window);
global.Popover = Popover;

// MainWindow, Tab, Document and Editor

/**
 * @api private
 */
var MainWindow = function(nid) {
  this.nid = nid;
};

global.MainWindow = MainWindow;

/**
 * Class method that returns the current window.
 *
 * @return {MainWindow} the current MainWindow.
 * @memberOf MainWindow
 */
MainWindow.current = function() {
    var someNid = global.objc_msgSendSync(private_get_mixin(), "mainwindow_current");
    return new MainWindow(someNid);
};

/**
 * Returns and array of tabs in the main window.
 *
 * @return {Array} tabs.
 * @memberOf MainWindow
 */
MainWindow.prototype.tabs = function() {
    return global.objc_msgSendSync(this.nid, "mainwindow_tabs");
};

/**
 * Get the current, active tab from the main window.
 *
 * @return {Tab} the active tab in the main window.
 * @memberOf MainWindow
 */
MainWindow.prototype.currentTab = function() {
    return global.objc_msgSendSync(this.nid, "mainwindow_currentTab");
};

/**
 * Send an objective-c message to the MainWindow.
 *
 * @param {String} selector the message selector to send.
 * @param {Array} arguments the arguments to send along with the message.
 * @memberOf MainWindow
 */
MainWindow.prototype.sendMessage = function(selector, arguments) {
    global.objc_msgSend(this.nid, "mainwindow_current", {
        "selector": selector,
        "arguments": arguments
    });
};

/**
 * Access the storage object of the MainWindow (see Storage class).
 *
 * @return {Storage} the storage.
 * @memberOf MainWindow
 */
MainWindow.prototype.storage = function() {
    return new Storage(global.objc_msgSendSync(this.nid, "mainwindow_storage"));
};

/**
 * @api private
 */
var Tab = function(nid) {
  this.nid = nid;
};

global.Tab = Tab;

/**
 * Class method that returns the current, active tab.
 *
 * @return {Tab} the active tab.
 * @memberOf Tab
 */
Tab.current = function() {
    var tabNid = global.objc_msgSendSync(private_get_mixin(), "tab_current");
    return new Tab(someNid);
};

/**
 * The window which the tab is part of
 *
 * @return {MainWindow} the parent MainWindow.
 * @memberOf Tab
 */
Tab.prototype.window = function() {
    return new MainWindow(global.objc_msgSendSync(this.nid, "tab_window"));
};

/**
* Get a list of all visible editors in the tab.
*
* @return {Array} an array of visible `Editor`s.
* @memberOf Tab
*/
Tab.prototype.editors = function() {
    var myEditors = global.objc_msgSendSync(this.nid, "tab_editors");
    return _.map(myEditors, function(editorId){ return new Editor(editorId);});
};

/**
* Get the active editor in this tab.
*
* @return {Editor} the current editor.
* @memberOf Tab
*/
Tab.prototype.currentEditor = function() {
  return new Editor(global.objc_msgSendSync(this.nid, "tab_currentEditor"));
};

/**
* Get a list of all the documents in the "Active" part of the sidebar.
*
* @return {Array} an array containing the active `Document`s
* @memberOf Tab
*/
Tab.prototype.activeDocuments = function() {
    var activeDocs = global.objc_msgSendSync(this.nid, "tab_activeDocuments");
    return _.map(activeDocs, function(docId){ return new Document(docId);});
};

/**
* A list of all the `Document`s currently visible in this tab.
*
* @return {Array} an array containing the visible `Document`s
* @memberOf Tab
*/
Tab.prototype.visibleDocuments = function() {
    var visibleDocs = global.objc_msgSendSync(this.nid, "tab_visibleDocuments");
    return _.map(visibleDocs, function(docId){ return new Document(docId);});
};

/**
 * Access the storage object of the Tab (see Storage class).
 *
 * @return {Storage} the storage.
 * @memberOf Tab
 */
Tab.prototype.storage = function() {
    return new Storage(global.objc_msgSendSync(this.nid, "tab_storage"));
};

/**
 * @api private
 */
var Document = function(nid) {
  this.nid = nid;
};

global.Document = Document;

/**
 * Class method that returns the current Document.
 *
 * @return {Document} the active document.
 * @memberOf Document
 */
Document.current = function() {
    return new Document(global.objc_msgSendSync(private_get_mixin(), "document_current"));
};

/**
 * Get the display name of a document.
 *
 * @return {String} the display name of a document.
 * @memberOf Document
 */
Document.prototype.displayName = function() {
    return global.objc_msgSendSync(this.nid, "document_displayName");
};

/**
 * Get the file name of a document.
 *
 * @return {String} the filename of a document.
 * @memberOf Document
 */
Document.prototype.filename = function() {
    return global.objc_msgSendSync(this.nid, "document_filename");
};

/**
 * Get the path of a document.
 *
 * @return {String} the path of the file on disk, null if it's unsaved.
 * @memberOf Document
 */
Document.prototype.path = function() {
    return global.objc_msgSendSync(this.nid, "document_path");
};

/**
 * Get the root scope of a document, e.g. source.objc or text.html
 *
 * @return {String} the root scope of the document.
 * @memberOf Document
 */
Document.prototype.rootScope = function() {
    return global.objc_msgSendSync(this.nid, "document_rootScope");
};

/**
 * Get the context (list of scopes) at a particular index.
 *
 * @param {Number} idx an index.
 * @return {Array} a list of scopes for the given index.
 * @memberOf Document
 */
Document.prototype.contextAtIndex = function(idx) {
    return global.objc_msgSendSync(this.nid, "document_contextAtIndex:", idx);
};

/**
 * Get an array of Editor objects for a document.
 *
 * @return {Array} an array of Editor objects.
 * @memberOf Document
 */
Document.prototype.editors = function() {
    var myEditors = global.objc_msgSendSync(this.nid, "document_editors");
    return _.map(myEditors, function(editorId){ return new Editor(editorId);});
};

/**
 * Get the length of the document.
 *
 * @return {Number} the length of the document.
 * @memberOf Document
 * @isproperty
 */
Document.prototype.length = function() {
    return global.objc_msgSendSync(this.nid, "document_length");
};
Document.prototype.__defineGetter__("length", Document.prototype.length);

/**
 * Get or set the text of the document.
 *
 * @return {String} the content of the document.
 * @memberOf Document
 * @isproperty
 */
Document.prototype.text = function() {
    return global.objc_msgSendSync(this.nid, "document_text");
};

Document.prototype.setText = function(newText) {
    global.objc_msgSend(this.nid, "document_setText:", newText);
};
Document.prototype.__defineGetter__("text", Document.prototype.text);
Document.prototype.__defineSetter__("text", Document.prototype.setText);

/**
 * Get the text in a given range
 *
 * @param {Range} rng a range.
 * @return {String} the text at given range.
 * @memberOf Document
 */
Document.prototype.textInRange = function(rng) {
    return global.objc_msgSendSync(this.nid, "document_textInRange:", rng);
};

/**
 * Replace the text in `rng` with `replacement`.
 *
 * @param {Range} rng a range.
 * @param {String} replacement the replacement string.
 * @memberOf Document
 */
Document.prototype.replaceTextInRange = function(rng, replacement) {
    global.objc_msgSend(this.nid, "document_replaceTextInRange:", {"rng": rng, "replacement": replacement});
};

/**
 * Access the storage object of the Document (see Storage class).
 *
 * @return {Storage} the storage.
 * @memberOf Document
 */
Document.prototype.storage = function() {
    return new Storage(global.objc_msgSendSync(this.nid, "document_storage"));
};


/**
 * @api private
 */
var Editor = function(nid) {
  this.nid = nid;
};

global.Editor = Editor;

/**
 * Class method that returns the current Editor.
 *
 * @return {Editor} the active editor.
 * @memberOf Editor
 */
Editor.current = function() {
    return new Editor(global.objc_msgSendSync(private_get_mixin(), "editor_current"));
};

/**
 * The document edited by this editor.
 *
 * @return {Document} the document being edited.
 * @memberOf Editor
 */
Editor.prototype.document = function() {
    return new Document(global.objc_msgSendSync(this.nid, "editor_document"));
};

/**
 * Get or set the selected text in this editor.
 * 
 * @return {Range} the range of the selected text.
 * @memberOf Editor
 * @isproperty
 */
Editor.prototype.selection = function() {
    return global.objc_msgSendSync(this.nid, "editor_selection");
};

Editor.prototype.setSelection = function(rng) {
    global.objc_msgSend(this.nid, "editor_setSelection:", rng);
};

Editor.prototype.__defineGetter__("selection", Editor.prototype.selection);
Editor.prototype.__defineSetter__("selection", Editor.prototype.setSelection);


/**
 * Get the range of text that is visible in this editor.
 *
 * @return {Range} the range of visible text.
 * @memberOf Editor
 */
Editor.prototype.visibleRange = function() {
  return global.objc_msgSendSync(this.nid, "editor_visibleRange");
};

/**
 * Get the context (list of scopes) at the editor's selection.
 *
 * @return {Array} a list of scopes for the selection.
 * @memberOf Editor
 */
Editor.prototype.selectionContext = function() {
  return global.objc_msgSendSync(this.nid, "editor_selectionContext");
};

/**
 * Insert a snippet where the cursor is located.
 *
 * @param {String} snippet a snippet.
 * @memberOf Editor
 */
Editor.prototype.insertSnippet = function(snippet) {
    global.objc_msgSend(this.nid, "editor_insertSnippet:", snippet);
};

/**
 * Access the storage object of the Editor (see Storage class).
 *
 * @return {Storage} the storage.
 * @memberOf Editor
 */
Editor.prototype.storage = function() {
    return new Storage(global.objc_msgSendSync(this.nid, "editor_storage"));
};

