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
        main_window.set_bg_color (interval.color);
        main_window.set_start_button_icon ("media-playback-start-symbolic");
    }

    private void start () {
        is_running = true;
        Timeout.add (500, () => {
            main_window.set_timer_label (interval.get_remaining_time ());
            return is_running;
        });
        interval.start (forward);
        main_window.set_start_button_icon ("media-playback-pause-symbolic");
    }

    private void pause () {
        is_running = false;
        interval.pause ();
        main_window.set_start_button_icon ("media-playback-start-symbolic");
    }

    private void update_main_window () {
        main_window.set_timer_label (interval.get_remaining_time ());
        main_window.set_bg_color (interval.color);
    }
}
