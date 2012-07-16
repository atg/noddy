var Alert = {};
global.Alert = Alert;

Alert.show = function(title, message, buttons) {
    
    return global.objc_msgSendSync(private_get_mixin(), "showAlert:", {
        "title": title,
        "message": message,
        "buttons": buttons
    });
};

function private_get_mixin() {
    var stacktrace = new Error().stack;
    
    // Find things named /X.chocmixin
    var m = new RegExp("/([^/]+)\\.chocmixin", "i").exec(stacktrace);
    if (m.length >= 2)
        return "NODDYID$$MIXIN$$" + m[1];
    
    return null;
}

// Implement the Recipe class
var Recipe = {};
global.Recipe = Recipe;
// Implement the UI class
var UI = {};
global.UI = UI;
// Implement the MainWindow, Tab, Editor and Document classes
