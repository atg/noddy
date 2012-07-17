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

// Implement the Recipe class
var Recipe = {};
global.Recipe = Recipe;

// Implement the UI class
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

