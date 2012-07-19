// MainWindow, Tab, Document and Editor

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
  
};

/**
 * Returns and array of tabs in the main window.
 *
 * @return {Array} tabs.
 * @memberOf MainWindow
 */
MainWindow.prototype.tabs = function() {
  
};

/**
 * Get the current, active tab from the main window.
 *
 * @return {Tab} the active tab in the main window.
 * @memberOf MainWindow
 */
MainWindow.prototype.currentTab = function() {
  
};

/**
 * Send an objective-c message to the MainWindow.
 *
 * @param {String} selector the message selector to send.
 * @param {Array} arguments the arguments to send along with the message.
 * @memberOf MainWindow
 */
MainWindow.prototype.sendMessage = function(selector, arguments) {
  
};

/**
 * Access the storage object of the MainWindow (see Storage class).
 *
 * @return {Storage} the storage.
 * @memberOf MainWindow
 */
MainWindow.prototype.storage = function() {
  
};