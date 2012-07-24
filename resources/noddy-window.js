window.noddy_private = {};
window.noddy_private.callbacks = {}
window.onMessage = function (name, callback) {
    if (noddy_private.callbacks[name] == null) {
        noddy_private.callbacks[name] = []
    }
    noddy_private.callbacks[name][key] = callback;
    return key;
};
window.removeOnMessage = function (key) {
    if (noddy_private.callbacks[name] == null) {
        return;
    }
    delete noddy_private.callbacks[name][key];
}


window.noddy_private_receivedMessage(message_name, arguments) {
    var privcallbacks = window.noddy_private.callbacks[message_name];
    if (privcallbacks == null)
        return;
    
    for (k in privcallbacks) {
        privcallbacks[k].apply({ "message": f }, message_name);
    }
}