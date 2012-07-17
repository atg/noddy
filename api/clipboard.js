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