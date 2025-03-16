public class Pomodoro.Controllers.Timer : Object {
    private Models.Interval interval;
    private Views.MainWindow main_window;
    private bool is_running;

    public Timer (Views.MainWindow window) {
        is_running = false;
        interval = new Models.Interval (Models.IntervalType.WORK, 1);
        main_window = window;
        main_window.show.connect ((t) => {
            main_window.set_timer_label (interval.get_remaining_time ());
            main_window.set_bg_color (interval.color);
        });
    }

    public void toggle () {
        if (is_running) {
            pause ();
        } else {
            start ();
        }
    }

    public void forward () {
        is_running = false;
        interval = interval.next ();
        main_window.set_timer_label (interval.get_remaining_time ());
        main_window.set_interval_type_label (interval.type_string);
        main_window.set_interval_count_label (interval.index, interval.intervals_to_long_break);
        main_window.set_bg_color (interval.color);
        if (App.settings.get_boolean ("autostart-interval")) {
            start ();
        } else {
            main_window.set_start_button_icon ("media-playback-start-symbolic");
        }
    }

    private void start () {
        is_running = true;
        Timeout.add (500, () => {
            main_window.set_timer_label (interval.get_remaining_time ());
            return is_running;
        });
        interval.start (finished);
        main_window.set_start_button_icon ("media-playback-pause-symbolic");
    }

    private void pause () {
        is_running = false;
        interval.pause ();
        main_window.set_start_button_icon ("media-playback-start-symbolic");
    }

    private void finished () {
        if (App.settings.get_boolean ("show-notifications")) {
            var notification = new Notification (interval.message);
            Application.get_default ().send_notification (
                APP_ID,
                notification
            );
        }
        if (App.settings.get_boolean ("raise-window")) {
            main_window.present ();
        }
        forward ();
    }
}
