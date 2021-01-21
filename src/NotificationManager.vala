public class Pomodoro.NotificationManager : Object {
    public static void intervalFinished () {
        if (Application.settings.get_boolean ("show-notifications")) {
            var notification = new Notification ("Pomodoro interval ended");
            GLib.Application.get_default ().send_notification (
                "com.github.oowoosh0.pomodoro",
                notification
            );
        }
    }
}
