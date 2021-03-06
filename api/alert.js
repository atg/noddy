var Alert = {};
global.Alert = Alert;


/**
 * Shows an alert.
 *
 * Example:
 * 
 *     Alert.show("My Title", "My awesome body!", ["Yes", "No"]);
 *
 * @param {String} title the title of your alert.
 * @param {String} message the body of your alert message.
 * @param {Array} buttons an array of buttons to display. Buttons are displayed from right to left.
 * @return {Number} the index of the button that was clicked. 0 is the right-most button. 
 * @memberOf Alert
 *
 */
Alert.show = function(title, message, buttons) {
    
    return global.objc_msgSendSync(private_get_mixin(), "showAlert:", {
        "title": title,
        "message": message,
        "buttons": buttons
    });
};

