public class Pomodoro.Widgets.TimerLabel : Gtk.Label {
    construct {
        get_style_context ().add_class ("timer-label");
    }

    public void set_label_seconds (uint _seconds) {
        uint minutes = _seconds / 60;
        uint seconds = _seconds % 60;

        label = @"$minutes:$seconds";
    }
}
