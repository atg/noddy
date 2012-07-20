// See https://github.com/fileability/chocolat/blob/master/code/multicursor/multicursor.hh#L6
// and https://github.com/fileability/chocolat/blob/master/code/multicursor/multicursor.cc
// for a well proven implementation.

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
 * Is the range valid?
 * 
 * - To be valid, both the `length` and `location` must be >= 0.
 *
 * - `length`, `location` and `length + location` must all be "small" (less than 2^30).
 *
 * - If `documentLength` is specified, `location + length` must not exceed it.
 * 
 * @param {Number} documentLength (optional) check that the indexes of this range are in <code>[0,&nbsp;documentLength)</code>.
 * @return {Boolean} whether the range is valid.
 * @memberOf Range
 */
Range.prototype.isValid = function(documentLength) {
    if (this.length < 0 || this.location < 0)
        return false;
    if (this.length >= 0x40000000 || this.location >= 0x40000000 || this.length + this.location >= 0x40000000)
        return false;
    if (typeof documentLength !== "undefined" && this.length + this.location > documentLength)
        return false;
    return true;
};

/**
 * Is the range's length 0?
 *
 * @return {Boolean} whether the range is empty.
 * @memberOf Range
 */
Range.prototype.isEmpty = function() {
    return this.length === 0;
};

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
 * Returns the last index in the range (`length + location - 1`), or `location` if the range is empty.
 * 
 * @return {Number} the last index in the range.
 * @memberOf Range
 */
Range.prototype.lastIndex = function() {
    if (this.length === 0)
        return this.location;
    return this.location + this.length - 1;
};

/**
 * Test whether the range has a given index. *If the range is empty (`length` is 0), then returns `false`.*
 * 
 * @param {Number} idx the index.
 * @return {Boolean} true if the range contains the given index.
 * @memberOf Range
 */
Range.prototype.hasIndex = function(idx) {
    return this.isValid() && idx >= this.location && this.length > 0 && idx < this.location + this.length;
};

/**
 * Test whether the range has a given index. *If the range is empty (`length` is 0), then it treats it as a range of `length == 1`.*
 * 
 * @param {Number} idx the index.
 * @return {Boolean} true if the range contains the given index.
 * @memberOf Range
 */
Range.prototype.containsIndex = function(idx) {
    return this.isValid() && idx >= this.location && (idx < this.location + this.length || this.length === 0);
};

/**
 * Checks if two ranges's indexes overlap. *If either range is empty, returns `false`.*
 *
 * @param {Range} rng a range.
 * @return {Boolean} whether the given range is overlaps with this range.
 * @memberOf Range
 */
Range.prototype.overlapsWith = function(rng) {
    if (this.length === 0 || rng.length === 0)
        return false;
    return rng.hasIndex(this.lastIndex()) || rng.hasIndex(this.location);
};

/**
 * Checks if two ranges's indexes overlap. *Considers empty ranges as if they were of length `1`.*
 *
 * @param {Range} rng a range.
 * @return {Boolean} whether the given range intersects with this range.
 * @memberOf Range
 */
Range.prototype.intersectsWith = function(rng) {
    if (this.length === 0 && rng.length === 0)
        return this.location === rng.location;
    if (rng.length === 0)
        return this.hasIndex(rng.location);
    if (this.length === 0)
        return rng.hasIndex(this.location);
    
    return rng.hasIndex(this.lastIndex()) || rng.hasIndex(this.location);
};


/**
 * Checks if all indexes of a given range are contained in this range.
 *
 * @param {Range} rng a range.
 * @return {Boolean} whether the given range is contained within this range.
 * @memberOf Range
 */
Range.prototype.containsRange = function(rng) {
    if (!this.isValid() || !rng.isValid())
        return false;
    if (this.isEmpty() && !rng.isEmpty())
        return false;
    return (this.location <= rng.location && rng.lastIndex() <= this.lastIndex());
};

/**
 * Checks if both ranges are equal (treats any two invalid ranges as equal).
 *
 * @param {Range} rng a range.
 * @return {Boolean} whether the given range is equal to this range.
 * @memberOf Range
 */
Range.prototype.equals = function(rng) {
    var thisvalid = this.isValid();
    var rngvalid = rng.isValid();
    if (thisvalid != rngvalid)
        return false;
    if (thisvalid && rngvalid)
        return true;
    return this.location == rng.location && this.length == rng.length;
};

/**
 * Returns a string in the form of `{loc, len}`. For debugging only, do not attempt to parse this string.
 *
 * @return {String} a string representation of the range.
 * @memberOf Range
 */
Range.prototype.toString = function() {
    if (!this.isValid())
        return "{invalid; " + String(this.location) + ", " + String(this.length) + "}";
    else
        return "{" + String(this.location) + ", " + String(this.length) + "}";
};

/**
 * Compare first by `location`, then by `length`. Treats any two invalid ranges as equal.
 *
 * @param {Range} a a range.
 * @param {Range} b another range.
 * @return {Number} <code>-1</code> if <code>a < b</code>, <code>1</code> if <code>a > b</code> or <code>0</code> if <code>a</code> and <code>b</code> are equal.
 * @memberOf Range
 */
Range.compare = function(a, b) {
    if (a.equals(b)) return 0;
    if (!a.isValid()) return 1;
    if (!b.isValid()) return -1;
    else if (a.location < b.location) return -1;
    else if (a.location > b.location) return 1;
    else if (a.length < b.length) return -1;
    else if (a.length > b.length) return 1;
    else return 0;
};



