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
