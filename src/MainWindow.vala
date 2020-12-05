public class Pomodoro.MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application application) {
        Object (
             application: application,
             title: "Pomodoro",
             width_request: 450,
             height_request: 450,
             resizable: false
        );
    }

     construct {
        var header_bar = new Gtk.HeaderBar () {
            decoration_layout = "close:",
            show_close_button = true
        };

        var header_grid = new Gtk.Grid ();
        var header_grid_context = header_grid.get_style_context ();
        header_grid_context.add_class ("titlebar");
        header_grid_context.add_class ("default-decoration");
        header_grid_context.add_class (Gtk.STYLE_CLASS_FLAT);

        header_grid.add (header_bar);

        var timer_label = new Widgets.TimerLabel ();
        timer_label.set_label_seconds (3435);
        timer_label.yalign = 1;

        var restart_current_button = new Gtk.Button.from_icon_name (
            "media-skip-backward-symbolic",
            Gtk.IconSize.DIALOG
        );
        restart_current_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        var start_pause_button = new Gtk.Button.from_icon_name (
            "media-playback-start-symbolic",
            Gtk.IconSize.DIALOG
        );
        start_pause_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        var skip_current_button = new Gtk.Button.from_icon_name (
            "media-skip-forward-symbolic",
            Gtk.IconSize.DIALOG
        );
        skip_current_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        var timer_controls = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        timer_controls.halign = Gtk.Align.CENTER;
        timer_controls.pack_start (restart_current_button, false, false, 0);
        timer_controls.pack_start (start_pause_button, false, false, 0);
        timer_controls.pack_start (skip_current_button, false, false, 0);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.get_style_context ().add_class ("timer-box");
        box.pack_start (timer_label, true, true, 0);
        box.pack_start (timer_controls, true, false, 0);

        set_titlebar (header_grid);
        add (box);
        get_style_context ().add_class ("rounded");
     }
}
