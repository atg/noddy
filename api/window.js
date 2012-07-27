/**
 * Create a new window.
 * @memberOf Window
 */
var Window = function() {
  this.resourcePath = '';
  this.indexPath = '';
  this.generateHTML = '';
  this.canResize = true;
  this.onLoad = null;
  this.onMessage = null;
    
    this.nid = global.objc_msgSendSync(private_get_mixin(), "createWindow:", "Window");
};

global.Window = Window;

/**
 * Display the window.
 * @memberOf Window
 */
Window.prototype.run = function() {
    global.objc_msgSend(this.nid, "run");
};

/**
 * Close the window.
 * @memberOf Window
 */
Window.prototype.close = function() {
    global.objc_msgSend(this.nid, "close");
};

/**
 * Get the window's frame.
 * @return the window's frame.
 * @memberOf Window
 */
Window.prototype.frame = function() {
    return global.objc_msgSendSync(this.nid, "frame");
};

/**
 * Set the window's frame. The frame should be an object with the x, y, width and
 * height properties. e.g. `{x: 0, y: 0, width: 250, height: 300}`
 * @param {Object} newFrame the new window's frame.
 * @param {Bool} shouldAnimate optional, whether to animate the resizing or not (default: false)
 * @memberOf Window
 */
Window.prototype.setFrame = function(newFrame, shouldAnimate) {
    if (typeof shouldAnimate === 'undefined') {
        shouldAnimate = false;
    }
    global.objc_msgSend(this.nid, "setFrame:animate:", newFrame, shouldAnimate);
};

Window.prototype.buttons = function() {
    return global.objc_msgSendSync(this.nid, "buttons");
};
Window.prototype.setButtons = function(newButtons) {
    global.objc_msgSend(this.nid, "setButtons:", newButtons);
};
Window.prototype.__defineGetter__("buttons", Window.prototype.buttons);
Window.prototype.__defineSetter__("buttons", Window.prototype.setButtons);


Window.prototype.onButtonClick = function() {
    return global.objc_msgSendSync(this.nid, "onButtonClick");
};
Window.prototype.setOnButtonClick = function(callback) {
    global.objc_msgSend(this.nid, "setOnButtonClick:", callback);
};
Window.prototype.__defineGetter__("onButtonClick", Window.prototype.onButtonClick);
Window.prototype.__defineSetter__("onButtonClick", Window.prototype.setOnButtonClick);


Window.prototype.onMessage = function() {
    return global.objc_msgSendSync(this.nid, "onMessage");
};
Window.prototype.setOnMessage = function(callback) {
    global.objc_msgSend(this.nid, "setOnMessage:", callback);
};
Window.prototype.__defineGetter__("onMessage", Window.prototype.onMessage);
Window.prototype.__defineSetter__("onMessage", Window.prototype.setOnMessage);



Window.prototype.title = function() {
    return global.objc_msgSendSync(this.nid, "title");
};
Window.prototype.setTitle = function(callback) {
    global.objc_msgSend(this.nid, "setTitle:", callback);
};
Window.prototype.__defineGetter__("title", Window.prototype.title);
Window.prototype.__defineSetter__("title", Window.prototype.setTitle);



Window.prototype.htmlPath = function() {
    return global.objc_msgSendSync(this.nid, "htmlPath");
};
Window.prototype.setHtmlPath = function(newHtml) {
    global.objc_msgSend(this.nid, "setHtmlPath:", (newHtml != null ? String(newHtml) : null));
};
Window.prototype.__defineGetter__("htmlPath", Window.prototype.htmlPath);
Window.prototype.__defineSetter__("htmlPath", Window.prototype.setHtmlPath);



Window.prototype.html = function() {
    return global.objc_msgSendSync(this.nid, "html");
};
Window.prototype.setHtml = function(newHtml) {
    global.objc_msgSend(this.nid, "setHtml:", (newHtml != null ? String(newHtml) : null));
};

Window.prototype.__defineGetter__("html", Window.prototype.html);
Window.prototype.__defineSetter__("html", Window.prototype.setHtml);




Window.prototype.eval = function(str) {

};

Window.prototype.addFunction = function(name, f) {

};

/**
 * Send a message to the window that you can catch with the window.onMessage attribute.
 * @param {String} msg the name of the message to send.
 * @param {Value} arg an argument to pass to the callback function.
 * @memberOf Window
 */
Window.prototype.sendMessage = function (msg, arg) {

};

/**
* Create a new sheet.
* @memberOf Sheet
*/
var Sheet = function(w) {
  Window.call(this);
  this.parentWindow = w;
}

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

