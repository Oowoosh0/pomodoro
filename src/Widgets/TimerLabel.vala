public class Pomodoro.Widgets.TimerLabel : Gtk.Label {
    construct {
        get_style_context ().add_class ("timer-label");
    }

    public void set_label_seconds (int _seconds) {
        int minutes = _seconds / 60;
        int seconds = _seconds % 60;

        label = "%.2i:%.2i".printf (minutes, seconds);
    }
}
