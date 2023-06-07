public class Pomodoro.Widgets.TimerLabel : Gtk.Widget {
    private Gtk.Label label;
    
    construct {
        label = new Gtk.Label ("00:00");
        label.get_style_context ().add_class ("timer-label");
    }

    public void set_label_seconds (int _seconds) {
        int minutes = _seconds / 60;
        int seconds = _seconds % 60;

        label.set_text ("%.2i:%.2i".printf (minutes, seconds));
    }
}
