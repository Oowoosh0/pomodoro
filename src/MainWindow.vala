public class Pomodoro.MainWindow : Gtk.ApplicationWindow {
    private Timer.Pomodoro pomodoro;
    private Widgets.TimerLabel timer_label;
    private const string WORK_BG_COLOR = "#007367";
    private const string BREAK_BG_COLOR = "#c6262e";
    private const string BG_CSS = """
        @define-color colorBackground %s;

        .bg-color {
            transition: all 250ms ease-in-out;
        }
    """;

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
        pomodoro = new Timer.Pomodoro(10, 5);
        pomodoro.start.connect (on_pomodoro_start);
        pomodoro.pause.connect (on_pomodoro_pause);
        pomodoro.finished.connect (on_pomodoro_finished);

        var header_bar = new Gtk.HeaderBar () {
            decoration_layout = "close:",
            show_close_button = true,
            hexpand = true
        };

        var menu_button = new Gtk.Button.from_icon_name (
            "open-menu-symbolic",
            Gtk.IconSize.SMALL_TOOLBAR
        );

        header_bar.pack_end (menu_button);

        var header_grid = new Gtk.Grid ();
        var header_grid_context = header_grid.get_style_context ();
        header_grid_context.add_class ("titlebar");
        header_grid_context.add_class ("default-decoration");
        header_grid_context.add_class ("bg-color");
        header_grid_context.add_class (Gtk.STYLE_CLASS_FLAT);

        header_grid.add (header_bar);

        timer_label = new Widgets.TimerLabel ();
        timer_label.set_label_seconds (pomodoro.work_time_seconds);
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
        start_pause_button.clicked.connect (() => pomodoro.start_pause_toggle ());

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
        var box_context = box.get_style_context ();
        box_context.add_class ("timer-box");
        box_context.add_class ("bg-color");
        box.pack_start (timer_label, true, true, 0);
        box.pack_start (timer_controls, true, false, 0);

        set_titlebar (header_grid);
        add (box);
        get_style_context ().add_class ("rounded");
     }

     private void on_pomodoro_start () {
         Timeout.add(200, () => {
             timer_label.set_label_seconds (pomodoro.get_remaining_time ());
             return pomodoro.running;
         });
     }

     private void on_pomodoro_pause () {

     }

     private void on_pomodoro_finished () {
        string bg_color = WORK_BG_COLOR;
        switch (pomodoro.state) {
        case Timer.PomodoroState.WORK:
            bg_color = WORK_BG_COLOR;
            break;
        case Timer.PomodoroState.BREAK:
            bg_color = BREAK_BG_COLOR;
            break;
        }

        var css_provider = new Gtk.CssProvider ();
        var break_css = BG_CSS.printf (bg_color);
        try {
            css_provider.load_from_data (break_css, break_css.length);
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        } catch (GLib.Error e) {
            return;
        }
        timer_label.set_label_seconds (pomodoro.get_next_interval_length ());
     }

     private void on_pomodoro_skip_backward () {

     }

     private void on_pomodoro_skip_forward () {

     }
}
