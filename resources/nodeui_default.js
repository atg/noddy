var chocolat = {};
chocolat.noddy_private = {};
chocolat.noddy_private.callbacks = {};
chocolat.onMessage = null; //function (name, callback) {
//    if (noddy_private.callbacks[name] == null) {
//        noddy_private.callbacks[name] = []
//    }
//    noddy_private.callbacks[name][key] = callback;
//    return key;
//};

//chocolat.removeOnMessage = function (key) {
//    if (noddy_private.callbacks[name] == null) {
//        return;
//    }
//    delete noddy_private.callbacks[name][key];
//};

chocolat.noddy_private_receivedMessage = function(message_name, arguments) {
//    var privcallbacks = window.noddy_private.callbacks[message_name];
//    if (privcallbacks == null)
//        return;
    
    if (chocolat.onMessage != null)
        chocolat.onMessage(message_name, JSON.parse(arguments)[0]);
    
//    for (var k in privcallbacks) {
//        privcallbacks[k].apply({ "message": message_name }, JSON.parse(arguments));
//    }
};

chocolat.sendMessage = function(message_name, arguments) {
    window.chocprivate.privateSendMessage_arguments_(message_name, JSON.stringify([arguments]));
};
