/**
 * Creates a new Range.
 * 
 * @param {Number} loc the starting location (or index) of the range.
 * @param {Number} len the length of the range.
 */
var Range = function(loc, len) {
    this.location = loc;
    this.length = len;
}

global.Range = Range;

/**
 * Returns the end of the range (i.e. location + length)
 * 
 * @return {Number} the end of the range.
 * @memberOf Range
 */
Range.prototype.max = function() {
    return this.location + this.length;
};

/**
 * Returns the range's location
 * 
 * @return {Number} the location of the range.
 * @memberOf Range
 */
Range.prototype.min = function() {
    return this.location;
};

/**
 * Check if a range is contained in another range.
 *
 * @param {Object} rng a range.
 * @return {Bool} whether the given range is contained within this range.
 * @memberOf Range
 */
Range.prototype.containsRange = function(rng) {
    return (this.location >= rng.location && this.length <= rng.length);
};

