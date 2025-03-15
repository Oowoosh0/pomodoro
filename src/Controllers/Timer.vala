public class Pomodoro.Controllers.Timer : Object {
    private Models.Interval interval;
    private Views.MainWindow main_window;
    private bool is_running;

    public Timer (Views.MainWindow window) {
        is_running = false;
        main_window = window;
        interval = new Models.Interval (Models.IntervalType.WORK);
    }

    public void toggle () {
        if (is_running) {
            pause ();
        } else {
            start ();
        }
    }

    public void forward () {}

    public void finished () {}

    private void start () {
        main_window.set_start_button_icon ("media-playback-pause-symbolic");
        is_running = true;
    }

    private void pause () {
        main_window.set_start_button_icon ("media-playback-start-symbolic");
        is_running = false;
    }
}
