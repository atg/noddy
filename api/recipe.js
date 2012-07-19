// Implement the Recipe class
var Recipe = function() {
    this.selection = null;
    this.jumpToShowSelection = false;
    this.showYellowIndicator = false;
};

global.Recipe = Recipe;

/**
 * Run the recipe
 *
 * @memberOf Recipe
 */
Recipe.run = function() {
    
};

Recipe.prototype.length = function() {
    
};

Recipe.prototype.text = function() {
    
};

/**
 * Returns text in range.
 *
 * @param {Range} rng the desired range.
 * @memberOf Recipe
 */
Recipe.prototype.textInRange = function(rng) {
    
};

Recipe.prototype.rangeOfLinesInRange = function(rng){
  
};
Recipe.prototype.contentRangeOfLinesInRange = function(rng){
  
};
Recipe.prototype.lineIndexesForCharacterRange = function(rng){
  
};


Recipe.prototype.characterRangeForLineIndexes = function(rng) {
  
};

Recipe.prototype.lineMarkersForCharacterRange = function(rng) {
  
};

/**
 * Execute function `f` on lines in range `rng`. If no range is passed, execute the function
 * on all the lines in the document.
 *
 * @param {Function} f a function with a single argument; the line.
 * @param {Range} rng an optional range. Defaults to the whole document if omitted.
 * @memberOf Recipe
 */
Recipe.prototype.foreachLine = function(f, rng) {
  
};

/**
 * Replace text in `rng` with `replacement`, optionally recording the operation for undo.
 *
 * @param {Range} rng the range of text you want to replace.
 * @param {String} replacement the text to replace it with.
 * @param {Bool} recordUndo whether or not to record the operation for undo (Default is true).
 * @memberOf Recipe
 */
Recipe.prototype.replaceTextInRange = function(rng, replacement, recordUndo) {
  
};

/**
 * Delete text in range `rng`, optionally recording the operation for undo.
 *
 * @param {Range} rng the range of text to delete.
 * @param {Bool} recordUndo whether or not to record the operation for undo (Default is true).
 * @memberOf Recipe
 */
Recipe.prototype.deleteTextInRange = function(rng, recordUndo) {
  
};

/*
 * Insert text at specified location, optionally recording the operation for undo.
 *
 * @param {Number} location the location at which to insert the new text.
 * @param {String} newText the text to insert at `location`.
 * @param {Bool} recordUndo whether or not to record the operation for undo (Default is true).
 */
Recipe.prototype.insertTextAtLocation = function(location, newText, recordUndo) {
  
};