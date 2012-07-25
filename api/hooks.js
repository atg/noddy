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
UI.addMenuItem = function(path, shortcut, callback) {
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
 * @memberOf UI
 */
UI.addKeyboardShortcut = function(shortcut, callback) {
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
 * @memberOf UI
 */
UI.addStatusItem = function (name, valueFunction, selector) {
    
};


/**
 * Remap a menu item to a new keyboard shortcut.
 * 
 * @param {String} path the path of the new menu item.
 * @param {String} shortcut keyboard shortcut, e.g. `ctrl-alt-cmd-b`.
 * @memberOf UI
 */
UI.setShortcutForMenuItem = function(path, shortcut) {
    global.objc_msgSend(private_get_mixin(), "ui_setShortcutForMenuItem:", {
        "shortcut": shortcut,
        "path": path
    });
};