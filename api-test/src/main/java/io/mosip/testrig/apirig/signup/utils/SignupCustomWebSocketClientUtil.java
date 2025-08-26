package io.mosip.testrig.apirig.signup.utils;

import io.mosip.testrig.apirig.utils.WebSocketClientUtil;
import javax.websocket.CloseReason;
import javax.websocket.Session;

public class SignupCustomWebSocketClientUtil extends WebSocketClientUtil {

    public SignupCustomWebSocketClientUtil(String cookie, String subscribeDestination, String sendDestination) {
        super(cookie, subscribeDestination, sendDestination);
    }

    @Override
    public void onClose(Session session, CloseReason closeReason) {
        // Your custom close logic
        System.out.println("Custom close reason: " + closeReason);

        // Call parent’s logic if you want to keep logging/cleanup
        super.onClose(session, closeReason);
    }

    // Provide your own method to close with CloseReason
    public void closeConnection(CloseReason closeReason) {
        try {
            if (getSession() != null && getSession().isOpen()) {
                getSession().close(closeReason);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}