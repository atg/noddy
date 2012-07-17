var Storage = function() {
    this.storage = {};
};

global.Storage = Storage;

/**
 * Retrieves a value in the storage.
 *
 * @param {String} k the key to retrieve.
 * @return {Object} the value for the given key.
 * @memberOf Storage
 */
Storage.prototype.get = function(k) {
    return this.storage[k];
};

/**
 * Sets a value in the storage.
 *
 * @param {String} k the key to set.
 * @param {Object} v the value to set it to (can be anything).
 * @memberOf Storage
 */
Storage.prototype.set = function(k, v) {
    this.storage[k] = v;
}

/**
 * Returns the number of keys in the storage.
 *
 * @return {Number} number of keys in storage.
 * @memberOf Storage
 */
Storage.prototype.count = function() {
    return Object.keys(this.storage).length;
}

/**
 * Applies function `f` to every items in the storage. The function should
 * have the following signature: `f(k, v)` where k is the key for the item
 * and v is its value.
 *
 * @param {Function} f the function to apply to each items `f(k,v)`.
 * @memberOf Storage
 */
Storage.prototype.forall = function(f) {
    for (var k in this.storage) {
        f(k, this.storage[k]);
    }
}