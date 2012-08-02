var chocolat = {};
chocolat.onMessage = null;
chocolat.noddy_private_receivedMessage = function(message_name, args) {
    if (chocolat.onMessage != null)
        chocolat.onMessage(message_name, JSON.parse(args)[0]);
};

chocolat.sendMessage = function(message_name, args) {
    if (args == null) {
        args = [];
    }
    window.chocprivate.privateSendMessage_arguments_(message_name, JSON.stringify([args]));
};

chocolat.eval = function(code) {
    window.chocprivate.serverEval_(code);
};

chocolat.addFunction = function(name, f) {
    if (arguments.length == 1) {
        f = name;
        name = f.name;
    }
    window.chocprivate.serverAddFunction_named_(f.toString(), name);
};

chocolat.applyFunction = function(f, args) {
    if (args == null) {
        args = [];
    }
    
    if (typeof f === "string") {
        window.chocprivate.serverCallFunctionNamed_jsonArguments_(f, JSON.stringify([args]));
    }
    else {
        window.chocprivate.serverCallFunctionCode_jsonArguments_(f.toString(), JSON.stringify([args]));
    }
};
