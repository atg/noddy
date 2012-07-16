global.Alert = {};

function private_get_mixin() {
    var stacktrace = new Error().stack;
    
    // Find things named /X.chocmixin
    var m = new RegExp("/([^/]+)\\.chocmixin", "i").exec(stacktrace);
    if (m.length >= 2) {
        console.log("NODDYID$$MIXIN$$" + m[1]);
        return "NODDYID$$MIXIN$$" + m[1];
    }
    return null;
}

global.Alert.show = function(title, message, buttons) {
    
    global.objc_msgSendSync(private_get_mixin(), "showAlert:", {
        "title": title,
        "message": message,
        "buttons": buttons
    });
};

