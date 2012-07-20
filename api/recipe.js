// Implement the Recipe class
var Recipe = function() {
    this.jumpToShowSelection = false;
    this.showYellowIndicator = false;
};

global.Recipe = Recipe;

/**
 * Run the recipe
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
    
};

/**
 * Returns the editor's selected range.
 *
 * @return {Range} the selected character range.
 * @memberOf Recipe
 */
Recipe.prototype.selection = function() {

};

/**
 * Set the editor's selected range.
 *
 * @return {Range} the selected character range.
 * @memberOf Recipe
 */
Recipe.prototype.setSelection = function(newText) {

};

Recipe.prototype.__defineGetter__("selection", Recipe.prototype.selection);
Recipe.prototype.__defineSetter__("selection", Recipe.prototype.setSelection);


/**
 * Returns the length of the document.
 *
 * @return {Number} the length of the document.
 * @memberOf Recipe
 */
Recipe.prototype.length = function() {
    
};

// We actually want a property but dox doesn't know how to deal with those
Recipe.prototype.__defineGetter__("length", Recipe.prototype.length);

/**
 * Returns the text of the document.
 *
 * @return {String} the content of the document.
 * @memberOf Recipe
 */
Recipe.prototype.text = function() {
    
};

/**
 * Set the document's text.
 *
 * @return {String} the content of the document.
 * @memberOf Recipe
 */
Recipe.prototype.setText = function(newText) {
    
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
    
};

/**
 * Expands a given range to cover the entire range of each line, *including* ending newlines.
 *
 * @param {Range} rng a range of characters to expand.
 * @memberOf Recipe
 */
Recipe.prototype.rangeOfLinesInRange = function(rng){
  
};

/**
* Expands a given range to cover the entire range of each line, *excluding* ending newlines.
*
* @param {Range} rng a range of characters to expand.
* @memberOf Recipe
*/
Recipe.prototype.contentRangeOfLinesInRange = function(rng){
  
};

/**
* Gives a range of line indexes (line numbers starting from zero) for the given character range.
*
* @param {Range} rng a range of characters.
* @memberOf Recipe
*/
Recipe.prototype.lineIndexesForCharacterRange = function(rng){
  
};

/**
* Gives a character range for the given range of line indexes (line numbers starting from zero).
*
* @param {Range} rng a range of line indexes.
* @memberOf Recipe
*/
Recipe.prototype.characterRangeForLineIndexes = function(rng) {
  
};

/* Not sure we need this
Recipe.prototype.lineMarkersForCharacterRange = function(rng) {
  
};
*/

/**
 * Execute function `f` on lines in character range `rng`. If no range is passed, execute the function
 * on all the lines in the document.
 *
 * @param {Function} f a function with a single argument: the a line marker. Return a string to replace it with (excluding the trailing newline) or null to delete it.
 * @param {Range} rng an optional range. Defaults to the whole document if omitted.
 * @memberOf Recipe
 */
Recipe.prototype.foreachLine = function(rng, f) {
  
};

/**
 * Replace text in `rng` with `replacement`, optionally recording the operation for undo.
 *
 * @param {Range} rng the range of text you want to replace.
 * @param {String} replacement the text to replace it with.
 * @param {Bool} recordUndo **Optional** whether or not to record the operation for undo (default is true).
 * @memberOf Recipe
 */
Recipe.prototype.replaceTextInRange = function(rng, replacement, recordUndo) {
  
};

/**
 * Delete text in range `rng`, optionally recording the operation for undo.
 *
 * @param {Range} rng the range of text to delete.
 * @param {Bool} recordUndo whether or not to record the operation for undo (default is true).
 * @memberOf Recipe
 */
Recipe.prototype.deleteTextInRange = function(rng, recordUndo) {
  
};

/*
 * Insert text at specified location, optionally recording the operation for undo.
 *
 * @param {Number} location the location at which to insert the new text.
 * @param {String} newText the text to insert at `location`.
 * @param {Bool} recordUndo whether or not to record the operation for undo (default is true).
 * @memberOf Recipe
 */
Recipe.prototype.insertTextAtLocation = function(location, newText, recordUndo) {
  
};