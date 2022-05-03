public class Pomodoro.NotificationManager : Object {
    public static void interval_finished (string notification_text) {
        if (Application.settings.get_boolean ("show-notifications")) {
            var notification = new Notification (notification_text);
            GLib.Application.get_default ().send_notification (
                "com.github.oowoosh0.pomodoro",
                notification
            );
        }
    }
}
