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
};

global.Window = Window;

/**
 * Display the window.
 * @memberOf Window
 */
Window.prototype.run = function() {

};

/**
 * Close the window.
 * @memberOf Window
 */
Window.prototype.close = function() {

};

/**
 * Get the window's frame.
 * @return the window's frame.
 * @memberOf Window
 */
Window.prototype.frame = function() {

};

/**
 * Set the window's frame. The frame should be an object with the x, y, width and
 * height properties. e.g. `{x: 0, y: 0, width: 250, height: 300}`
 * @param {Object} newFrame the new window's frame.
 * @param {Bool} shouldAnimate optional, whether to animate the resizing or not (default: false)
 * @memberOf Window
 */
Window.prototype.setFrame = function(newFrame, shouldAnimate) {
  if (typeof shouldAnimate === 'undefined') {shouldAnimate = false;}

};

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

