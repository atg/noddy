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

};

/**
 * The document edited by this editor.
 *
 * @return {Document} the document being edited.
 * @memberOf Editor
 */
Editor.prototype.document = function() {
  
};

/**
 * Get or set the selected text in this editor.
 * 
 * @return {Range} the range of the selected text.
 * @memberOf Editor
 * @isproperty
 */
Editor.prototype.selection = function() {
  
};

Editor.prototype.setSelection = function(rng) {
  
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
  
};

/**
 * Get the context (list of scopes) at the editor's selection.
 *
 * @return {Array} a list of scopes for the selection.
 * @memberOf Editor
 */
Editor.prototype.selectionContext = function() {
  
};

/**
 * Insert a snippet where the cursor is located.
 *
 * @param {String} snippet a snippet.
 * @memberOf Editor
 */
Editor.prototype.insertSnippet = function(snippet) {

};

/**
 * Access the storage object of the Editor (see Storage class).
 *
 * @return {Storage} the storage.
 * @memberOf Editor
 */
Editor.prototype.storage = function() {

};

